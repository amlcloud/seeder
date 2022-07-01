import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldTextEditDelayed extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String field;
  final TextEditingController ctrl = TextEditingController();

  DocFieldTextEditDelayed(this.docRef, this.field, {Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocFieldTextEditDelayedState();
}

class DocFieldTextEditDelayedState
    extends ConsumerState<DocFieldTextEditDelayed> {
  Timer? descSaveTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('DocFieldTextEdit rebuild');
    return ref
        .watch(docSPdistinct(DocParam(widget.docRef.path, (prev, curr) {
          //print('equals called');
          if (prev.data()![widget.field] == curr.data()![widget.field]) {
            // print('field ${field} did not change, return true');
            return true;
          }
          if (widget.ctrl.text == curr.data()![widget.field]) {
            return true;
          }
          // print(
          //     'field changed! ctrl: ${widget.ctrl.text}!=${curr.data()![widget.field]}');
          return false;
        })))
        .when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (docSnapshot) {
              return TextField(
                decoration: InputDecoration(hintText: 'field name'),
                controller: widget.ctrl
                  ..text = docSnapshot.data()![widget.field],
                onChanged: (v) {
                  if (descSaveTimer != null && descSaveTimer!.isActive) {
                    descSaveTimer!.cancel();
                  }
                  descSaveTimer = Timer(Duration(milliseconds: 200), () {
                    print('saving...');
                    if (docSnapshot.data() == null ||
                        v != docSnapshot.data()![widget.field]) {
                      Map<String, dynamic> map = {};
                      map[widget.field] = v;
                      // the document will get created, if not exists
                      widget.docRef.set(map, SetOptions(merge: true));
                      // throws exception if document doesn't exist
                      //widget.docRef.update({widget.field: v});
                    }
                  });
                },
              );
            });
  }
}
