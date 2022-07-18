import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/periodic_config.dart';
import 'package:seeder/entity/config/random_config.dart';
import 'package:seeder/entity/config/specific_config.dart';
import 'package:seeder/entity/income.dart';

class EntityConfig extends ConsumerWidget {
  final String entityId;

  const EntityConfig(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
      height: 700,
      width: 1000,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: PeriodicConfig()),
            Flexible(child: RandomConfig()),
            Flexible(child: SpecificConfig())
          ]));
}
