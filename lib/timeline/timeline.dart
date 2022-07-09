import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:seeder/timeline/day.dart';

class Timeline extends ConsumerWidget {
  Jiffy startDate = Jiffy().add(days: -25);
  List<int> days = [for (var i = 1; i <= 30; i++) i];
  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
      children: days
          .map((e) => Positioned(child: Day(startDate.add(days: e))))
          .toList());
}
