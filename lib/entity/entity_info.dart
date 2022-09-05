import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_text_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/firestore.dart';

class EntityInfo extends ConsumerWidget {
  final String entityId;
  final String currentAuthor = FirebaseAuth.instance.currentUser!.uid;
  EntityInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docFP('entity/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'id',
                          decoration: InputDecoration(hintText: "ID"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'name',
                          decoration: InputDecoration(hintText: "Name"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'desc',
                          decoration: InputDecoration(hintText: "Description"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'bank',
                          decoration: InputDecoration(hintText: "Bank"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'bsb',
                          decoration: InputDecoration(hintText: "BSB"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextEdit(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'account',
                          decoration: InputDecoration(hintText: "Account No"),
                          isEnabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor))
                ],
              ));
}
