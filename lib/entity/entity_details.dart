import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/entity_config.dart';
import 'package:seeder/entity/entity_info.dart';
import 'package:seeder/entity/transaction_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/timeline/timeline.dart';

import '../controls/group.dart';
import 'data_export_button.dart';

final isTranLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class EntityDetails extends ConsumerWidget {
  final String entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Group(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
            EntityInfo(entityId),
            Expanded(
                child: Row(children: [
              Flexible(flex: 1, child: EntityConfig(entityId)),
              Flexible(
                  flex: 3,
                  child: ref.watch(isTranLoading)
                      ? Center(
                          child: Container(
                            alignment: Alignment(0.0, 0.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: [
                            Timeline(entityId),
                            Expanded(
                              flex: 10,
                              child: TransactionList(entityId),
                            ),
                            DataExportButton(entityId),
                          ],
                        ))
            ]))
          ]));
}
