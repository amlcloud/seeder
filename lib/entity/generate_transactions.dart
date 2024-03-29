import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:seeder/entity/entity_details.dart';

Future<List<Map<String, dynamic>>> generateTransactions(
    DateTimeRange selectedDateRange, String entityId) async {
  List<Map<String, dynamic>> dataList = [];

  Jiffy startDate = Jiffy(selectedDateRange.start);

  // var weekCounter = selectedDateRange.start.weekday;
  // var monthCounter = selectedDateRange.start.day;

  /// counter must start from the date which user selected
  /// Example: If user select January 23 so the counter start from 23 not from 1 or 0
  /// Example: If user select August 15 and it is 3rd quater so the counter start from 45 not from 1 or 0

  QuerySnapshot<Map<String, dynamic>> transactionFields =
      await FirebaseFirestore.instance.collection("field").get();

  Map<String, dynamic> transactionFieldsAsMap = {};

  transactionFields.docs.forEach((field) {
    transactionFieldsAsMap[field.data()['name']] = field.data()['name'];
  });

  List transactionDays = generateDays(
      Jiffy(selectedDateRange.start), Jiffy(selectedDateRange.end));

  final entity =
      await FirebaseFirestore.instance.collection('entity').doc(entityId).get();

  final periodicTrnConfigs = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('periodicConfig')
      .get();

  final randomTrnConfigs = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('randomConfig')
      .get();

  final specificTrnConfigs = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('specificConfig')
      .get();

  List<Map<String, dynamic>> randWeekList = [];
  List<Map<String, dynamic>> randMonthList = [];
  List<Map<String, dynamic>> randQuaterList = [];

  /// separate periodic list configs into 3 different lists
  List<Map<String, dynamic>> weeklyTrnConfigs =
      await extractPeriodicTrnConfigs(periodicTrnConfigs, "week");
  List<Map<String, dynamic>> monthlyTrnConfigs =
      await extractPeriodicTrnConfigs(periodicTrnConfigs, "month");
  print('monthly configs: ${monthlyTrnConfigs}');
  List<Map<String, dynamic>> quaterlyTrnConfigs =
      await extractPeriodicTrnConfigs(periodicTrnConfigs, "quarter");

  /// separate random List periods
  randWeekList = await generateSeparateRandomList(randomTrnConfigs, "week", 7);
  randMonthList =
      await generateSeparateRandomList(randomTrnConfigs, "month", 28);
  randQuaterList =
      await generateSeparateRandomList(randomTrnConfigs, "quarter", 84);

  ///* Date loop starts at this point_________
  for (Jiffy currentDay in transactionDays) {
    /// add PeriodicData To List
    List<Map<String, dynamic>> periodicWeekData =
        await generatePeriodicTransactions(weeklyTrnConfigs, currentDay,
            currentDay.dateTime.weekday, entity, 'week');
    List<Map<String, dynamic>> periodicMonthData =
        await generatePeriodicTransactions(monthlyTrnConfigs, currentDay,
            currentDay.dateTime.day, entity, 'month');
    List<Map<String, dynamic>> periodicQuaterData =
        await generatePeriodicTransactions(quaterlyTrnConfigs, currentDay,
            dayOfQuarter(currentDay.dateTime), entity, 'quarter');

    /// Add random data to the list
    List<Map<String, dynamic>> randomWeekData = await addRandomDataToList(
        randWeekList, "week", currentDay, currentDay.dateTime.weekday);
    List<Map<String, dynamic>> randomMonthData = await addRandomDataToList(
        randMonthList, "month", currentDay, currentDay.dateTime.day);
    List<Map<String, dynamic>> randomQuaterData = await addRandomDataToList(
        randQuaterList,
        "quarter",
        currentDay,
        dayOfQuarter(startDate.dateTime));

    /// Add specific data to the list
    List<Map<String, dynamic>> specificData =
        await addSpecificDataToList(specificTrnConfigs.docs, currentDay);

    print('Merging');

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
    /// example: week 1 jhon drink coffee on monday, teusday, and friday,
    /// week 2 jhon drink coffee on monday, wednesday, and sunday.
    ///
    if (currentDay.dateTime.weekday == 7) {
      randWeekList =
          await generateSeparateRandomList(randomTrnConfigs, "week", 7);
    }
    if (currentDay.dateTime.day == 28) {
      randMonthList =
          await generateSeparateRandomList(randomTrnConfigs, "month", 28);
    }
    if (dayOfQuarter(startDate.dateTime) == 84) {
      randQuaterList =
          await generateSeparateRandomList(randomTrnConfigs, "quarter", 84);
    }
  }
  return dataList;
}

/// generate Separate List According to the period in PeriodicList
extractPeriodicTrnConfigs(
    QuerySnapshot<Map<String, dynamic>> periodicTrnConfigs, String period) {
  List<Map<String, dynamic>> tempPeriodicList = [];
  periodicTrnConfigs.docs
      .where((weekEl) => weekEl['period'] == period)
      .forEach((element) {
    var temp = element.data();
    temp['config id'] = element.id;
    tempPeriodicList.add(temp);
  });
  print('PeriodicList: ${tempPeriodicList}');
  return tempPeriodicList;
}

/// generate Separate List According to the period in randomList
generateSeparateRandomList(QuerySnapshot<Map<String, dynamic>> randomList,
    String period, int dayCount) {
  print('generate random list...');
  List<Map<String, dynamic>> randPeriodicList = [];
  var random = math.Random();

  randomList.docs
      .where((weekEl) => weekEl['period'] == period)
      .forEach((element) {
    print('generating ${element}...');

    List periodArray = [];
    var temp = element.data();
    temp['config id'] = element.id;
    //temp['benName'] = element.id.toString();

    while (periodArray.length < element['frequency']) {
      int randomWeek = random.nextInt(dayCount) + 1;
      if (!periodArray.contains(randomWeek)) {
        periodArray.add(randomWeek);
      }
    }
    print('period array:  ${periodArray}...');
    temp[period.toLowerCase()] = periodArray;
    randPeriodicList.add(temp);
  });
  print('randList: ${randPeriodicList}');
  return randPeriodicList;
}

///
///
///
generatePeriodicTransactions(List<Map<String, dynamic>> trnConfigs,
    Jiffy currentDay, int dayInPeriod, DS entity, String period) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();

  trnConfigs
      .where((trnConfig) =>
          trnConfig['day'] == dayInPeriod && trnConfig['period'] == period)
      .forEach((configData) {
    print(
        'generating ${period}-ly transactions for ${currentDay.format(DATE_FORMAT)}, dayInPeriod: ${dayInPeriod} for ${configData}');

    Map<String, dynamic> tempMap = {};
    DateTime configDate = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.date,
        random.nextInt(24),
        random.nextInt(60),
        random.nextInt(3600),
        random.nextInt(3600000));
    tempMap['timestamp'] = configDate;
    tempMap['customer_id'] = entity.id;
    tempMap['dayTime'] = "${currentDay.format(DATE_FORMAT)}/${currentDay.EEEE}";
    tempMap.addAll(configData);

    if (configData['credit'] == true) {
      tempMap['Rem_Account'] = configData['account'];
      tempMap['Ben_Account'] = entity.get('account');
      tempMap['Rem_BSB'] = configData['bsb'];
      tempMap['Ben_BSB'] = entity.get('bsb');
      tempMap['Rem_Bank'] = configData['bank'];
      tempMap['Ben_Bank'] = entity.get('bank');
    } else {
      tempMap['Ben_Account'] = configData['account'];
      tempMap['Rem_Account'] = entity.get('account');
      tempMap['Ben_BSB'] = configData['bsb'];
      tempMap['Rem_BSB'] = entity.get('bsb');
      tempMap['Ben_Bank'] = configData['bank'];
      tempMap['Rem_Bank'] = entity.get('bank');
    }

    double amount = configData['minAmount'] == configData['maxAmount']
        ? configData['minAmount']
        : configData['minAmount'] +
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
    temp['config id'] = configData.id;
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
  // ref.read(isTranLoading.notifier).value = true;

  var batch = FirebaseFirestore.instance.batch();
  var deleteBatch = FirebaseFirestore.instance.batch();

  List<Map<String, dynamic>> tranData =
      await generateTransactions(selectedDateRange, entityId);
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

  // ref.read(isTranLoading.notifier).value = false;
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
