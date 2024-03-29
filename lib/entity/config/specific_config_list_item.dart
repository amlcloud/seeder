import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeder/dialogs/edit_specific_config.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/providers/firestore.dart';

class SpecificConfigListItem extends ConsumerWidget {
  final DocumentSnapshot<Map<String, dynamic>> configDoc;
  final String entityId;
  final String currentAuthor = FirebaseAuth.instance.currentUser!.uid;
  SpecificConfigListItem(
    this.configDoc,
    this.entityId,
  );

  final isAddedToTran = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Card(
        child: Row(children: [
      Expanded(
          child: Column(
        children: [
          ListTile(
              title: Text(configDoc.id.toString()),
              subtitle: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Amount: ${configDoc.data()!['amount']}"),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(formatter
                          .format(configDoc.data()!['timestamp']!.toDate()))),
                ],
              ),
              trailing: Column(
                children: [
                  Text((configDoc.data()!['credit'] == true
                      ? 'Credit'
                      : 'Debit')),
                ],
              )),
        ],
      )),
      Column(
        children: <Widget>[
          configDoc.data()!['author'] == FirebaseAuth.instance.currentUser!.uid
              ? OutlinedButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditSpecificConfig(entityId, configDoc);
                        });
                  },
                )
              : Container(),
          Tooltip(
              waitDuration: const Duration(seconds: 2),
              message: configDoc.id,
              child: Switch(
                  value: configDoc.data()!['isAddedToTran'] ?? false,
                  onChanged: (value) async {
                    String author = '';
                    ref.read(docFP('entity/${entityId}')).whenData((value) {
                      author = value.data()!['author'];
                    });
                    if (author == currentAuthor) {
                      FirebaseFirestore.instance
                          .collection('entity')
                          .doc(entityId)
                          .collection('specificConfig')
                          .doc(configDoc.id)
                          .update({
                        'isAddedToTran':
                            (configDoc.data()!['isAddedToTran']) ?? false
                                ? false
                                : true
                      });
                    }
                  }))
        ],
      )
    ]));
  }
}
