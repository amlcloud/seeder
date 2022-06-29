import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityDetails extends ConsumerWidget {
  final String entityId;
  const EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Column(
      children: [
        TextField(decoration: InputDecoration(hintText: 'Name')),
        TextField(decoration: InputDecoration(hintText: 'ID')),
        TextField(decoration: InputDecoration(hintText: 'Description')),
        Divider()
      ],
    ));
  }
}
