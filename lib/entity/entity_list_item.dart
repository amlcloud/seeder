import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/entities_page.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeder/entity/entity_headline.dart';

class EntityListItem extends ConsumerWidget {
  final String entityId;
  const EntityListItem(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('entity/' + entityId)).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => entityDoc.exists == false
              ? Center(child: Text('No entity data exists'))
              : ListTile(
                  trailing: Column(children: <Widget>[
                    IconButton(
                      onPressed: () => {
                        DeleteEntity(
                            context,
                            ref,
                            FirebaseFirestore.instance
                                .collection('entity')
                                .doc(entityId)),
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.delete),
                    )
                  ]),
                  title: EntityHeadline(entityDoc),
                  onTap: () {
                    ref.read(activeEntity.notifier).value = entityId;
                  },
                ),
        );
  }

  Future<bool> CheckSelected() async {
    var batchRef = await FirebaseFirestore.instance.collection('batch').get();
    for (var element in batchRef.docs) {
      var selectList = await FirebaseFirestore.instance
          .collection('batch')
          .doc(element.id)
          .collection('SelectedEntity')
          .doc(entityId)
          .get();
      if (selectList.exists) {
        //temp = false;
        return selectList.exists;
      }
    }
    return false;
  }

  DeleteEntity(BuildContext context, WidgetRef ref, doc) async {
    bool temp = await CheckSelected();
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => !temp
            ? AlertDialog(
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
                      ref.read(activeEntity.notifier).value = null;
                      FirebaseFirestore.instance
                          .runTransaction((Transaction myTransaction) async {
                        myTransaction.delete(doc);
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Warning!'),
                content: const Text(
                    'The action cannot be completed because this entity selected in the Batch list'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
  }
}

buildDeleteEntityButton(BuildContext context, WidgetRef ref, doc, button) {
  return IconButton(
    onPressed: () {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Deleting entity'),
          content: const Text('Are you sure you want to delete this entity?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                FirebaseFirestore.instance
                    .runTransaction((Transaction myTransaction) async {
                  myTransaction.delete(doc);
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
    icon: button,
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
  );
}
