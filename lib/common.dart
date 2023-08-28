import 'package:jiffy/jiffy.dart';

const DATE_FORMAT = 'yyyy-MM-dd';

List<Jiffy> generateWeeks(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(Jiffy(current).add(days: 8)).startOf(Units.WEEK);
  }
  return list;
}

List<Jiffy> generateMonths(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = Jiffy(start).startOf(Units.MONTH);
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 32).startOf(Units.MONTH);
  }
  return list;
}

List<Jiffy> generateDays(Jiffy start, Jiffy end) {
  List<Jiffy> list = [];
  Jiffy current = start;
  for (var i = 0; i < 1000; i++) {
    if (current.isAfter(end)) {
      break;
    }
    list.add(current);
    current = Jiffy(current).add(days: 1).startOf(Units.DAY);
  }
  return list;
}

final DAYS_IN_MONTH = [for (var i = 1; i < 29; i++) i];

final List<Map<String, dynamic>> FIELDS = [
  {'name': 'title', 'type': 'string'},
  {'name': 'ben_name', 'type': "string"},
  {'name': 'rem_name', 'type': "string"},
  {'name': 'amount', 'type': 'number'},
  {'name': 'credit', 'type': "bool"},
  {'name': 'timestamp', 'type': "timestamp"},
  //{'name': 'day', 'type': "string"}
];

// Test 2 failed with:

// Expected: <90>
//   Actual: <0>

// package:matcher                                     expect
// package:flutter_test/src/widget_tester.dart 459:16  expect
// test/common_test.dart 8:5                           main.<fn>
int dayOfQuarterFailTest2(DateTime date) {
  int quarterStartMonth =
      (date.month ~/ 3) * 3 + 1; // Find the start month of the quarter
  DateTime startOfQuarter = DateTime(date.year,
      quarterStartMonth); // Create a DateTime for the start of the quarter
  return date.difference(startOfQuarter).inDays +
      1; // Calculate the difference in days
}

// now this test

// expect(dayOfQuarter(DateTime(2023, 12, 31)), 92); // Last day of Q4

// fails with:
// Expected: <92>
//   Actual: <91>

// package:matcher                                     expect
// package:flutter_test/src/widget_tester.dart 459:16  expect
// test/common_test.dart 14:5                          main.<fn>
int dayOfQuarterFailLastTest1(DateTime date) {
  int quarterStartMonth =
      ((date.month - 1) ~/ 3) * 3 + 1; // Find the start month of the quarter
  DateTime startOfQuarter = DateTime(date.year,
      quarterStartMonth); // Create a DateTime for the start of the quarter
  return date.difference(startOfQuarter).inDays +
      1; // Calculate the difference in days
}

// last test fails again with

// Expected: <92>
//   Actual: <91>

// package:matcher                                     expect
// package:flutter_test/src/widget_tester.dart 459:16  expect
// test/common_test.dart 14:5                          main.<fn>
int dayOfQuarterFailLastTest2(DateTime date) {
  int quarterStartMonth =
      ((date.month - 1) ~/ 3) * 3 + 1; // Find the start month of the quarter
  DateTime startOfQuarter = DateTime(date.year,
      quarterStartMonth); // Create a DateTime for the start of the quarter
  DateTime startOfDay = DateTime(date.year, date.month,
      date.day); // Create a DateTime for the start of the day
  return startOfDay.difference(startOfQuarter).inDays +
      1; // Calculate the difference in days
}

///
/// dayOfQuarter returns the day of the quarter for the given date.
///
int dayOfQuarter(DateTime date) {
  int quarter = (date.month - 1) ~/ 3; // Find the quarter of the year
  DateTime startOfQuarter = DateTime(date.year, quarter * 3 + 1,
      1); // Create a DateTime for the start of the quarter
  return date.difference(startOfQuarter).inDays +
      1; // Calculate the difference in days
}
