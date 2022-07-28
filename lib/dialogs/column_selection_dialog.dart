import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColumnSelectionDialog extends ConsumerWidget {
  // const ColumnSelectionDialog(trnCol);
  final columnList = ['amount', 'ref', 'time'];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialog(
      title: Text('column selection dialog'),
      children: _createDialogOptions(),
    );
  }

  List<Widget> _createDialogOptions() {
    return columnList
        .map((e) => ColumnSelectionDialogOption(e.toString()))
        .toList();
  }
}

class ColumnSelectionDialogOption extends ConsumerWidget {
  final String columnName;
  const ColumnSelectionDialogOption(this.columnName);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialogOption(
        child: Row(
      children: [Text(columnName), Switch(value: true, onChanged: null)],
    ));
  }
}
