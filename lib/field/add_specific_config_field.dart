import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/common.dart';
import 'package:seeder/field/field_selector.dart';

class AddSpecificConfigField extends ConsumerWidget {
  final String entityId;
  AddSpecificConfigField(this.entityId);
  List<TextEditingController> controllerList = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int count = 1;
    return AlertDialog(
      scrollable: true,
      title: Text('Adding Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Column(
                  children: FIELDS.map((e) {
                TextEditingController controller = TextEditingController();
                controllerList.add(controller);
                return FieldSelector(e['name'], e['type'], controller);
              }).toList()),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
            onPressed: () => addSpecificConfig(context, ref))
      ],
    );
  }

  addSpecificConfig(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> trnList = {};
    String Title = 'Title';
    for (int i = 0; i < FIELDS.length; i++) {
      if (FIELDS[i]['name'] == 'title') {
        Title = controllerList[i].text;
      }
      if (FIELDS[i]['type'] == 'bool') {
        trnList[FIELDS[i]['name']] = controllerList[i].text == 'true';
      } else if (FIELDS[i]['type'] == 'number') {
        trnList[FIELDS[i]['name']] = double.parse(controllerList[i].text);
      } else if (FIELDS[i]['type'] == 'timestamp') {
        trnList[FIELDS[i]['name']] = DateTime.parse(controllerList[i].text);
      } else {
        trnList[FIELDS[i]['name']] = controllerList[i].text;
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
      Navigator.of(context).pop();
    }
  }
}
