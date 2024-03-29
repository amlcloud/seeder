import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';

class EntityHeadline extends ConsumerWidget {
  final DocumentSnapshot<Map<String, dynamic>> entityDoc;
  const EntityHeadline(this.entityDoc);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entityDoc.data()!['name'] ?? "name"),
        Text(entityDoc.data()!['desc'] ?? "desc",
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        Text(entityDoc.data()!['id'] ?? "id",
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        Text(
            entityDoc.data()!['time Created'] != null
                ? Jiffy(entityDoc.data()!['time Created'].toDate()).yMMMdjm
                : '',
            style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
