import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/available_entities_list.dart';
import 'package:seeder/batch/selected_entities_list.dart';
import 'package:seeder/entity/available_config_list.dart';
import 'package:seeder/entity/selected_config_list.dart';

class ConfigSelector extends ConsumerWidget {
  final String entityId;

  const ConfigSelector(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text('Available entities:'),
                  AvailableConfigList(entityId)
                ],
              )),
          Flexible(
              flex: 1,
              child: Column(children: [
                Text('Selected entities:'),
                SelectedConfigList(entityId)
              ]))
        ],
      );
}
