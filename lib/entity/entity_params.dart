import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/income.dart';

class EntityParams extends ConsumerWidget {
  final String entityId;

  EntityParams(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: RecurrentIncome(entityId),
                )
              ],
            )),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(child: Text('random spending goes here'))
            ])),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(child: Text('random incoming transaction'))
            ]))
      ]);
}
