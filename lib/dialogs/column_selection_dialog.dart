import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/column_selection_state_notifier.dart';

class ColumnSelectionDialog extends ConsumerWidget {
  final String entityId;
  const ColumnSelectionDialog(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var columnSelectedMap =
        ref.watch(columnSelectionStateNotifierProvider(entityId));
    // todo ref.read all column and set it a map<column, bool>
    var columnSM = columnSelectedMap.keys.toList();
    List<List> tempListofList = [[]];
    List temp = [];
    for (var i = 0; i < columnSM.length; i++) {
      temp.add(columnSM[i]);
      if (i % 3 == 0) {
        tempListofList.add(temp);
        temp = [];
      }
    }
    tempListofList.add(temp);
    tempListofList = tempListofList.reversed.toList();
    return SimpleDialog(
        title: Text('column selection dialog'),
        children: tempListofList
            .map((rowWid) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rowWid
                    .map((k) => Align(
                          //alignment: Alignment.centerLeft,
                          child: ColumnSelectionDialogOption(
                              k: k,
                              columnSelectedMap: columnSelectedMap,
                              entityId: entityId),
                        ))
                    .toList()))
            .toList()

        // for (final k in columnSelectedMap.keys)
        //   ColumnSelectionDialogOption(
        //       k: k, columnSelectedMap: columnSelectedMap, entityId: entityId),

        );

    // return SimpleDialog(
    //   title: Text('column selection dialog'),
    //   children: [
    //     for (final k in columnSelectedMap.keys)
    //       ColumnSelectionDialogOption(
    //           k: k, columnSelectedMap: columnSelectedMap, entityId: entityId),
    //   ],
    // );
  }
}

class ColumnSelectionDialogOption extends ConsumerWidget {
  const ColumnSelectionDialogOption({
    Key? key,
    required this.k,
    required this.columnSelectedMap,
    required this.entityId,
  }) : super(key: key);

  final String k;
  final Map<String, bool> columnSelectedMap;
  final String entityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialogOption(
      child: Row(
        children: [
          Text(k),
          Switch(
              value: columnSelectedMap[k] ?? true,
              onChanged: (newValue) {
                ref
                    .read(
                        columnSelectionStateNotifierProvider(entityId).notifier)
                    .updateColumnState(k, newValue);
              })
        ],
      ),
    );
  }
}
