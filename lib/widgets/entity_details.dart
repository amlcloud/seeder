import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class EntityDetails extends ConsumerWidget {
  final String entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  EntityDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('entity/1')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Name'),
                    controller: nameCtrl
                      ..text = entityDoc.data()!['name'] ?? '',
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'ID'),
                    controller: idCtrl..text = entityDoc.data()!['id'] ?? '',
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Description'),
                    controller: descCtrl
                      ..text = entityDoc.data()!['desc'] ?? '',
                  ),
                  Divider()
                ],
              )));
  }
}
