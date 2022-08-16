import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_text_edit.dart';

class EntityInfo extends ConsumerWidget {
  final String entityId;
  const EntityInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: DocFieldTextEdit(
                  FirebaseFirestore.instance.doc('entity/${entityId}'), 'id',
                  decoration: InputDecoration(hintText: "ID"))),
          Flexible(
              child: DocFieldTextEdit(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'name',
            decoration: InputDecoration(hintText: "Name"),
          )),
          Flexible(
              child: DocFieldTextEdit(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'desc',
            decoration: InputDecoration(hintText: "Description"),
          )),
          Flexible(
              child: DocFieldTextEdit(
                  FirebaseFirestore.instance.doc('entity/${entityId}'), 'bank',
                  decoration: InputDecoration(hintText: "Bank"))),
          Flexible(
              child: DocFieldTextEdit(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'account',
            decoration: InputDecoration(hintText: "Account Numver"),
          )),
          Flexible(
              child: DocFieldTextEdit(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'bsb',
            decoration: InputDecoration(hintText: "BSB"),
          ))
        ],
      );
}
