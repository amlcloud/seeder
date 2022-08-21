import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/custom_date_picker.dart';
import 'package:seeder/controls/custom_dropdown.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/random_datas/random_TPT.dart';
import 'package:seeder/random_datas/random_bank_details.dart';
import 'package:seeder/random_datas/random_names.dart';
import 'package:seeder/random_datas/random_streets.dart';
import 'package:seeder/random_datas/random_suburbs.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:intl/intl.dart';

class EditSpecificConfig extends ConsumerWidget {
  EditSpecificConfig(this.entityId, this.configDoc);
  final String entityId;
  final DocumentSnapshot<Map<String, dynamic>> configDoc;

  final TextEditingController amount_inp =
      TextEditingController.fromValue(TextEditingValue(text: "0"));

  final TextEditingController dateTime_inp = TextEditingController.fromValue(
      TextEditingValue(text: DateTime.now().toString()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    amount_inp.text = configDoc.data()!['amount'].toString();
    return AlertDialog(
      scrollable: true,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text('Edit Specific Config...'),
          ),
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('entity')
                    .doc(entityId)
                    .collection('specificConfig')
                    .doc(configDoc.id)
                    .delete()
                    .then((value) => Navigator.of(context).pop());
              },
              icon: Icon(Icons.delete_sharp,
                  color: Theme.of(context).colorScheme.onErrorContainer)),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Text(configDoc.id, style: Theme.of(context).textTheme.headline6),
              TextFormField(
                controller: amount_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              CustomDatePicker('Select date', dateTime_inp)
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection('entity')
                  .doc(entityId)
                  .collection('specificConfig')
                  .doc(configDoc.id)
                  .update({
                'timestamp': DateTime.parse(dateTime_inp.text),
                'amount': double.parse(amount_inp.text)
              }).then((res) {
                print("Done");
                Navigator.of(context).pop();
              });
              print("example: ${configDoc.id}");
            })
      ],
    );
  }
}
