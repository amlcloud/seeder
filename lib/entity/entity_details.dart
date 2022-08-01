import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/periodic_config.dart';
import 'package:seeder/entity/config/random_config.dart';
import 'package:seeder/entity/config/specific_config.dart';
import 'package:seeder/entity/entity_info.dart';
import 'package:seeder/entity/generate_transactions.dart';
import 'package:seeder/entity/transaction_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/timeline/timeline.dart';

import '../controls/group.dart';
import 'data_export_csv.dart';

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
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        EntityInfo(entityId),
                        // EntityConfig(entityId),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   mainAxisSize: MainAxisSize.max,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: <Widget>[
                        //     Container(
                        //       margin: EdgeInsets.fromLTRB(0.00, 0.0, 30.0, 0),
                        //       child: Container(),
                        //     )
                        //   ],
                        // ),
                        // Divider(),

                        Expanded(
                          child: PeriodicConfig(entityId),
                        ),
                        Expanded(
                          child: RandomConfig(entityId),
                        ),
                        Expanded(
                          child: SpecificConfig(),
                        ),

                        GenerateTransactions(entityId),
                      ])),
              Flexible(
                  flex: 2,
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
            ],
          )));
}
