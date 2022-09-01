import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeder/batch/batch_page.dart';
import "package:universal_html/html.dart" as html;

Future<List<List>> generateListForCsv(WidgetRef ref, String entityId) async {
  final List<List> exportList = [];
  List temp = [];
  bool headerOnce = true;
  var transactionCol = await FirebaseFirestore.instance
      .collection('entity')
      .doc(entityId)
      .collection('transaction')
      .get();
  //var  collection = transactionCol.docs.sort(((a, b) => a.data()['timestamp'].compareTo(b.data()['timestamp'])));
  (transactionCol.docs
        ..sort(
            ((a, b) => a.data()['timestamp'].compareTo(b.data()['timestamp']))))
      .forEach((tranData) {
    print("I am working${tranData.data()}");
    if (headerOnce) {
      (tranData.data().entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
          .forEach((element) {
        temp.add(element.key);
      });
      exportList.add(temp);
      temp = [];
      headerOnce = false;
    }
    (tranData.data().entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
        .forEach((element) {
      if (element.key == 'timestamp') {
        temp.add(element.value.toDate());
      } else {
        temp.add(element.value);
      }
    });
    exportList.add(temp);
    temp = [];
  });

  return exportList;
}

generateClipboardCSV(WidgetRef ref, String entityId) async {
  var retrieveData = await generateListForCsv(ref, entityId);
  String csv = ListToCsvConverter().convert(retrieveData).toString();
  Clipboard.setData(ClipboardData(text: csv));
  Fluttertoast.showToast(msg: 'Copied to clipboard');
}

generateExportCSV(WidgetRef ref, String entityId) async {
  var retrieveData = await generateListForCsv(ref, entityId);
  String csv = ListToCsvConverter().convert(retrieveData).toString();
  String timestamp = DateTime.now().toString();
  final bytes = Utf8Encoder().convert(csv);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'file_$timestamp.csv';
  html.document.body!.children.add(anchor);
  anchor.click();
  html.Url.revokeObjectUrl(url);
}
