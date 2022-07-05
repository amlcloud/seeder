import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entities_page.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedListItem extends ConsumerWidget {
  final String entityId;
  const SelectedListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('set/' + entityId+'/SelectedEntity')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : ListTile(
              tileColor: Color.fromARGB(255, 44, 44, 44),
              focusColor: Color.fromARGB(255, 133, 116, 116),
                title: Text(
                  entityDoc.data()!['name'] ?? 'name',
                ),
                trailing: 
                  Column(
                    children: <Widget>[
                    Text(entityDoc.data()!['id'] ?? 'id'),buildDeleteEntityButton(context, ref, entityId)]),
                subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                onTap: () {
                  ref.read(activeEntity.notifier).value = entityId;
                },
              ),
    );
  }

  buildDeleteEntityButton(BuildContext context, WidgetRef ref, id) {
    return IconButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Deleting entity'),
              content:
                  const Text('Are you sure you want to delete this entity?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                      myTransaction.delete(FirebaseFirestore.instance.collection('entity').doc(id));
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.delete),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        );
  }
}