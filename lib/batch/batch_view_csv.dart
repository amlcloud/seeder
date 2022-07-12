import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:csv/csv.dart';
import 'package:seeder/providers/selected_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import '../providers/firestore.dart';
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
        child: Column(
          children: <Widget>[
            ref
                .watch(
                    selectedTransactionList(ref.watch(activeBatch).toString()))
                .when(
                    loading: () => Text("loading"),
                    error: (e, s) => Text("No data found"),
                    data: (entities) => Table(
                            border: TableBorder.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 0.5),
                            children: [
                              TableRow(
                                  children: ((entities.first.entries
                                          .toList()
                                          .where((element) =>
                                              element.key.toString() !=
                                                  'time Created' &&
                                              element.key.toString() !=
                                                  'author' &&
                                              element.key.toString() != 'desc')
                                          .toList())
                                        ..sort(
                                            (a, b) => a.key.compareTo(b.key)))
                                      .map((values) => Column(children: [
                                            Text(
                                              values.key.toString(),
                                            )
                                          ]))
                                      .toList())
                            ])),
            ref
                .watch(
                    selectedTransactionList(ref.watch(activeBatch).toString()))
                .when(
                    loading: () => Text("loading"),
                    error: (e, s) => Text("No data found"),
                    data: (entities) {
                      return Container(
                          height: 400,
                          child: SingleChildScrollView(
                              child: Table(
                                  border: TableBorder.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.5),
                                  children: entities.map((e) {
                                    return TableRow(
                                        children: ((e.entries
                                                .toList()
                                                .where((element) =>
                                                    element.key.toString() !=
                                                        'time Created' &&
                                                    element.key.toString() !=
                                                        'author' &&
                                                    element.key.toString() !=
                                                        'desc')
                                                .toList())
                                              ..sort((a, b) =>
                                                  a.key.compareTo(b.key)))
                                            .map((values) => Column(children: [
                                                  Text(
                                                    values.value.toString(),
                                                  )
                                                ]))
                                            .toList());

                                    //return Container();
                                  }).toList())));
                    }),
          ],
        ),
      )
    ]);
  }

  Future<List<List>> generateListData(WidgetRef ref) async {
    final List<List> exportList = [];
    List temp = [];
    bool headerOnce = true;
    ref.watch(selectedTransactionList(ref.watch(activeBatch).toString())).when(
        loading: () => print('Loading transaction...'),
        error: (e, s) => print('Error'),
        data: (entities) {
          entities.forEach((tranData) {
            if (headerOnce) {
              (tranData.entries.toList()
                    ..sort((a, b) => a.key.compareTo(b.key)))
                  .forEach((element) {
                temp.add(element.key);
              });
              exportList.add(temp);
              temp = [];
              headerOnce = false;
            }
            (tranData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
                .forEach((element) {
              // element.key == 't'
              //     ? temp.add(DateTime.parse(element.value.toDate().toString()))
              //     : temp.add(element.value);
              temp.add(element.value);
            });
            exportList.add(temp);
            temp = [];
          });
        });
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
