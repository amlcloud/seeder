import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar_old.dart';
import 'package:seeder/batch/batch_details.dart';
import 'package:seeder/batch/batch_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';

import '../main_app_bar.dart';

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MainAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: SingleChildScrollView(
                          child: Column(
                    children: [BatchList(), buildAddBatchButton(context, ref)],
                  ))),
                  Expanded(
                    flex: 3,
                    child: BatchDetails(ref.watch(activeBatch)),
                  )
                ])));
  }

  buildAddBatchButton(BuildContext context, WidgetRef ref) {
    TextEditingController id_inp = TextEditingController();
    TextEditingController name_inp = TextEditingController();
    TextEditingController desc_inp = TextEditingController();
    return ElevatedButton(
      child: Text("Add Batch"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Adding Batch...'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: id_inp,
                          decoration: InputDecoration(labelText: 'ID'),
                        ),
                        TextFormField(
                          controller: name_inp,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          controller: desc_inp,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      child: Text("Submit"),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('batch').add({
                          'id': id_inp.text.toString(),
                          'name': name_inp.text.toString(),
                          'desc': desc_inp.text.toString(),
                          'time Created': FieldValue.serverTimestamp(),
                          'author': FirebaseAuth.instance.currentUser!.uid,
                        }).then((value) => {
                              if (value != null)
                                {FirebaseFirestore.instance.collection('batch')}
                            });

                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      },
    );
  }
}
