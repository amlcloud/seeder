import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_view_csv.dart';
import 'package:seeder/providers/firestore.dart';

class BatchEntityListItem extends ConsumerWidget {
  final String path;
  final String batchId;
  const BatchEntityListItem(this.path, this.batchId);

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
                  child: ListTile(
                      tileColor: Color.fromARGB(255, 44, 44, 44),
                      focusColor: Color.fromARGB(255, 133, 116, 116),
                      title: Text(
                        entityDoc.data()!['name'] ?? 'name',
                      ),
                      trailing: Column(children: <Widget>[Text(entityDoc.data()!['id'] ?? 'id')]),
                      subtitle: Text(entityDoc.data()!['desc'] ?? 'desc')),
                ),
                IconButton(onPressed: () => fetchEntity(context, ref, entityDoc), icon: Icon(Icons.add)),
              ])));
  }

  fetchEntity(BuildContext context, WidgetRef ref, DocumentSnapshot d) async {
    ref.read(toggleGenerate.notifier).value = false;
    var docRef = FirebaseFirestore.instance.collection('batch').doc(batchId).collection('SelectedEntity').doc(d.id);
    var doc = await docRef.get();
    if (!doc.exists) {
      ref.watch(docSP('entity/' + d.id)).whenData((value) => {
            FirebaseFirestore.instance.collection('batch').doc(batchId).collection("SelectedEntity").doc(d.id).set({'ref': d.reference}, SetOptions(merge: true)),
          });
    }
  }
}
