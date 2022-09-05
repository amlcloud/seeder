import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_page.dart';
import 'package:seeder/providers/selected_list.dart';

class BatchTransactions extends ConsumerWidget {
  final String batchId;
  const BatchTransactions(this.batchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: EdgeInsets.all(20.0),
        child: ref.watch(selectedTransactionList(ref.watch(activeBatch)!)).when(
            loading: () => Text("loading"),
            error: (e, s) => Text("No data found"),
            data: (entities) {
              return DataTable2(
                  columns: batchCsvHeader(entities),
                  rows: batchCsvRows(entities));
            }));
  }

  List<DataColumn> batchCsvHeader(List<Map<String, dynamic>> entities) {
    return ((entities.first.entries
            .toList()
            .where((element) =>
                element.key.toString() != 'time Created' &&
                element.key.toString() != 'author' &&
                element.key.toString() != 'desc')
            .toList())
          ..sort((a, b) => a.key.compareTo(b.key)))
        .map((values) => DataColumn(
                label: Text(
              values.key.toString(),
            )))
        .toList();
  }

  List<DataRow> batchCsvRows(List<Map<String, dynamic>> entities) {
    return entities.map((e) {
      return DataRow(
          cells: ((e.entries
                  .toList()
                  .where((element) =>
                      element.key.toString() != 'time Created' &&
                      element.key.toString() != 'author' &&
                      element.key.toString() != 'desc')
                  .toList())
                ..sort((a, b) => a.key.compareTo(b.key)))
              .map((values) => DataCell(Text(
                    values.value.toString(),
                  )))
              .toList());

      //return Container();
    }).toList();
  }
}
