import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:seeder/entity/entity_details.dart';

generate(DateTimeRange selectedDateRange, String entityId) async {
  List<Map<String, dynamic>> dataList = [];
  var random = math.Random();

  var weekCounter = 1;
  var monthCounter = 1;
  var quaterCounter = 1;

  List<Map<String, dynamic>> weekList = [];
  List<Map<String, dynamic>> monthList = [];
  List<Map<String, dynamic>> quaterList = [];

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

  periodicList.docs
      .where((weekEl) => weekEl['period'] == 'Week')
      .forEach((element) {
    var temp = element.data();
    temp['benName'] = element.id.toString();
    temp['week'] = random.nextInt(7);
    weekList.add(temp);
  });

  periodicList.docs
      .where((weekEl) => weekEl['period'] == 'Month')
      .forEach((element) {
    var temp = element.data();
    temp['benName'] = element.id.toString();
    temp['month'] = random.nextInt(28);
    monthList.add(temp);
  });

  periodicList.docs
      .where((weekEl) => weekEl['period'] == 'Quarter')
      .forEach((element) {
    var temp = element.data();
    temp['benName'] = element.id.toString();
    temp['quater'] = random.nextInt(84);
    quaterList.add(temp);
  });

  ////* Date loop starts at this point.** /////
  for (Jiffy dateIterator in dates) {
    List<Map<String, dynamic>> periodicWeekData =
        await addDataToList(weekList, "week", dateIterator, weekCounter);
    List<Map<String, dynamic>> periodicMonthData =
        await addDataToList(monthList, "month", dateIterator, monthCounter);
    List<Map<String, dynamic>> periodicQuaterData =
        await addDataToList(quaterList, "quater", dateIterator, quaterCounter);

    dataList.addAll(periodicWeekData);
    dataList.addAll(periodicMonthData);
    dataList.addAll(periodicQuaterData);

    if (weekCounter == 7) {
      weekCounter = 1;
    }
    if (monthCounter == 28) {
      monthCounter = 1;
    }
    if (quaterCounter == 84) {
      quaterCounter = 1;
    }
    quaterCounter++;
    monthCounter++;
    weekCounter++;
  }
  return dataList;
}

addDataToList(List<Map<String, dynamic>> configList, String period,
    Jiffy dateIterator, int Counter) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();

  //print("sample counter $weekCounter");
  configList.where((ele) => ele[period] == Counter).forEach((configData) {
    DateTime configDate = DateTime(
        dateIterator.year,
        dateIterator.month,
        dateIterator.date,
        random.nextInt(24),
        random.nextInt(60),
        random.nextInt(3600),
        random.nextInt(3600000));
    // print("Example time: ${configDate}");
    //print("Example time: ${dateIterator.month}");

    double amount = configData['minAmount'] +
        random.nextInt(configData['maxAmount'] - configData['minAmount']);
    listData.add({
      'amount': amount,
      'ben_name': "Beneficiary",
      'reference': "Example Transaction",
      'rem_name': configData['benName'],
      'Type': configData['credit'] ? "Credit" : "Debit",
      'timestamp': configDate,
      'day': dateIterator.format(DATE_FORMAT),
    });
  });
  return listData;
}

generateRandom(DateTimeRange selectedDateRange, String entityId) async {
  List<Map<String, dynamic>> randomDataList = [];
  var random = math.Random();

  var weekCounter = 0;
  var monthCounter = 0;
  var quaterCounter = 0;

  List<Map<String, dynamic>> randWeekList = [];
  List<Map<String, dynamic>> randMonthList = [];
  List<Map<String, dynamic>> randQuaterList = [];

  List dates = generateDays(
      Jiffy(selectedDateRange.start), Jiffy(selectedDateRange.end));

  var randomList = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('randomConfig')
      .get();

  randomList.docs
      .where((weekEl) => weekEl['period'] == 'Week')
      .forEach((element) {
    List weekArray = [];
    var temp = element.data();
    temp['benName'] = element.id.toString();

    while (weekArray.length < element['frequency']) {
      int randomWeek = random.nextInt(7);
      if (!weekArray.contains(randomWeek)) {
        weekArray.add(randomWeek);
      }
    }
    //temp['week'] = random.nextInt(7);
    temp['week'] = weekArray;
    randWeekList.add(temp);
  });

  randomList.docs
      .where((weekEl) => weekEl['period'] == 'Month')
      .forEach((element) {
    List monthArray = [];
    var temp = element.data();
    temp['benName'] = element.id.toString();

    while (monthArray.length < element['frequency']) {
      int randomWeek = random.nextInt(28);
      if (!monthArray.contains(randomWeek)) {
        monthArray.add(randomWeek);
      }
    }
    temp['month'] = monthArray;
    randMonthList.add(temp);
  });

  randomList.docs
      .where((weekEl) => weekEl['period'] == 'Quarter')
      .forEach((element) {
    List quaterArray = [];
    var temp = element.data();
    temp['benName'] = element.id.toString();

    while (quaterArray.length < element['frequency']) {
      int randomQuater = random.nextInt(84);
      if (!quaterArray.contains(randomQuater)) {
        quaterArray.add(randomQuater);
      }
    }
    temp['quater'] = quaterArray;
    randQuaterList.add(temp);
  });

  print("Random Week list: ${randWeekList}//");
  print("Random Week list: ${randMonthList}//");
  print("Random Week list: ${randQuaterList}//");

  ////* Date loop starts at this point.** /////
  for (Jiffy dateIterator in dates) {
    List<Map<String, dynamic>> randomWeekData = await addRandomDataToList(
        randWeekList, "week", dateIterator, weekCounter);
    List<Map<String, dynamic>> periodicMonthData = await addRandomDataToList(
        randMonthList, "month", dateIterator, monthCounter);
    List<Map<String, dynamic>> randomQuaterData = await addRandomDataToList(
        randQuaterList, "quater", dateIterator, quaterCounter);

    randomDataList.addAll(randomWeekData);
    randomDataList.addAll(periodicMonthData);
    randomDataList.addAll(randomQuaterData);

    if (weekCounter == 7) {
      weekCounter = 0;
    }
    if (monthCounter == 28) {
      monthCounter = 0;
    }
    if (quaterCounter == 84) {
      quaterCounter = 0;
    }
    quaterCounter++;
    monthCounter++;
    weekCounter++;
  }
  return randomDataList;
}

addRandomDataToList(List<Map<String, dynamic>> configList, String period,
    Jiffy dateIterator, int Counter) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();
  configList.forEach((configData) {
    configData[period].where((date) => date == Counter).forEach((config) {
      DateTime configDate = DateTime(
          dateIterator.year,
          dateIterator.month,
          dateIterator.date,
          random.nextInt(24),
          random.nextInt(60),
          random.nextInt(3600),
          random.nextInt(3600000));
      double amount = configData['minAmount'] +
          random.nextInt(configData['maxAmount'] - configData['minAmount']);
      listData.add({
        'amount': amount,
        'ben_name': "Beneficiary",
        'reference': "Example Transaction",
        'rem_name': configData['benName'],
        'Type': configData['credit'] ? "Credit" : "Debit",
        'timestamp': configDate,
        'day': dateIterator.format(DATE_FORMAT),
      });
    });
  });
  return listData;
}

AddTrnsactionToServer(
    DateTimeRange selectedDateRange, String entityId, WidgetRef ref) async {
  ref.read(isTranLoading.notifier).value = true;

  final QuerySnapshot trnCol = await FirebaseFirestore.instance
      .collection('entity/${entityId}/transaction')
      .get();

  for (DocumentSnapshot ds in trnCol.docs) {
    await ds.reference.delete();
  }
  //final periodicData = await generate(selectedDateRange, entityId);
  final randomData = await generateRandom(selectedDateRange, entityId);

  // await periodicData.forEach((element) {
  //   FirebaseFirestore.instance
  //       .collection('entity/${entityId}/transaction')
  //       .add(element);
  //   //print("this is data: $element");
  // });
  await randomData.forEach((element) {
    FirebaseFirestore.instance
        .collection('entity/${entityId}/transaction')
        .add(element);
    //print("this is data: $element");
  });
  ref.read(isTranLoading.notifier).value = false;
}

// monthList
//     .where((dayele) => dayele['monthCounter'] == monthCounter)
//     .forEach((weekData) {
//   //print("I am hited by month");
//   double tempBal = weekData['minAmount'] +
//       random.nextInt(weekData['maxAmount'] - weekData['minAmount']);
//   //print("random amount ${tempBal}");

//   if (addonce) {
//     AddTrnsaction(weekData['benName'], dateIterator, tempBal, tempBal,
//         weekData['credit'] ? "Credit" : "Debit");
//     latestbalance = tempBal;

//     addonce = false;
//   } else {
//     var balance = weekData['credit']!
//         ? latestbalance + tempBal
//         : latestbalance - tempBal;
//     balance = double.parse(balance.toString());
//     //print("is empte ${latestbalance}");

//     AddTrnsaction(weekData['benName'], dateIterator, balance, tempBal,
//         weekData['credit'] ? "Credit" : "Debit");
//     latestbalance = balance.toDouble();
//   }

//   //print("I am printing ${weekData} counter:${weekCounter}");
// });
// print("random data ${quaterCounter}");
