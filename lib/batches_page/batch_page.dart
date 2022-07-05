import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/batches_page/batch_details.dart';
import 'package:seeder/batches_page/batch_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: Column(
                    children: [BatchList(), buildAddSetButton(context, ref)],
                  )),
                  Expanded(
                    child: BatchDetails(ref.watch(activeBatch)),
                  )
                ])));
  }

  buildAddSetButton(BuildContext context, WidgetRef ref) {
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
                        FirebaseFirestore.instance.collection('set').add({
                          'id': id_inp.text.toString(),
                          'name': name_inp.text.toString(),
                          'desc': desc_inp.text.toString(),
                          'time Created': FieldValue.serverTimestamp(),
                          'author': FirebaseAuth.instance.currentUser!.uid,
                        }).then((value) => {
                              if (value != null)
                                {
                                  print('sample value: ${value.id}'),
                                  FirebaseFirestore.instance
                                      .collection('set')
                                  //     .doc(value.id)
                                  //     .collection("SelectedEntity")
                                  //     .add({
                                  //   'id': id_inp.text.toString(),
                                  //   'time Created':
                                  //       FieldValue.serverTimestamp(),
                                  //   'author':
                                  //       FirebaseAuth.instance.currentUser!.uid,
                                  // })
                                }
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
