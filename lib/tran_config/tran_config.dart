import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:seeder/tran_config/tran_config_page.dart';
import 'package:widgets/doc_print.dart';
import 'package:widgets/doc_stream_widget.dart';

import '../providers/firestore.dart';

class TranConfig extends ConsumerWidget {
  final DocumentSnapshot<Map<String, dynamic>> trnDoc;

  const TranConfig(this.trnDoc);

  @override
  Widget build(BuildContext context, WidgetRef ref) => !trnDoc.exists
      ? Container()
      : ListTile(
          title: GestureDetector(
              onTap: () {
                ref.read(activeTranConfig.notifier).value = trnDoc.reference;
              },
              child: DocPrintWidget2(trnDoc.reference)),
        );
}

class DocPrintWidget2 extends ConsumerWidget {
  final DocumentReference<Map<String, dynamic>> docRef;

  DocPrintWidget2(this.docRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DocStreamWidget(
        docSP(docRef.path), (context, doc) => Text(formatFirestoreDoc2(doc)));
  }
}

String formatFirestoreDoc2(DocumentSnapshot<Map<String, dynamic>> doc) {
  Map<String, dynamic> data = SplayTreeMap.from(
    doc.data()!,
    (a, b) => a.toString().compareTo(b.toString()),
  );

  String jsonString = json.encode(
    data,
    toEncodable: (o) {
      if (o is Timestamp) {
        return Jiffy(o.toDate()).format('yyyy-MM-dd HH:mm:ss');
      }
      return o;
    },
  );

  return JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString));
}
