import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/column_selection_dialog.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/column_selection_state_notifier.dart';
import 'package:widgets/doc_stream_widget.dart';

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
                    child: DocStreamWidget(
                        docSP(kDBUserRef()
                            .collection('pref')
                            .doc('trnColumns')
                            .path), (context, snap) {
                  print('columns: ${snap.data() ?? {}}');

                  if (!snap.exists) return Text('no columns selected');
                  return DataTable2(
                    //headingRowHeight: 0,
                    columns: showDataColumn(
                        trnCol,
                        snap.data() ?? {},
                        // ref.watch(columnSelectionStateNotifierProvider(entityId)),
                        ref),
                    rows: showDataRows(
                        trnCol,
                        snap.data() ?? {},
                        // ref.watch(columnSelectionStateNotifierProvider(entityId)),
                        ref),
                  );
                }))
                // Expanded(
                //     child: DataTable2(
                //   //headingRowHeight: 0,
                //   columns: showDataColumn(trnCol, ref),
                //   rows: showDataRows(trnCol, ref),
                // ))
              ]));
  }

  List<DataRow> showDataRows(QuerySnapshot<Map<String, dynamic>> trnCol,
      Map<String, dynamic> columnSelectedMap, WidgetRef ref) {
    var docs = trnCol.docs;
    // var columnSelectedMap =
    //     ref.watch(columnSelectionStateNotifierProvider(entityId));
    var selectedColumnList = columnSelectedMap.keys
        .where((element) => columnSelectedMap[element] == true);
    print("data rows selectedColumnList: " + selectedColumnList.toString());
    return (docs
          ..sort(
              ((a, b) => a.data()['dayTime'].compareTo(b.data()['dayTime']))))
        .map((trnDoc) {
      var dataList = trnDoc.data().entries.toList();
      // var selectedDataList;
      // = dataList.where((element) {
      //   return selectedColumnList.contains(element.key);
      // });

      final selectedDataList = selectedColumnList.map((e) {
        try {
          return dataList.where((element) => element.key == e).first;
        } catch (exception) {
          return MapEntry<String, dynamic>(e, '');
        }
      }).toList();

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
        if (cell.key == "Type") {
          return DataCell(Text(
            cell.value.toString(),
            style: TextStyle(
                color: cell.value == "Credit" ? Colors.green : Colors.red),
          ));
        }
        return DataCell(Text(cell.value.toString()));
      }).toList());
    }).toList();
  }

  List<DataColumn> showDataColumn(QuerySnapshot<Map<String, dynamic>> trnCol,
      Map<String, dynamic> columnSelectedMap, WidgetRef ref) {
    var transactionDataMap = trnCol.docs.first.data();
    // print(transactionDataMap.keys);
    // var columnSelectedMap =
    //     ref.watch(columnSelectionStateNotifierProvider(entityId));
    var selectedColumnList = columnSelectedMap.keys
        .where((element) => columnSelectedMap[element] == true);
    print("data column selectedColumnList:" + selectedColumnList.toString());
    var dataColumnNameList = transactionDataMap.keys
        .toList()
        .where((element) => selectedColumnList.contains(element));
    // dataColumnNameList = dataColumnNameList.toList()..sort();
    dataColumnNameList = selectedColumnList.toList()..sort();
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
    //debugPrint(dataColumnList.toString());
    return dataColumnList.isEmpty
        ? [DataColumn(label: Text('no column'))]
        : dataColumnList;
  }
}
