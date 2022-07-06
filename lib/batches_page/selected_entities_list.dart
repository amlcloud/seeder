import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/selected_list_item.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entity_list_item.dart';

import 'batch_page.dart';

class SelectedEntitiesList extends ConsumerWidget {
  //final String setId = 'BUVlUXhvauQzw384GxE7';
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children:
          ref.watch(colSP('set/${ref.watch(activeBatch)}/SelectedEntity')).when(
              loading: () => [Container()],
              error: (e, s) => [ErrorWidget(e)],
              data: (entities) => entities.docs
                  .map((entity) => Card(
                        child: Row(children: [
                          Expanded(
                            child: SelectedListItem(entity.id),
                          ),
                          DeleteSelectedEntityButton(
                              context,
                              FirebaseFirestore.instance
                                  .collection('set')
                                  .doc(ref.watch(activeBatch))
                                  .collection('SelectedEntity')
                                  .doc(entity.id)),
                        ]),
                      ))
                  .toList()));
}

DeleteSelectedEntityButton(BuildContext context, doc) {
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
    icon: Icon(Icons.remove),
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
  );
}
