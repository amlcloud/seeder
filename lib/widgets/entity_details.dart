import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/generate_transactions_button.dart';
import 'package:seeder/widgets/transaction_list.dart';

class EntityDetails extends ConsumerWidget {
  final String? entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>

      ///
      entityId == null
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
                      FirebaseFirestore.instance.doc('entity/${entityId}'),
                      'id', placeholder: "ID"),
                  DocFieldTextEditDelayed(
                    FirebaseFirestore.instance.doc('entity/${entityId}'),
                    'name', placeholder: "Name",
                  ),
                  DocFieldTextEditDelayed(
                    FirebaseFirestore.instance.doc('entity/${entityId}'),
                    'desc', placeholder: "Description",
                  ),
                  Divider(),
                  GenerateTransactionsButton(entityId!),
                  Divider(),
                  TransactionList(entityId!)
                ],
              ));
}
