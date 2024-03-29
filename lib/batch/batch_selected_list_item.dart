import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

import 'package:seeder/entity/entity_headline.dart';

class BatchSelectedListItem extends ConsumerWidget {
  final String path;
  final String batchId;
  const BatchSelectedListItem(this.path, this.batchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child: Row(children: [
                Expanded(
                  child: ListTile(
                      tileColor: Color.fromARGB(255, 44, 44, 44),
                      focusColor: Color.fromARGB(255, 133, 116, 116),
                      title: EntityHeadline(entityDoc)),
                ),
              ])));
  }
}
