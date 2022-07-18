import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:seeder/entity/config_selector.dart';

class AddRecurrentPaymentDialog extends ConsumerWidget {
  final String entityId;
  final TextEditingController name = TextEditingController();

  AddRecurrentPaymentDialog(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
        title: const Text('Deleting entity'),
        content: SizedBox(
            height: 500,
            width: 500,
            child: Column(children: [
              //Expanded(child: ConfigSelector(entityId))
              // Expanded(
              //     child: TextField(
              //   controller: name,
              // )),
              // Expanded(
              //     child: DocFieldTextEdit(
              //         FirebaseFirestore.instance.doc('entity/${entityId}'),
              //         'incomeAmount',
              //         decoration: InputDecoration(hintText: "Income Amount"))),
              // Expanded(child: buildAddDay(ref))
            ])),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              FirebaseFirestore.instance
                  .doc('entity/${entityId}')
                  .collection('config')
                  .add({'name': name.text});
            },
            child: const Text('OK'),
          ),
        ],
      );
}
