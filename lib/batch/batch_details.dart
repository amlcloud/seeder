import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_export.dart';
import 'package:seeder/batch/batch_transactions.dart';
import 'package:seeder/batch/entities_selector.dart';
import 'package:seeder/controls/doc_field_text_edit.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:widgets/doc_field_text_field.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchDetails extends ConsumerWidget {
  final String? entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  BatchDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => entityId == null
      ? Container()
      : Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
          child: /*SingleChildScrollView(
              child: */
              Column(
            children: [
              Row(children: [
                Flexible(
                    child: DocFieldTextField(
                        FirebaseFirestore.instance.doc('batch/${entityId}'),
                        'id')),
                Flexible(
                    child: DocFieldTextField(
                  FirebaseFirestore.instance.doc('batch/${entityId}'),
                  'name',
                )),
                Flexible(
                    child: DocFieldTextField(
                  FirebaseFirestore.instance.doc('batch/${entityId}'),
                  'desc',
                ))
              ]),
              Divider(),
              Flexible(child: EntitiesSelector()),
              Divider(),
              BatchExport(entityId!),
              Divider(),
              Flexible(child: BatchTransactions(entityId!))
            ],
            //)
          ));
}
