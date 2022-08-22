import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/config_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class ConfigList extends ConsumerWidget {
  final String entityId;
  final String configType;
  final bool isEditable;
  const ConfigList(this.entityId, this.configType, this.isEditable);
  @override
  Widget build(BuildContext context, WidgetRef ref){
   
    return ListView(
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
                          '${configType}/${config.id}',
                          entityId,
                          configType,
                          selectedEntityDoc.exists ? true : false,
                          isEditable
                          )))
              .toList()));
}
}