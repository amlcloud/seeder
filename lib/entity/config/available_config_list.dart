import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_entity_list_item.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:seeder/entity/config/config_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class AvailableConfigList extends ConsumerWidget {
  final String entityId;
  final String configType;
  const AvailableConfigList(this.entityId, this.configType);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP(configType)).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (configs) => configs.docs
              .map((config) => ref
                  .watch(docSP('entity/${entityId}/${configType}/${config.id}'))
                  .when(
                      loading: () => Container(),
                      error: (e, s) => ErrorWidget(e),
                      data: (selectedEntityDoc) => ConfigListItem(
                              '${configType}/${config.id}', entityId, configType, selectedEntityDoc.exists?true : false)))
              .toList()));


}
