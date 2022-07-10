import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';

class EntityInfo extends ConsumerWidget {
  final String entityId;
  EntityInfo(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              child: DocFieldTextEditDelayed(
                  FirebaseFirestore.instance.doc('entity/${entityId}'), 'id',
                  placeholder: "ID")),
          Flexible(
              child: DocFieldTextEditDelayed(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'name',
            placeholder: "Name",
          )),
          Flexible(
              child: DocFieldTextEditDelayed(
            FirebaseFirestore.instance.doc('entity/${entityId}'),
            'desc',
            placeholder: "Description",
          ))
        ],
      );
}
