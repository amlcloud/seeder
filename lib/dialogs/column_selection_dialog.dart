import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColumnSelectionDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ColumnSelectionDialogState();
  }
}

class ColumnSelectionDialogState extends ConsumerState<ColumnSelectionDialog> {
  // const ColumnSelectionDialog(trnCol);
  @override
  void initState() {
    // TODO: implement initState adding ref.read
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // todo ref.read all column and set it a map<column, bool>
    return SimpleDialog(
      title: Text('column selection dialog'),
      children: _createDialogOptions(),
    );
  }

  List<Widget> _createDialogOptions() {
    final Map columnSelectedStatusMap = {
      "balance": true,
      "time": true,
      'ref': true
    };
    List<Widget> columnSelectionOptionList = [];
    columnSelectedStatusMap.forEach((key, value) {
      columnSelectionOptionList.add(ColumnSelectionDialogOption(key, value));
    });
    return columnSelectionOptionList;
  }
}

class ColumnSelectionDialogOption extends ConsumerWidget {
  final String columnName;
  final bool isSelected;
  const ColumnSelectionDialogOption(this.columnName, this.isSelected);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialogOption(
        child: Row(
      children: [Text(columnName), Switch(value: true, onChanged: null)],
    ));
  }
}
