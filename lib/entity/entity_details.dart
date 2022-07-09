import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/entity/entity_info.dart';
import 'package:seeder/entity/entity_params.dart';
import 'package:seeder/entity/generate_transactions_button.dart';
import 'package:seeder/entity/transaction_list.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/timeline/timeline.dart';
import 'package:csv/csv.dart';
import 'data_export_csv.dart';

class EntityDetails extends ConsumerWidget {
  final String entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(flex: 1, child: EntityInfo(entityId)),
            Flexible(flex: 1, child: EntityParams()),
            Flexible(
                child: Row(
              children: [GenerateTransactionsButton(entityId)],
            )),
            Divider(),
            Timeline(entityId),
            Expanded(
              flex: 10,
              child: TransactionList(entityId),
            ),
            DataExportButton(entityId),
          ]));
}
