import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/batches_page/batch_entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class AvailableEntitiesList extends ConsumerWidget {
  bool isexist(d, v) {
    bool temp = true;
    for (var i = 0; i < v.length; i++) {
      if (v[i].id.toString() == d) {
        temp = false;
        break;
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      
      // children: ref.watch(colSP('entity')).when(
      //     loading: () => [Container()],
      //     error: (e, s) => [ErrorWidget(e)],
      //     data: (entities) => (entities.docs
      //         .map((entity) =>  Card(
      //               child: Row(children: [
      //                 Expanded(
      //                   child: BatchEntityListItem('entity/${entity.id}'),
      //                 ),
      //                 IconButton(
      //                     onPressed: () => fetchEntity(context, ref, entity.id),
      //                     icon: Icon(Icons.add)),
      //               ]),
      //             ))
      //         .toList()))

      children: ref.watch(colSP('entity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => ((ref
              .watch(colSP('batch/${ref.watch(activeBatch)}/SelectedEntity/'))
              .when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (value) => (entities.docs.map((entity) {
                        if (isexist(entity.id.toString(), value.docs)) {
                          return Card(
                            child: Row(children: [
                              Expanded(
                                child:
                                    BatchEntityListItem('entity/${entity.id}'),
                              ),
                              IconButton(
                                  onPressed: () =>
                                      fetchEntity(context, ref, entity.id),
                                  icon: Icon(Icons.add)),
                            ]),
                          );
                        } else {
                          return Container();
                        }
                      }).toList()))))));

  fetchOnlyAvailable(BuildContext context, WidgetRef ref) async {
    var docRef = FirebaseFirestore.instance
        .collection('batch')
        .doc(ref.watch(activeBatch))
        .collection('SelectedEntity');
    var doc = await docRef.get();
    var entRef = FirebaseFirestore.instance.collection('wntity');
    var ent = await entRef.get();
    return ent.docs.where((item) => !doc.docs.contains(item)).toList();
  }

  fetchEntity(BuildContext context, WidgetRef ref, d) async {
    var docRef = FirebaseFirestore.instance
        .collection('batch')
        .doc(ref.watch(activeBatch))
        .collection('SelectedEntity')
        .doc(d);
    var doc = await docRef.get();
    if (!doc.exists) {
      ref.watch(docSP('entity/' + d)).whenData((value) => {
            FirebaseFirestore.instance
                .collection('batch')
                .doc(ref.read(activeBatch).toString())
                .collection("SelectedEntity")
                .doc(d.toString())
                .set({
              'id': value.data()!['id']?.toString(),
              'author': value.data()!['author']?.toString(),
              'desc': value.data()!['desc']?.toString(),
              'name': value.data()!['name']?.toString(),
              'time Created': value.data()!['time Created']?.toString(),
            }, SetOptions(merge: true)),
          });
    }
  }
}
