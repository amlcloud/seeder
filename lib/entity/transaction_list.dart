import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class TransactionList extends ConsumerWidget {
  final String entityId;

  const TransactionList(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(colSP('entity/$entityId/transaction')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (trnCol) => trnCol.size == 0
              ? Text('no records')
              : Column(
                  children: [
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: trnCol.docs.first
                    //         .data()
                    //         .entries
                    //         .map((e) => Text(e.key.toString()))
                    //         .toList()),
                    Expanded(
                        child:
                            //  ListView(
                            //     padding: EdgeInsets.zero,
                            //     shrinkWrap: true,
                            //     children: trnCol.docs
                            //         .map((trnDoc) => Transaction(trnDoc))
                            //         .toList()),
                            Column(
                      children: [
                        DataTable(
                            columns: (trnCol.docs.first.data().entries.toList()
                                  ..sort((a, b) => a.key.compareTo(b.key)))
                                .map((value) => DataColumn(
                                      label: Text(
                                        value.key,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ))
                                .toList(),
                            rows: []),
                        Expanded(
                            child: SingleChildScrollView(
                                child: DataTable(
                                    headingRowHeight: 0,
                                    columns: (trnCol.docs.first
                                            .data()
                                            .entries
                                            .toList()
                                          ..sort(
                                              (a, b) => a.key.compareTo(b.key)))
                                        .map((value) => DataColumn(
                                              label: Text(
                                                value.key,
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ))
                                        .toList(),
                                    rows: (trnCol.docs
                                          ..sort((a, b) => a
                                              .data()['day']
                                              .compareTo(b.data()['day'])))
                                        .map((trnDoc) => DataRow(
                                            cells: (trnDoc.data().entries.toList()
                                                  ..sort((a, b) =>
                                                      a.key.compareTo(b.key)))
                                                //.map((cell) => DataCell(Text(cell.value.toString())))

                                                //// **Please Ignor this styling now. This is for just testing purposes**.
                                                .map((cell) => DataCell(cell.value
                                                            .toString() ==
                                                        'Debit'
                                                    ? Text(
                                                        cell.value.toString(),
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                                    : Text(cell.value.toString())))
                                                .toList()))
                                        .toList())))
                      ],
                    ))
                  ],
                ));
}
