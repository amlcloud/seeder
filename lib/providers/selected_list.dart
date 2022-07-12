import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'firestore.dart';

final AutoDisposeStreamProviderFamily<
        List<List<DocumentSnapshot<Map<String, dynamic>>>>, String>
    TransactionListprovider = StreamProvider.autoDispose
        .family<List<List<DocumentSnapshot<Map<String, dynamic>>>>, String>(
            (ref, path) {
  List<Stream<QuerySnapshot<Map<String, dynamic>>>> qs = [];
  ref.watch(colSP('batch/${path}/SelectedEntity')).when(
      loading: () => Stream.empty(),
      error: (e, s) => Stream.empty(),
      data: (selectedEntities) {
        selectedEntities.docs.map((selectedElement) {
          var q = FirebaseFirestore.instance
              .collection("${selectedElement.data()['ref'].path}/transaction");
          qs.add(q.snapshots());
        }).toList();
      });
  return Rx.combineLatestList<QuerySnapshot<Map<String, dynamic>>>(qs)
      .map((event) => event.fold([], (v, el) => v + [el.docs]));
});

final AutoDisposeStreamProviderFamily<List<Map<String, dynamic>>, String>
    selectedTransactionList = StreamProvider.autoDispose
        .family<List<Map<String, dynamic>>, String>((ref, filter) {
  return ref.watch(TransactionListprovider(filter)).when(
      loading: () => Stream.empty(),
      error: (e, s) => Stream.empty(),
      data: (d) {
        var flat = d.expand((i) => i).toList();
        return Stream.value(flat.map((data) {
          return data.data()!;
        }).toList());
      });
});
