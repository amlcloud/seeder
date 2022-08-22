import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// map for state of ColumnSelectionState
/// key: column name of data
/// value: selected status, defaultly true
class ColumnSelectionStateNotifier extends StateNotifier<Map<String, bool>> {
  // todo data should be from database user setting
  Map<String, bool> allColumnStatusMap = {};

  ColumnSelectionStateNotifier(String entityId) : super({}) {
    String path = 'entity/$entityId/transaction';
    List<String> columnList = [];
    var future = FirebaseFirestore.instance.collection(path).get();
    future.then((value) {
      var dataList = value.docs.first.data().keys.toList();
      // print(dataList);
      columnList.addAll(dataList);
      // print('columnList' + columnList.toString());
      allColumnStatusMap = {for (var i in columnList) i: true};
      state = allColumnStatusMap;
    });
  }
  void updateColumnState(String columnName, bool newValue) {
    // since state is immutable,
    // all state should be reassigned
    state = {...state, columnName: newValue};
    // print(state);
    // todo write TRUE state back to database as user setting
  }
}

/// expose [ColumnSelectionStateNotifier] from [StateNotifierProvider]
final columnSelectionStateNotifierProvider = StateNotifierProvider.family<
    ColumnSelectionStateNotifier, Map<String, bool>, String>((ref, entityId) {
  return ColumnSelectionStateNotifier(entityId);
});
