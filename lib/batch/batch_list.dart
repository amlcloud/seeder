import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_list_item.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'only_mine_batch_filter.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            children: [
              Text('sort by:'),
              DropdownButton<String>(
                value: ref.watch(sortStateNotifierProvider) ?? 'id',
                onChanged: (String? newValue) {
                  ref.read(sortStateNotifierProvider.notifier).value = newValue;
                },
                items: <String>['time Created', 'name', 'id']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
              ),
              OnlyMineBatchFilter()
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('batch')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (data) {
                    bool onlyMineSwitchStatus =
                        ref.watch(isMineBatchNotifierProvider) ?? false;
                    var all_batches = data.docs;
                    var authors_only_batch = data.docs
                        .where(
                            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                                doc.data()['author'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                        .toList();
                    var author_filtered_batches = (onlyMineSwitchStatus == true
                        ? authors_only_batch
                        : all_batches);
                    var sorted_batches = author_filtered_batches
                      ..sort((a, b) {
                        var sortedBy =
                            ref.watch(sortStateNotifierProvider) ?? 'id';
                        // print(sortedBy);
                        return a[sortedBy].compareTo(b[sortedBy]);
                      });
                    return sorted_batches
                        .map((e) => BatchListItem(e.id))
                        .toList();
                  }))
        ],
      );
}
