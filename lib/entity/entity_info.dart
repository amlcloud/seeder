import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_text_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:widgets/copy_to_clipboard_widget.dart';
import 'package:widgets/doc_field_text_field.dart';
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
                      child: CopyToClipboardWidget(
                    child: Text(entityDoc.id),
                    text: entityDoc.id,
                  )),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'id',
                          decoration: InputDecoration(hintText: "ID"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'name',
                          decoration: InputDecoration(hintText: "Name"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'desc',
                          decoration: InputDecoration(hintText: "Description"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'bank',
                          decoration: InputDecoration(hintText: "Bank"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'bsb',
                          decoration: InputDecoration(hintText: "BSB"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor)),
                  Flexible(
                      child: DocFieldTextField(
                          FirebaseFirestore.instance.doc('entity/${entityId}'),
                          'account',
                          decoration: InputDecoration(hintText: "Account No"),
                          enabled: entityDoc.exists &&
                              entityDoc.data()!['author'] == currentAuthor))
                ],
              ));
}
