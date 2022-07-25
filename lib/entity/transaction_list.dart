import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_button/group_button.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';

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
              : Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        ColumnSelectionButtonGroup(trnCol),
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
      buttons: showDataColumn(trnCol),
      enableDeselect: true,
    );
  }

  List<String> showDataColumn(QuerySnapshot<Map<String, dynamic>> trnCol) {
    var transactionDataMap = trnCol.docs.first.data();
    // print(transactionDataMap.keys);
    var dataColumnNameList = transactionDataMap.keys.toList();
    dataColumnNameList.sort();

    return dataColumnNameList;
  }
}
