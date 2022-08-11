import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/common.dart';
import 'package:seeder/field/field_selector.dart';
import 'package:seeder/providers/firestore.dart';

class EditSpecificConfig extends ConsumerWidget {
  final String entityId;
  final DocumentSnapshot<Map<String, dynamic>> configDoc;
  EditSpecificConfig(this.entityId, this.configDoc);
  final List<TextEditingController> controllerList = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      scrollable: true,
      title: Text('Updating Config...'),
      content: Column(
        children: <Widget>[
          Align(alignment: Alignment.centerLeft, child: Text(configDoc.id)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                  children: ref.watch(colSP('field')).when(
                      loading: () => [Container()],
                      error: (e, s) => [ErrorWidget(e)],
                      data: (field) => (field.docs
                                  .where((element) =>
                                      element.data()['name'] != 'title')
                                  .toList()
                                ..sort((a, b) => a
                                    .data()['type']
                                    .compareTo(b.data()['type'])))
                              .map((fieldEle) {
                            TextEditingController controller =
                                TextEditingController();
                            controllerList.add(controller);
                            controller.text = configDoc
                                .data()![fieldEle.data()['name']]
                                .toString();
                            return FieldSelector(fieldEle.data()['name'],
                                fieldEle.data()['type'], controller);
                          }).toList())),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            child: Text("Update"),
            onPressed: () => addSpecificConfig(context, ref).then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                  }
                }))
      ],
    );
  }

  addSpecificConfig(BuildContext context, WidgetRef ref) async {
    QuerySnapshot<Map<String, dynamic>> field =
        await FirebaseFirestore.instance.collection('field').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> fieldData = field.docs
        .where((element) => element.data()['name'] != 'title')
        .toList()
      ..sort((a, b) => a.data()['type'].compareTo(b.data()['type']));

    //print('example:${fieldData}');
    Map<String, dynamic> trnList = {};

    for (int i = 0; i < fieldData.length; i++) {
      if (fieldData[i].data()['type'] == 'bool') {
        trnList[fieldData[i].data()['name']] = controllerList[i].text == 'true';
      } else if (fieldData[i].data()['type'] == 'number') {
        trnList[fieldData[i].data()['name']] =
            double.parse(controllerList[i].text);
      } else if (fieldData[i].data()['type'] == 'timestamp') {
        trnList[fieldData[i].data()['name']] =
            DateTime.parse(controllerList[i].text);
      } else {
        trnList[fieldData[i].data()['name']] = controllerList[i].text;
      }
    }
    var temp = controllerList.where((element) => element.text.isEmpty);
    if (temp.isEmpty) {
      FirebaseFirestore.instance
          .collection('entity')
          .doc(entityId)
          .collection('specificConfig')
          .doc(configDoc.id)
          .update(trnList);
      return true;
    }
    return false;
  }
}
