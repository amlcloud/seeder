import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_view_csv.dart';
import 'package:seeder/controls/doc_field_range_slider.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class ConfigListItem extends ConsumerWidget {
  final String path;
  final String batchId;
  final String configType;
  final bool isAdded;
  const ConfigListItem(this.path, this.batchId, this.configType, this.isAdded);
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
                    child: Column(
                  children: [
                    ListTile(
                        tileColor: Color.fromARGB(255, 44, 44, 44),
                        focusColor: Color.fromARGB(255, 133, 116, 116),
                        title: Text(entityDoc.id.toString()),
                        subtitle: isAdded
                            ? DocFieldRangeSlider(
                                FirebaseFirestore.instance
                                    .collection('entity')
                                    .doc(batchId)
                                    .collection(configType)
                                    .doc(entityDoc.id),
                                    
                                "minAmount",
                                "maxAmount",entityDoc.data()!,)
                            : Text(
                                "Min Amoun: ${entityDoc.data()!['minAmount']} - Max Amoun: ${entityDoc.data()!['maxAmount']}"),
                        trailing: Text((entityDoc.data()!['credit'] == true
                            ? 'Credit'
                            : 'Debit'))),
                  ],
                )),
                Switch(
                    value: isAdded,
                    onChanged: (value) {
                      isAdded
                          ? DeleteEntity(
                              context,
                              ref,
                              FirebaseFirestore.instance
                                  .collection('entity')
                                  .doc(batchId)
                                  .collection(configType)
                                  .doc(entityDoc.id),
                            )
                          : addEntity(context, ref, entityDoc);
                    })
              ])));
  }

  addEntity(BuildContext context, WidgetRef ref, DocumentSnapshot d) async {
    var docRef = await FirebaseFirestore.instance
        .collection('entity')
        .doc(batchId)
        .collection(configType)
        .doc(d.id)
        .get();
    if (!docRef.exists) {
      FirebaseFirestore.instance
          .collection('entity')
          .doc(batchId)
          .collection(configType)
          .doc(d.id)
          .set((await FirebaseFirestore.instance.doc(path).get()).data()!);
    }
  }

  DeleteEntity(BuildContext context, WidgetRef ref, doc) {
    FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.delete(doc);
    });
  }
}