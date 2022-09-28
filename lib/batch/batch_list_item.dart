import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/entity/entity_headline.dart';
import 'package:seeder/providers/firestore.dart';

class BatchListItem extends ConsumerWidget {
  final String batchId;
  const BatchListItem(this.batchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('batch/' + batchId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child: Column(
                children: [
                  ListTile(
                    title: EntityHeadline(entityDoc),
                    trailing: Column(children: <Widget>[
                      Text(entityDoc.data()!['id'] ?? 'id'),
                      buildDeleteBatchButton(
                        context,
                        ref,
                        FirebaseFirestore.instance
                            .collection('batch')
                            .doc(batchId),
                      )
                    ]),
                    onTap: () {
                      ref.read(activeBatch.notifier).value = batchId;
                    },
                  )
                ],
              )));
  }
}

buildDeleteBatchButton(
  BuildContext context,
  WidgetRef ref,
  doc,
) {
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
                ref.read(activeBatch.notifier).value = null;
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
    icon: Icon(Icons.delete),
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
  );
}
