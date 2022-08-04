import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_range_slider.dart';
import 'package:seeder/providers/firestore.dart';

class ConfigListItem extends ConsumerWidget {
  final String path;
  final String entityId;
  final String configType;
  final bool isAdded;
  const ConfigListItem(this.path, this.entityId, this.configType, this.isAdded);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(path)).when(
        loading: () => Text('loading...'),
        error: (e, s) => ErrorWidget(e),
        data: (configDoc) => Card(
                child: Row(children: [
              Expanded(
                  child: Column(
                children: [
                  ListTile(
                      title: Text(configDoc.id.toString()),
                      subtitle: isAdded
                          ? DocFieldRangeSlider(
                              FirebaseFirestore.instance
                                  .collection('entity')
                                  .doc(entityId)
                                  .collection(configType)
                                  .doc(configDoc.id),
                              "minAmount",
                              "maxAmount",
                              configDoc.data()!,
                            )
                          : Text(
                              "Min Amount: ${configDoc.data()!['minAmount']} - Max Amount: ${configDoc.data()!['maxAmount']}"),
                      trailing: Column(
                        children: [
                          Text((configDoc.data()!['credit'] == true
                              ? 'Credit'
                              : 'Debit')),
                          Text(configDoc.data()!['period'])
                        ],
                      )),
                ],
              )),
              Switch(
                  value: isAdded,
                  onChanged: (value) {
                    isAdded
                        ? FirebaseFirestore.instance
                            .runTransaction((Transaction myTransaction) async {
                            myTransaction.delete(FirebaseFirestore.instance
                                .collection('entity')
                                .doc(entityId)
                                .collection(configType)
                                .doc(configDoc.id));
                          })
                        : addEntity(context, ref, configDoc);
                  })
            ])));
  }

  addEntity(BuildContext context, WidgetRef ref, DocumentSnapshot d) async {
    var data = (await FirebaseFirestore.instance.doc(path).get()).data();
    print("hit${data}");
    FirebaseFirestore.instance
        .collection('entity')
        .doc(entityId)
        .collection(configType)
        .doc(d.id)
        .set((await FirebaseFirestore.instance.doc(path).get()).data()!);
  }
}
