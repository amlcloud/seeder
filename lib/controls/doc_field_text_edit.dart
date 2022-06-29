import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldTextEdit extends ConsumerWidget {
  final DocumentReference docRef;
  final String field;
  final TextEditingController ctrl = TextEditingController();

  DocFieldTextEdit(this.docRef, this.field);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('DocFieldTextEdit rebuild');
    return ref
        .watch(docSPdistinct(DocParam(docRef.path, (prev, curr) {
          // print('equals called');
          if (prev.data()![field] == curr.data()![field]) {
            // print('field ${field} did not change, return true');
            return true;
          }
          if (ctrl.text == curr.data()![field]) {
            // print(
            //     'ctrl.text (${ctrl.text}) == snap text (${curr.data()![field]})');
            return true;
          }
          return false;
        })))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (docSnapshot) => TextField(
                  controller: ctrl..text = docSnapshot.data()![field],
                  onChanged: (v) {
                    docRef.update({field: v});
                  },
                ));
  }
}
