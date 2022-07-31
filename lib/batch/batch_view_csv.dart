import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:csv/csv.dart';
import 'package:seeder/providers/selected_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:universal_html/html.dart" as html;

class BatchViewCsv extends ConsumerWidget {
  final String batchId;
  const BatchViewCsv(this.batchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                    key: null,
                    onPressed: () => exportCSV(ref),
                    child: Row(
                      children: [
                        Text(
                          "Copy To Clipboard",
                        ),
                        Icon(
                          Icons.content_copy_outlined,
                          color: Colors.black,
                          size: 18.0,
                        )
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                    key: null,
                    onPressed: () => generateCSV(ref),
                    child: Row(
                      children: [
                        Text(
                          "Download CSV  ",
                        ),
                        Icon(
                          Icons.download,
                          color: Colors.black,
                          size: 18.0,
                        )
                      ],
                    )),
              ),
            ]),
      ),
      Container(
        margin: EdgeInsets.all(20.0),
        child: ref.watch(selectedTransactionList(ref.watch(activeBatch)!)).when(
            loading: () => Text("loading"),
            error: (e, s) => Text("No data found"),
            data: (entities) {
              return DataTable2(
                  columns: batchCsvHeader(entities),
                  rows: batchCsvRows(entities));
            }),
      )
    ]);
  }

  List<DataColumn> batchCsvHeader(List<Map<String, dynamic>> entities) {
    return ((entities.first.entries
            .toList()
            .where((element) =>
                element.key.toString() != 'time Created' &&
                element.key.toString() != 'author' &&
                element.key.toString() != 'desc')
            .toList())
          ..sort((a, b) => a.key.compareTo(b.key)))
        .map((values) => DataColumn(
                label: Text(
              values.key.toString(),
            )))
        .toList();
  }

  List<DataRow> batchCsvRows(List<Map<String, dynamic>> entities) {
    return entities.map((e) {
      return DataRow(
          cells: ((e.entries
                  .toList()
                  .where((element) =>
                      element.key.toString() != 'time Created' &&
                      element.key.toString() != 'author' &&
                      element.key.toString() != 'desc')
                  .toList())
                ..sort((a, b) => a.key.compareTo(b.key)))
              .map((values) => DataCell(Text(
                    values.value.toString(),
                  )))
              .toList());

      //return Container();
    }).toList();
  }

  Future<List<List>> generateListData(WidgetRef ref) async {
    final List<List> exportList = [];
    List temp = [];
    bool headerOnce = true;
    var colRef = await FirebaseFirestore.instance
        .collection('batch')
        .doc(ref.watch(activeBatch)!)
        .collection('SelectedEntity')
        .get();
    for (var element in colRef.docs) {
      var dataRef = await FirebaseFirestore.instance
          .collection("${element.data()['ref'].path}/transaction")
          .get();
      dataRef.docs.forEach((tranData) {
        // print("I am working${tranData.data()}");
        if (headerOnce) {
          (tranData.data().entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key)))
              .forEach((element) {
            temp.add(element.key);
          });
          exportList.add(temp);
          temp = [];
          headerOnce = false;
        }
        (tranData.data().entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key)))
            .forEach((element) {
          temp.add(element.value);
        });
        exportList.add(temp);
        temp = [];
      });
    }
    return exportList;
  }

  exportCSV(WidgetRef ref) async {
    var retrieveData = await generateListData(ref);
    String csv = ListToCsvConverter().convert(retrieveData).toString();
    Clipboard.setData(ClipboardData(text: csv));
    Fluttertoast.showToast(msg: 'Copied to clipboard');
  }

  generateCSV(WidgetRef ref) async {
    var retrieveData = await generateListData(ref);
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
}
