import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_selected_list_item.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

import 'batch_page.dart';

class SelectedEntitiesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref
          .watch(colSP('batch/${ref.watch(activeBatch)}/SelectedEntity'))
          .when(
              loading: () => [Container()],
              error: (e, s) => [ErrorWidget(e)],
              data: (entities) => entities.docs
                  .map((entity) => Card(
                        child: Row(children: [
                          Expanded(
                            child: BatchSelectedListItem(
                                'entity/${entity.id}', ref.watch(activeBatch)!),
                          ),
                          buildDeleteEntityButton(
                            context,
                            ref,
                            FirebaseFirestore.instance
                                .collection('batch')
                                .doc(ref.watch(activeBatch))
                                .collection('SelectedEntity')
                                .doc(entity.id),
                            Icon(Icons.remove),
                          )
                        ]),
                      ))
                  .toList()));
}
