import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_button/group_button.dart';
import 'package:seeder/providers/firestore.dart';

/// datatable showing generated transaction records.
/// where data column will be fixed on the top.
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
                    Expanded(
                        child: Column(
                      children: [
                        // stick table col on the top of page
                        DataTable(columns: showDataColumn(trnCol), rows: []),
                        Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                    headingRowHeight: 0,
                                    columns: showDataColumn(trnCol),
                                    rows: showDataRows(trnCol))))
                      ],
                    ))
                  ],
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

class ColumnSelectionButtonGroup extends ConsumerWidget {
  final String entityId;

  const ColumnSelectionButtonGroup(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GroupButton(
      isRadio: false,
      onSelected: (time, index, isSelected) =>
          print('$index th button $time is selected'),
      buttons: ["12:00", "13:00", "14:30", "18:00", "19:00", "21:40"],
    );
  }
}