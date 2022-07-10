import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';

import '../providers/firestore.dart';

class BatchViewCsv extends ConsumerStatefulWidget {
  BatchViewCsv(this.batchId, {Key? key}) : super(key: key);
  final db = FirebaseFirestore.instance;
  final String batchId;
  final List<List<String>> exportList = [
    <String>["amount", "balance", "ben_name", "rem_name"]
  ];

  @override
  BatchViewCsvState createState() => BatchViewCsvState();
}

class BatchViewCsvState extends ConsumerState<BatchViewCsv> {
  final List<List<String>> exportList = [
    <String>["amount", "balance", "ben_name", "rem_name"]
  ];

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
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
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "Download",
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
          margin: EdgeInsets.all(20),
          child: ref.watch(colSP('entity')).when(
              loading: () => Container(),
              error: (e, s) => Container(),
              data: (entities) => entities.size == 0
                  ? Text("No data found")
                  : Column(
                      children: <Widget>[
                        Table(
                            //defaultColumnWidth: FixedColumnWidth(120.0),
                            border: TableBorder.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  children: (entities.docs.first
                                          .data()
                                          .entries
                                          .toList()
                                        ..sort(
                                            (a, b) => a.key.compareTo(b.key)))
                                      .map((values) => Column(children: [
                                            Text(values.key,
                                                style:
                                                    TextStyle(fontSize: 18.0))
                                          ]))
                                      .toList()),
                            ]),
                        Table(
                          //defaultColumnWidth: FixedColumnWidth(120.0),
                          border: TableBorder.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 1),
                          children: entities.docs
                              .map(
                                (entity) => TableRow(
                                    children: (entity.data().entries.toList()
                                          ..sort(
                                              (a, b) => a.key.compareTo(b.key)))
                                        .map((values) => Column(children: [
                                              Text(values.value.toString())
                                            ]))
                                        .toList()),
                              )
                              .toList(),
                        ),
                      ],
                    ))),
    ]);
  }
}
