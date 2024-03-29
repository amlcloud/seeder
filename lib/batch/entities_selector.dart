import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/available_entities_list.dart';
import 'package:seeder/batch/selected_entities_list.dart';

class EntitiesSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
              child: Column(
            children: [
              Text('Available entities:'),
              Expanded(child: AvailableEntitiesList())
            ],
          )),
          Flexible(
              child: Column(children: [
            Text('Selected entities:'),
            Expanded(child: SelectedEntitiesList())
          ]))
        ],
      );
}
