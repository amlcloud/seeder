import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityDetails extends ConsumerWidget {
  final String entityId;
  const EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Column(
      children: [Text('Entity details')],
    ));
  }
}
