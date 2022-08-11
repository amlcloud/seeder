import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_range_slider.dart';
import 'package:seeder/controls/doc_field_slider.dart';
import 'package:seeder/controls/group.dart';
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
                child: ListTile(
                    title: Text(configDoc.id.toString()),
                    subtitle: isAdded
                        ? ref
                            .watch(docSP(
                                'entity/${entityId}/${configType}/${configDoc.id}'))
                            .when(
                                loading: () => Container(),
                                error: (e, s) => Container(),
                                data: (configField) => Column(
                                      children: <Widget>[
                                        Text(
                                            "Min: ${configField.data()!['minAmount']} - Max: ${configField.data()!['maxAmount']}"),
                                        DocFieldRangeSlider(
                                            FirebaseFirestore.instance
                                                .collection('entity')
                                                .doc(entityId)
                                                .collection(configType)
                                                .doc(configDoc.id),
                                            "minAmount",
                                            "maxAmount",
                                            double.parse(configDoc
                                                .data()!['minAmount']!
                                                .toString()),
                                            double.parse(configDoc
                                                .data()!['maxAmount']!
                                                .toString())
                                            //configDoc.data()!,
                                            ),
                                        configType == 'randomConfig'
                                            ? Column(
                                                children: <Widget>[
                                                  Text(
                                                      "Frequency: ${configField.data()!['frequency']} days a ${configField.data()!['period']} "),
                                                  DocFieldSlider(
                                                      FirebaseFirestore.instance
                                                          .collection('entity')
                                                          .doc(entityId)
                                                          .collection(
                                                              configType)
                                                          .doc(configDoc.id),
                                                      "frequency",
                                                      configDoc.data()![
                                                                  'period'] ==
                                                              'Week'
                                                          ? 7
                                                          : configDoc.data()![
                                                                      'period'] ==
                                                                  'Month'
                                                              ? 28
                                                              : 84)
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ))
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
              ),
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
    //print("hit${data}");
    FirebaseFirestore.instance
        .collection('entity')
        .doc(entityId)
        .collection(configType)
        .doc(d.id)
        .set((await FirebaseFirestore.instance.doc(path).get()).data()!);
  }
}
