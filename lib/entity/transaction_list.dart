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
          data: (trnCol) =>
              trnCol.size == 0 ? Text('no records') : Container());
  // DataTable2(
  //     //headingRowHeight: 0,
  //     columns: showDataColumn(trnCol),
  //     rows: showDataRows(trnCol),
  //   ));
}
