import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar_old.dart';
import 'package:seeder/controls/custom_dropdown.dart';
import 'package:seeder/feed/feed_info.dart';
import 'package:seeder/feed/feed_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';

import '../main_app_bar.dart';

final activeFeed =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));
final selectedBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class FeedsPage extends ConsumerWidget {
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
                    children: [
                      FeedList(),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: buildAddFeedButton(context, ref),
                      )
                    ],
                  ))),
                  ref.watch(activeFeed) != null
                      ? Expanded(
                          flex: 1,
                          child: FeedInfo(ref.watch(activeFeed)!),
                        )
                      : Expanded(
                          flex: 1,
                          child: Container(),
                        )
                ])));
  }
}

buildAddFeedButton(BuildContext context, WidgetRef ref) {
  TextEditingController id_inp = TextEditingController();
  TextEditingController name_inp = TextEditingController();
  TextEditingController desc_inp = TextEditingController();
  TextEditingController key_inp = TextEditingController();
  TextEditingController url_inp = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  return ElevatedButton(
    child: Text("Add Feed"),
    onPressed: () async {
      var data = await getList();
      List<String> batchList = [];
      data.forEach((element) {
        batchList.add(element.data()['name']);
      });
      batchList = batchList..sort(((a, b) => a.compareTo(b)));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: Text('Adding New Feed...'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: id_inp,
                        decoration: InputDecoration(labelText: 'ID'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ID';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: name_inp,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: desc_inp,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Description';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: url_inp,
                        decoration: InputDecoration(
                          labelText: 'URL',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter URL';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: key_inp,
                        decoration: InputDecoration(
                          labelText: 'API Key',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter API key';
                          }
                          return null;
                        },
                      ),
                      CustomDropdown("Select Batch", batchList, selectedBatch)
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          ref.watch(selectedBatch) != null) {
                        await getList().then((value) {
                          var dataValue = (value.where((element) =>
                              element.data()['name'] ==
                              ref.watch(selectedBatch))).first;
                          print(dataValue.reference);
                          FirebaseFirestore.instance
                              .collection('feedSettings')
                              .add({
                            'id': id_inp.text.toString(),
                            'name': name_inp.text.toString(),
                            'desc': desc_inp.text.toString(),
                            'url': url_inp.text.toString(),
                            'key': key_inp.text.toString(),
                            'batchName': ref.watch(selectedBatch),
                            'batchId': dataValue.id,
                            'time Created': FieldValue.serverTimestamp(),
                            'author': FirebaseAuth.instance.currentUser!.uid,
                          });
                        }).then((value) => Navigator.of(context).pop());
                      }
                    })
              ],
            );
          });
    },
  );
}

Future<List> getList() async {
  var data = await FirebaseFirestore.instance.collection('batch').get();
  return data.docs;
}
