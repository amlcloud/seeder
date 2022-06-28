import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityListItem extends ConsumerWidget {
  final String entityId;
  const EntityListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: ListTile(
      title: Text('John Smith'),
      trailing: Text('12345678'),
      subtitle: Text('description...'),
    ));
  }
}
