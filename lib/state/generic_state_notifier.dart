import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenericStateNotifier<V> extends StateNotifier<V> {
  GenericStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}

/// map for state of ColumnSelectionState
/// key: column name of data
/// value: selected status, defaultly true
class ColumnSelectionStateNotifier extends StateNotifier<Map<String, bool>> {
  var allColumnStatusMap = {
    'type': true,
    'amount': true,
    'ben_name': true,
    'timestamp': true
  };
  ColumnSelectionStateNotifier() : super({}) {
    state = allColumnStatusMap;
  }
  void updateColumnState(String columnName, bool newValue) {
    // since state is immutable,
    // all state should be reassigned
    state = {...state, columnName: newValue};
  }
}

/// expose [ColumnSelectionStateNotifier] from [StateNotifierProvider]
final columnSelectionStateNotifierProvider =
    StateNotifierProvider<ColumnSelectionStateNotifier, Map<String, bool>>(
        (ref) {
  return ColumnSelectionStateNotifier();
});
