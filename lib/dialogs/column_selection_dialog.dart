import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

/// expose [ColumnSelectionStateNotifier] from [StateNotifierProvider]
final columnSelectionStateNotifierProvider =
    StateNotifierProvider<ColumnSelectionStateNotifier, Map>((ref) {
  var allColumnStatusMap = {
    'type': true,
    'amount': true,
    'ben_name': true,
    'timestamp': true
  };
  print(allColumnStatusMap);
  return ColumnSelectionStateNotifier(allColumnStatusMap);
});

// class ColumnSelectionDialog extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return ColumnSelectionDialogState();
//   }
// }

class ColumnSelectionDialog extends ConsumerWidget {
  // todo fetch data as columnSelectedList and convert to columnSelectedStatusMap
  // @override
  // void initState() {
  //   super.initState();
  //   // set initState as columnSelectedStatusMap
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // todo ref.read all column and set it a map<column, bool>
    return SimpleDialog(
      title: Text('column selection dialog'),
      children: _createDialogOptions(ref),
    );
  }

  List<Widget> _createDialogOptions(ref) {
    List<Widget> columnSelectionOptionList = [];
    Map columnSelectedStatusMap =
        ref.read(columnSelectionStateNotifierProvider.notifier).value;
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
    bool selectedStatusValue = ref
            .watch(columnSelectionStateNotifierProvider.notifier)
            .value[columnName] ??
        false;
    print('selected' +
        columnName +
        'StatusValue' +
        selectedStatusValue.toString());
    return SimpleDialogOption(
        child: Row(
      children: [
        Text(columnName),
        Switch(
          value: selectedStatusValue,
          onChanged: (bool newValue) {
            ref
                .watch(columnSelectionStateNotifierProvider.notifier)
                .updateColumnState(columnName, newValue);
            print('new changed ' +
                columnName +
                ' value ' +
                ref
                    .read(columnSelectionStateNotifierProvider.notifier)
                    .value[columnName]
                    .toString());
          },
        )
      ],
    ));
  }
}
