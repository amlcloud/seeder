import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_entity_list_item.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:seeder/providers/firestore.dart';

class AvailableEntitiesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('entity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => ((ref
              .watch(colSP('batch/${ref.watch(activeBatch)}/SelectedEntity/'))
              .when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (value) => (entities.docs
                      .map(
                        (entity) => ref
                            .watch(docSP(
                                'batch/${ref.watch(activeBatch)!}/SelectedEntity/${entity.id}'))
                            .when(
                                loading: () => Container(),
                                error: (e, s) => ErrorWidget(e),
                                data: (selectedEntityDoc) =>
                                    selectedEntityDoc.exists
                                        ? Container()
                                        : BatchEntityListItem(
                                            'entity/${entity.id}',
                                            ref.watch(activeBatch)!)),
                      )
                      .toList()))))));
}
