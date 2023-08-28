import 'package:flutter_test/flutter_test.dart';
import 'package:seeder/common.dart';
import 'package:seeder/main.dart';

void main() {
  test('dayOfQuarter', () {
    expect(dayOfQuarter(DateTime(2023, 1, 1)), 1); // First day of Q1
    expect(dayOfQuarter(DateTime(2023, 3, 31)), 90); // Last day of Q1
    expect(dayOfQuarter(DateTime(2023, 4, 1)), 1); // First day of Q2
    expect(dayOfQuarter(DateTime(2023, 6, 30)), 91); // Last day of Q2
    expect(dayOfQuarter(DateTime(2023, 7, 1)), 1); // First day of Q3
    expect(dayOfQuarter(DateTime(2023, 9, 30)), 92); // Last day of Q3
    expect(dayOfQuarter(DateTime(2023, 10, 1)), 1); // First day of Q4
    expect(dayOfQuarter(DateTime(2023, 12, 31)), 92); // Last day of Q4
  });
}
