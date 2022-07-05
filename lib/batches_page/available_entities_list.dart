import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entity_list_item.dart';

class AvailableEntitiesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('entity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => entities.docs
              .map((entity) => Card(
                    child: Row(children: [
                      Expanded(
                        child: EntityListItem(entity.id),
                      ),
                      IconButton(
                          onPressed: () => fetchEntity(ref, entity.id),
                          icon: Icon(Icons.add))
                    ]),
                  ))
              .toList()));

  fetchEntity(WidgetRef ref, d) async {
    ref.watch(docSP('entity/' + d)).whenData((value) => {
          print("sample add : ${value.data()}"),
          print(
              "sample add : ${value.data()!['id']?.toString()} ${value.data()!['author']?.toString()}"),
          print("Active batch : ${ref.read(activeBatch).toString()}"),
          FirebaseFirestore.instance
              .collection('set')
              .doc(ref.read(activeBatch).toString())
              .collection("SelectedEntity")
              .add({
            'id': value.data()!['id']?.toString(),
            'author': value.data()!['author']?.toString()
          }).then((value) => print("after add: $value"))
        });
  }
}
