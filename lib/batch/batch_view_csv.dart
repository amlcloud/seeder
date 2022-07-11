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
  bool onluonce = true;
  final List<List> exportList = [];
  bool headerOnce = true;
  List listForHeader = [null];

  @override
  Widget build(BuildContext context) {
      bool headerOnce = true;

    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
       
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: ElevatedButton(
              key: null,
              onPressed: () {
                String csv = ListToCsvConverter().convert(exportList).toString();
                Clipboard.setData(ClipboardData(text: csv));

                Fluttertoast.showToast(msg: 'Copied to clipboard');
              },
              child: Row(
                  children: [
                    Text(
                      "Copy To Clipboard  ",
                      style: TextStyle(fontSize: 12.0, color: const Color(0xFF000000), fontWeight: FontWeight.w200, fontFamily: "Roboto"),
                    ),
                    Icon(Icons.content_copy_outlined,
                      color: Colors.black, size: 18.0,
                    )
                  ],
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
                    "Download CSV  ",
                    style: TextStyle(fontSize: 12.0, color: const Color(0xFF000000), fontWeight: FontWeight.w200, fontFamily: "Roboto"),
                  ),
                  Icon(Icons.download,color: Colors.black,
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
              Container(
                  child: ref.watch(colSP('batch/${ref.watch(activeBatch)}/SelectedEntity')).when(
                      loading: () => Text("Loading...."),
                      error: (e, s) => Container(),
                      data: (selectEntities) => selectEntities.size == 0
                          ? Text("No Data Found")
                          : Column(
                              children: selectEntities.docs.map((select) {
                              return ref.watch(colSP('${select.data()['ref'].path}/transaction')).when(
                                  loading: () => Container(),
                                  error: (e, s) => Container(),
                                  data: (entities) => entities.size == 0
                                      ? Container()
                                      : Column(
                                          children: entities.docs.map(
                                            (entity) {
                                              Map<String, dynamic> finalData = {};
                                              ref.watch(docSP(select.data()['ref'].path.toString())).whenData((value) {
                                                finalData.addAll(value.data()!);
                                                finalData.addAll(entity.data());
                                              });
                                              if (headerOnce) {
                                                headerOnce = false;
                                                return Table(border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid, width: 0.5), children: [
                                                  TableRow(
                                                      children: ((finalData.entries.toList().where((element) => element.key.toString() != 'time Created' && element.key.toString() != 'author' && element.key.toString() != 'desc').toList())
                                                            ..sort((a, b) => a.key.compareTo(b.key)))
                                                          .map((values) => Column(children: [Text(values.key.toString(), style: TextStyle(fontSize: 14.0))]))
                                                          .toList())
                                                ]);
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ).toList(),
                                        ));
                            }).toList()))),
              Container(
                  height: 400,
                  child: SingleChildScrollView(
                      child: ref.watch(colSP('batch/${ref.watch(activeBatch)}/SelectedEntity')).when(
                          loading: () => Text("Loading...."),
                          error: (e, s) => Container(),
                          data: (selectEntities) => selectEntities.size == 0
                              ? Container()
                              : Column(
                                  children: selectEntities.docs.map((select) {
                                  return ref.watch(colSP('${select.data()['ref'].path}/transaction')).when(
                                      loading: ()=>Container(),
                                      error: (e, s) => Container(),
                                      data: (entities) => entities.size == 0
                                          ? Text("No data found")
                                          : Column(
                                              children: entities.docs.map(
                                                (entity) {
                                                  Map<String, dynamic> finalData = {};
                                                  ref.watch(docSP(select.data()['ref'].path.toString())).whenData((value) {
                                                    finalData.addAll(value.data()!);
                                                    finalData.addAll(entity.data());
                                                    //print('this is sample ref value${value.data()}');
                                                  });
                                                  List tempdata = [];
                                                  if (onluonce) {
                                                    (finalData.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).forEach((element) {
                                                      tempdata.add(element.key);
                                                    });
                                                    exportList.add(tempdata);
                                                    onluonce = false;
                                                    tempdata = [];
                                                  }
                                                  (finalData.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).forEach((element) {
                                                    tempdata.add(element.value);
                                                  });
                                                  exportList.add(tempdata);
                                                  return Table(border: TableBorder.all(color: Colors.grey, style: BorderStyle.solid, width: 0.5), children: [
                                                    TableRow(
                                                        children: ((finalData.entries.toList().where((element) => element.key.toString() != 'time Created' && element.key.toString() != 'author' && element.key.toString() != 'desc').toList())
                                                              ..sort((a, b) => a.key.compareTo(b.key)))
                                                            .map((values) => Column(children: [Text(values.value.toString(), style: TextStyle(fontSize: 14.0))]))
                                                            .toList())
                                                  ]);
                                                },
                                              ).toList(),
                                            ));
                                }).toList())))),
            ],
          )),
    ]);
  }

  generateCSV(List<List> list) async {
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
