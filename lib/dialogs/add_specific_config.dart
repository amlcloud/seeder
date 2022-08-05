import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiver/time.dart';
import 'package:seeder/common.dart';
import 'package:seeder/field/field_selector.dart';
import 'package:seeder/providers/firestore.dart';

class AddSpecificConfig extends ConsumerWidget {
  final String entityId;
  AddSpecificConfig(this.entityId);
  final List<TextEditingController> controllerList = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
        .instance
        .collection('entity')
        .doc(entityId)
        .collection('fields')
        .get();
    print(data);
    print(FIELDS);

    return AlertDialog(
      scrollable: true,
      title: Text('Adding Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
              children: ref.watch(colSP('field')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (field) => (field.docs
                            ..sort((a, b) =>
                                a.data()['type'].compareTo(b.data()['type'])))
                          .map((fieldEle) {
                        TextEditingController controller =
                            TextEditingController();
                        controllerList.add(controller);
                        return FieldSelector(fieldEle.data()['name'],
                            fieldEle.data()['type'], controller);
                      }).toList())),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
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
      ..sort((a, b) => a.data()['type'].compareTo(b.data()['type']));

    print('example:${fieldData}');
    Map<String, dynamic> trnList = {};
    String Title = 'Title';
    trnList['author'] = FirebaseAuth.instance.currentUser!.uid.toString();

    for (int i = 0; i < fieldData.length; i++) {
      if (fieldData[i].data()['name'] == 'title') {
        Title = controllerList[i].text;
      }
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
          .doc(Title)
          .set(trnList);
      //Navigator.of(context).pop();
      return true;
    }
    return false;
  }
}
