import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityListItem extends ConsumerWidget {
  final String entityId;
  const EntityListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: ListTile(
      leading: Icon(Icons.home),
      title: Text('Entity ${entityId}'),
      trailing: ElevatedButton(onPressed: () {}, child: Text('Edit')),
      subtitle: Text('customer with a lot of debt'),
    ));
  }
}
