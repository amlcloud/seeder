import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/entities_selector.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/state/generic_state_notifier.dart';

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
          child: SingleChildScrollView(child: Column(
            children: [
              Text(entityId!),
              DocFieldTextEditDelayed(
                  FirebaseFirestore.instance.doc('batch/${entityId}'), 'id'),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('batch/${entityId}'),
                'name',
              ),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('batch/${entityId}'),
                'desc',
              ),
              Divider(),
              EntitiesSelector(),
              Divider(),
              ElevatedButton(onPressed: () {}, child: Text('Generate')),
              Text("Output:"),
              Card(
                child: Text('CSV output goes here...'),
              ),
              ElevatedButton(
                  onPressed: () {
//copy CSV to clipboard
                  },
                  child: Text('Copy To Clipboard'))
            ],
          )));
}
