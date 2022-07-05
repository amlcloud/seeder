import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/entities_page.dart';
import 'package:seeder/providers/firestore.dart';

class BatchListItem extends ConsumerWidget {
  final String setId;
  const BatchListItem(this.setId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('set/' + setId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'batch ' + (entityDoc.data()!['name'] ?? 'name'),
                    ),
                    //trailing: Text(entityDoc.data()!['id'] ?? 'id'),
                    subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                    trailing: Column(children: <Widget>[
                      Text(entityDoc.data()!['id'] ?? 'id'),
                      buildDeleteEntityButton(context, ref, setId)
                    ]),
                    onTap: () {
                      ref.read(activeBatch.notifier).value = setId;
                    },
                  )
                ],
              )));
  }

  buildDeleteEntityButton(BuildContext context, WidgetRef ref, id) {
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
                    myTransaction.delete(
                        FirebaseFirestore.instance.collection('set').doc(id));
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
