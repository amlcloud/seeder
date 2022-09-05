import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:seeder/entity/entity_details.dart';

Future<List<Map<String, dynamic>>> generate(
    DateTimeRange selectedDateRange, String entityId) async {
  List<Map<String, dynamic>> dataList = [];

  Jiffy startDate = Jiffy(selectedDateRange.start);

  // var weekCounter = selectedDateRange.start.weekday;
  // var monthCounter = selectedDateRange.start.day;

  /// counter must start from the date which user selected
  /// Example: If user select January 23 so the counter start from 23 not from 1 or 0
  /// Example: If user select August 15 and it is 3rd quater so the counter start from 45 not from 1 or 0

  var quaterCounter = startDate.dayOfYear - (84 * (startDate.quarter - 1));

  //print("Test date 1: ${startDate.dayOfYear - (84 * (startDate.quarter - 1))}");

  QuerySnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore.instance.collection("field").get();
  Map<String, dynamic> mapData = {};
  //print("example data:${data.docs}");
  data.docs.forEach((element) {
    mapData[element.data()['name']] = element.data()['name'];
  });

  List dates = generateDays(
      Jiffy(selectedDateRange.start), Jiffy(selectedDateRange.end));

  var periodicList = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('periodicConfig')
      .get();

  var randomList = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('randomConfig')
      .get();

  var specificList = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('specificConfig')
      .get();

  List<Map<String, dynamic>> randWeekList = [];
  List<Map<String, dynamic>> randMonthList = [];
  List<Map<String, dynamic>> randQuaterList = [];

  /// separate  periodic list periods
  List<Map<String, dynamic>> weekList =
      await generateSeparatePeriodicList(periodicList, "Week", 7);
  List<Map<String, dynamic>> monthList =
      await generateSeparatePeriodicList(periodicList, "Month", 28);
  List<Map<String, dynamic>> quaterList =
      await generateSeparatePeriodicList(periodicList, "Quarter", 84);

  /// separate random List periods
  randWeekList = await generateSeparateRandomList(randomList, "Week", 7);
  randMonthList = await generateSeparateRandomList(randomList, "Month", 28);
  randQuaterList = await generateSeparateRandomList(randomList, "Quarter", 84);

  ///* Date loop starts at this point_________
  for (Jiffy dateIterator in dates) {
    /// add PeriodicData To List
    List<Map<String, dynamic>> periodicWeekData = await addPeriodicDataToList(
        weekList, dateIterator, dateIterator.dateTime.weekday);
    List<Map<String, dynamic>> periodicMonthData = await addPeriodicDataToList(
        monthList, dateIterator, dateIterator.dateTime.day);
    List<Map<String, dynamic>> periodicQuaterData =
        await addPeriodicDataToList(quaterList, dateIterator, quaterCounter);

    /// Add random data to the list
    List<Map<String, dynamic>> randomWeekData = await addRandomDataToList(
        randWeekList, "week", dateIterator, dateIterator.dateTime.weekday);
    List<Map<String, dynamic>> randomMonthData = await addRandomDataToList(
        randMonthList, "month", dateIterator, dateIterator.dateTime.day);
    List<Map<String, dynamic>> randomQuaterData = await addRandomDataToList(
        randQuaterList, "quarter", dateIterator, quaterCounter);

    /// Add specific data to the list
    List<Map<String, dynamic>> specificData =
        await addSpecificDataToList(specificList.docs, dateIterator);

    /// Merging the list together
    dataList.addAll(periodicWeekData);
    dataList.addAll(periodicMonthData);
    dataList.addAll(periodicQuaterData);
    dataList.addAll(randomWeekData);
    dataList.addAll(randomMonthData);
    dataList.addAll(randomQuaterData);
    dataList.addAll(specificData);

    /// sort the list by the time
    // dataList = dataList
    //   ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

    /// DateTime.weekday returns integer number from 1 to 7 , Monday represents 1 and Sunday represents 7.
    /// Have to pick random day for every week/month/quarter
    /// example: Week 1 jhon drink coffee on monday, teusday, and friday,
    /// Week 2 jhon drink coffee on monday, wednesday, and sunday.
    ///
    if (dateIterator.dateTime.weekday == 7) {
      //weekCounter = 1;

      randWeekList = await generateSeparateRandomList(randomList, "Week", 7);
    }
    if (dateIterator.dateTime.day == 28) {
      //monthCounter = 1;

      randMonthList = await generateSeparateRandomList(randomList, "Month", 28);
    }
    if (quaterCounter == 84) {
      quaterCounter = 1;

      randQuaterList =
          await generateSeparateRandomList(randomList, "Quarter", 84);
    }
    quaterCounter++;
    // monthCounter++;
    // weekCounter++;
  }
  return dataList;
}

/// generate Separate List According to the period in PeriodicList
generateSeparatePeriodicList(QuerySnapshot<Map<String, dynamic>> periodicList,
    String period, int dayCount) {
  List<Map<String, dynamic>> tempPeriodicList = [];
  periodicList.docs
      .where((weekEl) => weekEl['period'] == period)
      .forEach((element) {
    var temp = element.data();

    tempPeriodicList.add(temp);
  });
  //print('PeriodicList: ${tempPeriodicList}');
  return tempPeriodicList;
}

/// generate Separate List According to the period in randomList
generateSeparateRandomList(QuerySnapshot<Map<String, dynamic>> randomList,
    String period, int dayCount) {
  List<Map<String, dynamic>> randPeriodicList = [];
  var random = math.Random();
  randomList.docs
      .where((weekEl) => weekEl['period'] == period)
      .forEach((element) {
    List periodArray = [];
    var temp = element.data();
    //temp['benName'] = element.id.toString();

    while (periodArray.length < element['frequency']) {
      int randomWeek = random.nextInt(dayCount) + 1;
      if (!periodArray.contains(randomWeek)) {
        periodArray.add(randomWeek);
      }
    }
    temp[period.toLowerCase()] = periodArray;
    randPeriodicList.add(temp);
  });
  //print('randList: ${randPeriodicList}');
  return randPeriodicList;
}

addPeriodicDataToList(
    List<Map<String, dynamic>> configList, Jiffy dateIterator, int Counter) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();

  configList.where((ele) => ele['day'] == Counter).forEach((configData) {
    Map<String, dynamic> tempMap = {};
    DateTime configDate = DateTime(
        dateIterator.year,
        dateIterator.month,
        dateIterator.date,
        random.nextInt(24),
        random.nextInt(60),
        random.nextInt(3600),
        random.nextInt(3600000));
    tempMap['timestamp'] = configDate;
    tempMap['dayTime'] =
        "${dateIterator.format(DATE_FORMAT)}/${dateIterator.EEEE}";
    tempMap.addAll(configData);
    double amount = configData['minAmount'] +
        random.nextInt(configData['maxAmount'] - configData['minAmount']);
    tempMap['amount'] = amount;
  
    listData.add(tempMap);
  });
  return listData;
}

addRandomDataToList(List<Map<String, dynamic>> configList, String period,
    Jiffy dateIterator, int Counter) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();
  configList.forEach((configData) {
    configData[period].where((date) => date == Counter).forEach((config) {
      Map<String, dynamic> tempMap = {};
      DateTime configDate = DateTime(
          dateIterator.year,
          dateIterator.month,
          dateIterator.date,
          random.nextInt(24),
          random.nextInt(60),
          random.nextInt(3600),
          random.nextInt(3600000));
      tempMap['timestamp'] = configDate;
      tempMap['dayTime'] =
          "${dateIterator.format(DATE_FORMAT)}/${dateIterator.EEEE}";
      tempMap.addAll(configData);
      double amount = configData['minAmount'] +
          random.nextInt(configData['maxAmount'] - configData['minAmount']);
      tempMap['amount'] = amount;
  
      listData.add(tempMap);
    });
  });
  return listData;
}

addSpecificDataToList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> configList,
    Jiffy dateIterator) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();
  configList.forEach((element) {
  });
  configList
      .where((ele) =>
          ele.data()['timestamp'].toDate() == dateIterator.dateTime &&
          ele.data()['isAddedToTran'] == true)
      .forEach((configData) {
    Map<String, dynamic> tempMap = {};
    DateTime configDate = DateTime(
        dateIterator.year,
        dateIterator.month,
        dateIterator.date,
        random.nextInt(24),
        random.nextInt(60),
        random.nextInt(3600),
        random.nextInt(3600000));
    tempMap['timestamp'] = configDate;
    tempMap['period'] = 'specified';
    tempMap['dayTime'] =
        "${dateIterator.format(DATE_FORMAT)}/${dateIterator.EEEE}";
    var temp = configData.data();
    temp.remove('timestamp');
    tempMap.addAll(temp);
    tempMap.remove('isAddedToTran');

    listData.add(tempMap);
  });
  //print("specific data: ${listData}");

  return listData;
}

addTrnsactionToServer(
    DateTimeRange selectedDateRange, String entityId, WidgetRef ref) async {
  ref.read(isTranLoading.notifier).value = true;

  var batch = FirebaseFirestore.instance.batch();
  var deleteBatch = FirebaseFirestore.instance.batch();

  List<Map<String, dynamic>> tranData =
      await generate(selectedDateRange, entityId);
  //print("final data: ${tranData}");
  List<Map<String, dynamic>> commonTranData = [];
  tranData.forEach((elementList) {
    elementList.removeWhere((key, value) =>
        key == "author" ||
        key == "day" ||
        key == "minAmount" ||
        key == "maxAmount" ||
        key == "month" ||
        key == "frequency" ||
        key == "required" ||
        key == "week" ||
        key == "quarter");
    commonTranData.add(elementList);
  });

  print("common elements: ${commonTranData}");
  List<Map<String, dynamic>> finalTranData = calculateBalance(commonTranData);

  final QuerySnapshot trnCol = await FirebaseFirestore.instance
      .collection('entity/${entityId}/transaction')
      .get();
  print("finall elements: ${finalTranData}");

  /// deleting the transaction from the firestore database
  int deleCount = 0;
  for (DocumentSnapshot ds in trnCol.docs) {
    deleteBatch.delete(ds.reference);
    deleCount++;
    if (deleCount > 450) {
      await deleteBatch.commit();
      batch = FirebaseFirestore.instance.batch();
      deleCount = 0;
    }
  }
  await deleteBatch.commit();

  /// Adding the transaction to the firestore database
  int setCount = 0;
  for (var i = 0; i < finalTranData.length; i++) {
    //print("reference test ${periodicData[i]['day']!}");
    batch.set(
        FirebaseFirestore.instance
            .collection('entity/${entityId}/transaction')
            .doc((finalTranData[i]['timestamp']!).toString()),
        finalTranData[i]);
    setCount++;
    if (setCount > 450) {
      await batch.commit();
      batch = FirebaseFirestore.instance.batch();
      setCount = 0;
    }
  }
  await batch.commit();

  ref.read(isTranLoading.notifier).value = false;
}

List<Map<String, dynamic>> calculateBalance(
    List<Map<String, dynamic>> listMapData) {
  List<Map<String, dynamic>> finalTranData = [];
  bool addonce = true;
  List<Map<String, dynamic>> sortedData = listMapData
    ..sort(((a, b) {
      print('sample data: ${a['timestamp']} ${b['timestamp']}');
      //return a['timestamp'].compareTo(b['timestamp']);
      return a['timestamp'].compareTo(b['timestamp']);
    }));
  double previousbalance = 0.00;
  sortedData.forEach((tranData) {
    Map<String, dynamic> tempMap = {};
    double ammount = double.parse(tranData['amount'].toString());
    if (addonce) {
      if (tranData['credit'] == true) {
        tempMap['balance'] = ammount;
        previousbalance = ammount;
        addonce = false;
      } else {
        tempMap['balance'] = -ammount;
        previousbalance = -ammount;
        addonce = false;
      }
    } else {
      if (tranData['credit'] == true) {
        tempMap['balance'] = previousbalance + ammount;
        previousbalance = previousbalance + ammount;
      } else {
        tempMap['balance'] = previousbalance - ammount;
        previousbalance = previousbalance - ammount;
      }
    }
    tempMap.addAll(tranData);
    finalTranData.add(tempMap);
  });

  return finalTranData;
}
