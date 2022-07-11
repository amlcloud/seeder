import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/income.dart';

class EntityParams extends ConsumerWidget {
  final String entityId;

  EntityParams(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [Income(entityId), Text('random spending goes here'), Text('random income goes here')]);
}
