import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityHeadline extends ConsumerWidget {
  final DocumentSnapshot<Map<String, dynamic>> entityDoc;
  const EntityHeadline(this.entityDoc);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entityDoc.data()!['name'] ?? "name",
            style: TextStyle(fontSize: 18, color: Colors.white)),
        Text(entityDoc.data()!['desc'] ?? "desc"),
        Text(entityDoc.data()!['id'] ?? "id"),
        Text(DateTime.fromMillisecondsSinceEpoch(
                entityDoc.data()!['time Created'].seconds * 1000)
            .toString()
            .substring(0, 19)
            .toString()),
      ],
    );
  }
}
