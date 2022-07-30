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
class ColumnSelectionStateNotifier
    extends GenericStateNotifier<Map<String, bool>> {
  ColumnSelectionStateNotifier(super.state);

  // fetch data
  void updateColumnState(String columnName, bool newValue) {
    state.update(columnName, (value) => newValue);
    print(state);
  }
}
