import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_selected_list_item.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class SelectedConfigList extends ConsumerWidget {
  final String entityId;
  SelectedConfigList(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('entity/${entityId}/periodicConfig')).when(
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
                                title: Text(
                                  configDoc.data()['name'] ?? 'name',
                                ),
                                trailing: Column(children: <Widget>[
                                  Text(configDoc.data()['id'] ?? 'id')
                                ]),
                                subtitle:
                                    Text(configDoc.data()['desc'] ?? 'desc')),
                          )
                        ])),
                      ),
                      buildDeleteEntityButton(
                        context,
                        ref,
                        FirebaseFirestore.instance
                            .collection('entity')
                            .doc(entityId)
                            .collection('periodicConfig')
                            .doc(configDoc.id),
                        Icon(Icons.remove),
                      )
                    ]),
                  ))
              .toList()));
}
