import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_button/group_button.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:data_table_2/data_table_2.dart';

/// expose [ColumnStateNotifier] from [StateNotifierProvider]
final columnStateNotifierProvider =
    StateNotifierProvider<ColumnStateNotifier, List<String>>((ref) {
  return ColumnStateNotifier([]);
});

class ColumnStateNotifier extends GenericStateNotifier<List<String>> {
  ColumnStateNotifier(super.d);

  void addColumn(String columnName) {
    state.add(columnName);
  }

  void removeColumn(String columnName) {
    state.remove(columnName);
  }
}

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
              : DataTable2(
                  //headingRowHeight: 0,
                  columns: showDataColumn(trnCol, ref),
                  rows: showDataRows(trnCol, ref),
                ));

  List<DataRow> showDataRows(
      QuerySnapshot<Map<String, dynamic>> trnCol, WidgetRef ref) {
    var docs = trnCol.docs;
    List<String> selectedColumnList =
        ref.watch(columnStateNotifierProvider.notifier).value;
    // print(docs);
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
    List<String> selectedColumnList =
        ref.watch(columnStateNotifierProvider.notifier).value;
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

class ColumnSelectionButtonGroup extends ConsumerWidget {
  final QuerySnapshot<Map<String, dynamic>> trnCol;

  const ColumnSelectionButtonGroup(this.trnCol);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GroupButton(
      isRadio: false,
      onSelected: (col, index, isSelected) {
        print(
            "$index th button $col is ${isSelected ? 'selected' : 'deselected'}");
        var notifier = ref.read(columnStateNotifierProvider.notifier);
        if (isSelected == false) {
          notifier.removeColumn(col.toString());
        } else {
          notifier.addColumn(col.toString());
        }
        print("new column selected ${notifier.value}");
      },
      buttons: showAllDataColumn(trnCol),
      enableDeselect: true,
    );
  }

  List<String> showAllDataColumn(QuerySnapshot<Map<String, dynamic>> trnCol) {
    var transactionDataMap = trnCol.docs.first.data();
    // print(transactionDataMap.keys);
    var dataColumnNameList = transactionDataMap.keys.toList();
    dataColumnNameList.sort();

    return dataColumnNameList;
  }
}
