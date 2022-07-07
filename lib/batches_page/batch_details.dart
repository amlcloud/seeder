import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/entities_selector.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          child: Column(
            children: [
              Text(entityId!),
              DocFieldTextEditDelayed(
                  FirebaseFirestore.instance.doc('set/${entityId}'), 'id'),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('set/${entityId}'),
                'name',
              ),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('set/${entityId}'),
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
                    List<String> clipboard = [];
                    ref.watch(colSP('entity')).when(
                          loading: () => [Container()],
                          error: (e, s) => [ErrorWidget(e)],
                          data: (entities) => entities.docs
                              .map(
                                (entity) => {
                                  print('data is:' + entity.data().toString()),
                                  clipboard.add(entity.data().toString())
                                },
                              )
                              .toList(),
                        );
                    // final docRef = FirebaseFirestore.instance
                    //     .collection('set/BUVlUXhvauQzw384GxE7/entity')
                    //     .get();
                    // docRef.then(
                    //   (doc) {
                    //     final data = doc.docs.asMap();
                    //     data.forEach((key, value) {
                    //       clipboard.add(value[key].toString());
                    //       print("What is this: " + value[key]);
                    //     });
                    //     //clipboard.add(data.toString());
                    //     print('data is: ' + data.toString());
                    //   },
                    // );
                    Clipboard.setData(
                        ClipboardData(text: clipboard.toString()));

                    Fluttertoast.showToast(msg: 'Copied to clipboard');
                  },
                  child: Text('Copy To Clipboard'))
            ],
          ));
}
