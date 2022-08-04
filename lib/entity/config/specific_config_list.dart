import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/specific_config_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class SpecificConfigList extends ConsumerWidget {
  final String entityId;
  const SpecificConfigList(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children:
          // ref
          //     .watch(colSP(
          //         'specificConfig/${FirebaseAuth.instance.currentUser!.uid}/SpecificCollection'))
          //     .when(
          //         loading: () => [Container()],
          //         error: (e, s) => [ErrorWidget(e)],
          //         data: (configs) => configs.docs
          //             .map((config) =>
          ref.watch(colSP('entity/${entityId}/specificConfig')).when(
              loading: () => [Container()],
              error: (e, s) => [ErrorWidget(e)],
              data: (specificCol) => specificCol.docs.map((configDoc) {
                    print("hit");
                    return SpecificConfigListItem(configDoc,entityId);
                  }).toList()));
  //.toList()));
}
