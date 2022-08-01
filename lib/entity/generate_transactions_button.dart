import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:seeder/entity/entity_details.dart';

generate(DateTimeRange selectedDateRange, String entityId) async {
  List<Map<String, dynamic>> dataList = [];

  Jiffy startDate = Jiffy(selectedDateRange.start);

  // var weekCounter = selectedDateRange.start.weekday;
  // var monthCounter = selectedDateRange.start.day;

  /// counter must start from the date which user selected
  /// Example: If user select January 23 so the counter start from 23 not from 1 or 0
  /// Example: If user select August 15 and it is 3rd quater so the counter start from 45 not from 1 or 0

  var quaterCounter = startDate.dayOfYear - (84 * (startDate.quarter - 1));

  print("Test date 1: ${startDate.dayOfYear - (84 * (startDate.quarter - 1))}");

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

    /// Merging the list together
    dataList.addAll(periodicWeekData);
    dataList.addAll(periodicMonthData);
    dataList.addAll(periodicQuaterData);
    dataList.addAll(randomWeekData);
    dataList.addAll(randomMonthData);
    dataList.addAll(randomQuaterData);

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
  var random = math.Random();
  periodicList.docs
      .where((weekEl) => weekEl['period'] == period)
      .forEach((element) {
    var temp = element.data();
    temp['benName'] = element.id.toString();
    //temp[period.toLowerCase()] = random.nextInt(dayCount);
    tempPeriodicList.add(temp);
  });
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
    temp['benName'] = element.id.toString();

    while (periodArray.length < element['frequency']) {
      int randomWeek = random.nextInt(dayCount) + 1;
      if (!periodArray.contains(randomWeek)) {
        periodArray.add(randomWeek);
      }
    }
    temp[period.toLowerCase()] = periodArray;
    randPeriodicList.add(temp);
  });
  return randPeriodicList;
}

addPeriodicDataToList(
    List<Map<String, dynamic>> configList, Jiffy dateIterator, int Counter) {
  List<Map<String, dynamic>> listData = [];
  var random = math.Random();

  configList.where((ele) => ele['day'] == Counter).forEach((configData) {
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
      'day': "${dateIterator.format(DATE_FORMAT)}/${dateIterator.EEEE}",
    });
  });
  return listData;
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
        'day': "${dateIterator.format(DATE_FORMAT)}/${dateIterator.EEEE}",
      });
    });
  });
  return listData;
}

addTrnsactionToServer(
    DateTimeRange selectedDateRange, String entityId, WidgetRef ref) async {
  ref.read(isTranLoading.notifier).value = true;

  var batch = FirebaseFirestore.instance.batch();
  var deleteBatch = FirebaseFirestore.instance.batch();

  final periodicData = await generate(selectedDateRange, entityId);
  final QuerySnapshot trnCol = await FirebaseFirestore.instance
      .collection('entity/${entityId}/transaction')
      .get();

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
  for (var i = 0; i < periodicData.length; i++) {
    print("reference test ${periodicData[i]['day']!}");
    batch.set(
        FirebaseFirestore.instance
            .collection('entity/${entityId}/transaction')
            .doc((periodicData[i]['timestamp']!).toString()),
        periodicData[i]);
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
