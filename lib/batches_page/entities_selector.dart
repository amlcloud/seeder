import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/available_entities_list.dart';
import 'package:seeder/batches_page/selected_entities_list.dart';

class EntitiesSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        children: [
          Flexible(
              child: Column(
            children: [Text('Available entities:'), AvailableEntitiesList()],
          )),
          Flexible(
              child: Column(children: [
            Text('Selected entities:'),
            SelectedEntitiesList()
          ]))
        ],
      );
}
