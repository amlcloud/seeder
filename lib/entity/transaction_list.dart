import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/column_selection_dialog.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:data_table_2/data_table_2.dart';

/// datatable showing generated transaction records.
/// where data column will be fixed on the top.
class TransactionList extends ConsumerWidget {
  final String entityId;

  const TransactionList(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(colSP('entity/$entityId/transaction')).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (trnCol) => trnCol.size == 0
            ? Text('no records')
            : Column(children: [
                Flexible(
                    child: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          ColumnSelectionDialog(entityId),
                    );
                  },
                )),
                Expanded(
                    child: DataTable2(
                  //headingRowHeight: 0,
                  columns: showDataColumn(trnCol, ref),
                  rows: showDataRows(trnCol, ref),
                ))
              ]));
  }

  List<DataRow> showDataRows(
      QuerySnapshot<Map<String, dynamic>> trnCol, WidgetRef ref) {
    var docs = trnCol.docs;
    var columnSelectedMap =
        ref.watch(columnSelectionStateNotifierProvider(entityId));
    var selectedColumnList = columnSelectedMap.keys
        .where((element) => columnSelectedMap[element] == true);
    print("data rows selectedColumnList" + selectedColumnList.toString());
    return docs.map((trnDoc) {
      var dataList = trnDoc.data().entries.toList();
      var selectedDataList = dataList.where((element) {
        return selectedColumnList.contains(element.key);
      });
      debugPrint(selectedDataList.toString());
      if (selectedDataList.isEmpty) {
        return DataRow(cells: [DataCell(Text('no data rows'))]);
      } else {
        return DataRow(
            cells: (selectedDataList.toList()
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
        }).toList());
      }
    }).toList();
  }

  List<DataColumn> showDataColumn(
      QuerySnapshot<Map<String, dynamic>> trnCol, WidgetRef ref) {
    var transactionDataMap = trnCol.docs.first.data();
    // print(transactionDataMap.keys);
    var columnSelectedMap =
        ref.watch(columnSelectionStateNotifierProvider(entityId));
    var selectedColumnList = columnSelectedMap.keys
        .where((element) => columnSelectedMap[element] == true);
    print("data column selectedColumnList" + selectedColumnList.toString());
    var dataColumnNameList = transactionDataMap.keys
        .toList()
        .where((element) => selectedColumnList.contains(element));
    dataColumnNameList.toList().sort();
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
    debugPrint(dataColumnList.toString());
    return dataColumnList.isEmpty
        ? [DataColumn(label: Text('no column'))]
        : dataColumnList;
  }
}
