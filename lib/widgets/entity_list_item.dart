import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class EntityListItem extends ConsumerWidget {
  final String entityId;
  const EntityListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('entity/'+entityId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            :   Card(
            child: Column(
              children: [
                FlatButton(
                  onPressed:(){
                    print('pressed');
                }, child: ListTile(
                  title: Text(entityDoc.data()!['name'] ?? 'name',),
                  trailing: Text(entityDoc.data()!['id'] ?? 'id'),
                  subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                )),
              ],
            )));


  }
}
