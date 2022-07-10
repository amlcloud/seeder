import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:csv/csv.dart';
import '../providers/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:universal_html/html.dart" as html;

class BatchViewCsv extends ConsumerStatefulWidget {
  BatchViewCsv(this.batchId, {Key? key}) : super(key: key);
  final db = FirebaseFirestore.instance;
  final String batchId;

  @override
  BatchViewCsvState createState() => BatchViewCsvState();
}

class BatchViewCsvState extends ConsumerState<BatchViewCsv> {
  final List<List<String>> exportList = [
    <String>[
      "Entity_Name",
      "Entity_Id",
      "Ammount",
      "Balance",
      "Ben_Name",
      "Rem_Name",
      "Reference",
      "Day",
      "Timestamp"
    ]
  ];

  @override
  Widget build(BuildContext context) {
    //bool onluonce = true;
    return Column(children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: ElevatedButton(
                  key: null,
                  onPressed: () {},
                  child: Text(
                    "Generate",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: ElevatedButton(
                  key: null,
                  onPressed: () {
                    String csv =
                        ListToCsvConverter().convert(exportList).toString();
                    Clipboard.setData(ClipboardData(text: csv));

                    Fluttertoast.showToast(msg: 'Copied to clipboard');
                  },
                  child: Text(
                    "Copy To Clipboard",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: ElevatedButton(
                  key: null,
                  onPressed: () => generateCSV(exportList),
                  child: Row(
                    children: [
                      Text(
                        "Download CSV",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w200,
                            fontFamily: "Roboto"),
                      ),
                      Icon(Icons.download)
                    ],
                  )),
            ),
          ]),
      Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Table(
                border: TableBorder.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 0.5),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Amount', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Balance', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Ben_Name', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('day', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Entity Id', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Entity Name', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Reference', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Rem_Name', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Timestamp', style: TextStyle(fontSize: 20.0))
                    ]),
                  ]),
                ],
              ),
              Container(
                  height: 400,
                  child: SingleChildScrollView(
                      child: ref
                          .watch(colSP(
                              'batch/${ref.watch(activeBatch)}/SelectedEntity'))
                          .when(
                              loading: () => Container(),
                              error: (e, s) => Container(),
                              data: (selectEntities) => selectEntities.size == 0
                                  ? Text("Error")
                                  : Column(
                                      children:
                                          selectEntities.docs.map((select) {
                                      return ref
                                          .watch(colSP(
                                              '${select.data()['ref'].path}/transaction'))
                                          .when(
                                              loading: () => Container(),
                                              error: (e, s) => Container(),
                                              data:
                                                  (entities) =>
                                                      entities.size == 0
                                                          ? Text(
                                                              "No data found")
                                                          : Column(
                                                              children: <
                                                                  Widget>[
                                                                // onluonce
                                                                //     ? Table(
                                                                //         //defaultColumnWidth: FixedColumnWidth(120.0),
                                                                //         border: TableBorder.all(
                                                                //             color: Colors
                                                                //                 .grey,
                                                                //             style: BorderStyle
                                                                //                 .solid,
                                                                //             width:
                                                                //                 1),
                                                                //         children: [
                                                                //             TableRow(
                                                                //                 children:
                                                                //                     (entities.docs.first.data().entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((values) {
                                                                //               onluonce =
                                                                //                   false;
                                                                //               return Column(
                                                                //                   children: [
                                                                //                     Text(values.key, style: TextStyle(fontSize: 18.0, color: Colors.yellow))
                                                                //                   ]);
                                                                //             }).toList()),
                                                                //           ])
                                                                //     : Container(),
                                                                Table(
                                                                  border: TableBorder.all(
                                                                      color: Colors
                                                                          .grey,
                                                                      style: BorderStyle
                                                                          .solid,
                                                                      width:
                                                                          0.5),
                                                                  children:
                                                                      entities
                                                                          .docs
                                                                          .map(
                                                                    (entity) {
                                                                      Map<String,
                                                                              dynamic>
                                                                          finalData =
                                                                          {};

                                                                      ref
                                                                          .watch(docSP(select
                                                                              .data()['ref']
                                                                              .path
                                                                              .toString()))
                                                                          .whenData((value) {
                                                                        finalData
                                                                            .addAll(value.data()!);
                                                                        finalData
                                                                            .addAll(entity.data());

                                                                        print(
                                                                            'this is sample ref value${value.data()}');
                                                                      });

                                                                      exportList
                                                                          .add(<
                                                                              String>[
                                                                        finalData['name']
                                                                            .toString(),
                                                                        finalData['id']
                                                                            .toString(),
                                                                        finalData['amount']
                                                                            .toString(),
                                                                        finalData['balance']
                                                                            .toString(),
                                                                        finalData['ben_name']
                                                                            .toString(),
                                                                        finalData['rem_name']
                                                                            .toString(),
                                                                        finalData['reference']
                                                                            .toString(),
                                                                        finalData['day']
                                                                            .toString(),
                                                                        finalData['t']
                                                                            .toString(),
                                                                      ]);
                                                                      return TableRow(
                                                                          children: ((finalData.entries.toList().where((element) => element.key.toString() != 'time Created' && element.key.toString() != 'author' && element.key.toString() != 'desc').toList())..sort((a, b) => a.key.compareTo(b.key)))
                                                                              .map((values) => Column(children: [
                                                                                    Text(values.value.toString(), style: TextStyle(fontSize: 14.0))
                                                                                  ]))
                                                                              .toList());
                                                                    },
                                                                  ).toList(),
                                                                ),
                                                              ],
                                                            ));
                                    }).toList())))),
            ],
          )),
    ]);
  }

  generateCSV(List<List<String>> list) async {
    String csv = ListToCsvConverter().convert(list).toString();
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
