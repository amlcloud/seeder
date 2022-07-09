import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                    child: Text(
                      "Open In New Tap",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                    )),
              ),
            ]),
        Container(
            margin: EdgeInsets.all(20),
            child: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Colors.grey, style: BorderStyle.solid, width: 1),
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
                      Text('Rem_name', style: TextStyle(fontSize: 20.0))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('5000')]),
                    Column(children: [Text('3000')]),
                    Column(children: [Text('example benName')]),
                    Column(children: [Text('RemName')]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('5000')]),
                    Column(children: [Text('3000')]),
                    Column(children: [Text('example benName')]),
                    Column(children: [Text('RemName')]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('5000')]),
                    Column(children: [Text('3000')]),
                    Column(children: [Text('example benName')]),
                    Column(children: [Text('RemName')]),
                  ]),
                  TableRow(children: [
                    Column(children: [Text('5000')]),
                    Column(children: [Text('3000')]),
                    Column(children: [Text('example benName')]),
                    Column(children: [Text('RemName')]),
                  ]),
                ]))
      ],
    );
  }
}
