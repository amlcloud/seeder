import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/batches_page/batch_entity_list_item.dart';
import 'package:seeder/providers/firestore.dart';

class AvailableEntitiesList extends ConsumerWidget {
//   Future<bool> compareEntity(BuildContext context, WidgetRef ref, d) async {
//     bool tempreturn = true;
//     await FirebaseFirestore.instance
//         .collection('set')
//         .doc(ref.watch(activeBatch))
//         .collection('SelectedEntity')
//         .get()
//         .then((value) async => {
//               for (var snapshot in value.docs)
//                 {
//                   await FirebaseFirestore.instance
//                       .collection('set')
//                       .doc(ref.watch(activeBatch))
//                       .collection('SelectedEntity')
//                       .doc(snapshot.id)
//                       .get()
//                       .then((value) => {
//                             if (value.data()!['entityId'].toString() ==
//                                 d.toString())
//                               {tempreturn = false}
//                           })
//                 }
//             });
//     return tempreturn;
//   }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('entity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => (entities.docs
              .map((entity) => Card(
                    child: Row(children: [
                      Expanded(
                        child: BatchEntityListItem('entity/${entity.id}'),
                      ),
                      IconButton(
                          onPressed: () => fetchEntity(context, ref, entity.id),
                          icon: Icon(Icons.add)),
                    ]),
                  ))
              .toList())));

  fetchEntity(BuildContext context, WidgetRef ref, d) async {
    // if (await compareEntity(context, ref, d)) {
    //   ref.watch(docSP('entity/' + d)).whenData((value) => {
    //         FirebaseFirestore.instance
    //             .collection('set')
    //             .doc(ref.read(activeBatch).toString())
    //             .collection("SelectedEntity")
    //             .doc(d.toString())
    //             .set({
    //           'id': value.data()!['id']?.toString(),
    //           'author': value.data()!['author']?.toString(),
    //           'desc': value.data()!['desc']?.toString(),
    //           'name': value.data()!['name']?.toString(),
    //           'time Created': value.data()!['time Created']?.toString(),
    //         },SetOptions(merge: true)),
    //       });
    // }
  // if(FirebaseFirestore.instance.collection('set').doc(ref.watch(activeBatch)).collection('SelectedEntity').doc(d).exists)
   var docRef = FirebaseFirestore.instance.collection('batch').doc(ref.watch(activeBatch)).collection('SelectedEntity').doc(d);
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
            },SetOptions(merge: true)),
          });
   }
  }
}
