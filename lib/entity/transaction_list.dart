import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:data_table_2/data_table_2.dart';

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
              : DataTable2(
                  columnSpacing: 1,
                  columns: showDataColumn(trnCol),
                  rows: showDataRows(trnCol),
                ));

  List<DataRow> showDataRows(QuerySnapshot<Map<String, dynamic>> trnCol) {
    return trnCol.docs
        .map((trnDoc) => DataRow(
                cells: (trnDoc.data().entries.toList()
                      ..sort((a, b) => a.key.compareTo(b.key)))
                    .map((cell) {
              // print(cell.value);
              if (cell.value is Timestamp) {
                // print(cell.value.runtimeType);
                DateTime d = cell.value.toDate();
                // print(d);
                return DataCell(Text(d.toString()));
              }
              if (cell.key == "Type") {
                return DataCell(Text(
                  cell.value.toString(),
                  style: TextStyle(
                      color:
                          cell.value == "Credit" ? Colors.green : Colors.red),
                ));
              }
              return DataCell(Text(cell.value.toString()));
            }).toList()))
        .toList();
  }

  List<DataColumn> showDataColumn(QuerySnapshot<Map<String, dynamic>> trnCol) {
    var transactionDataMap = trnCol.docs.first.data();
    // print(transactionDataMap.keys);
    var dataColumnNameList = transactionDataMap.keys.toList();
    dataColumnNameList.sort();
    // print(dataEntryList);
    List<DataColumn> dataColumnList = [];
    dataColumnNameList.forEach((columnName) {
      DataColumn dataColumn = DataColumn(
        label: Text(
          columnName,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      dataColumnList.add(dataColumn);
    });
    return dataColumnList;
  }
}
