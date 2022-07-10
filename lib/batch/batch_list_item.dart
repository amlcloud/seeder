import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/widgets/entity_headline.dart';
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
                      buildDeleteEntityButton(
                          context,
                          FirebaseFirestore.instance
                              .collection('batch')
                              .doc(batchId),
                          Icon(Icons.delete))
                    ]),
                    onTap: () {
                      ref.read(activeBatch.notifier).value = batchId;
                    },
                  )
                ],
              )));
  }
}
