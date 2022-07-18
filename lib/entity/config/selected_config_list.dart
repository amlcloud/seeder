import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_selected_list_item.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class SelectedConfigList extends ConsumerWidget {
  final String entityId;
  final String configType;
  const SelectedConfigList(this.entityId, this.configType);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('entity/${entityId}/${configType}')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (selectedConfigs) => selectedConfigs.docs
              .map((configDoc) => Card(
                    child: Row(children: [
                      Expanded(
                        child: Card(
                            child: Row(children: [
                          Expanded(
                            child: ListTile(
                                tileColor: Color.fromARGB(255, 44, 44, 44),
                                focusColor: Color.fromARGB(255, 133, 116, 116),
                                title: Text(configDoc.id.toString()),
                                subtitle: Text(
                                    (configDoc.data()['credit'] == true
                                        ? 'Credit'
                                        : 'Debit'))),
                          ),
                        ])),
                      ),
                      buildDeleteEntityButton(
                        context,
                        ref,
                        FirebaseFirestore.instance
                            .collection('entity')
                            .doc(entityId)
                            .collection(configType)
                            .doc(configDoc.id),
                        Icon(Icons.remove),
                      )
                    ]),
                  ))
              .toList()));
}
