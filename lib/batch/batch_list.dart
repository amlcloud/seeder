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
          Column(
            children: [
              Row(
                children: [
                  Text('sort by:'),
                  DropdownButton<String>(
                    value: ref.watch(sortStateNotifierProvider) ?? 'id',
                    onChanged: (String? newValue) {
                      ref.read(sortStateNotifierProvider.notifier).value =
                          newValue;
                    },
                    items: <String>['time Created', 'name', 'id']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              OnlyMineBatchFilter()
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: sortAndFilterOnServer(ref))
        ],
      );
  List<Widget> sortAndFilterOnServer(WidgetRef ref) => ref
      .watch(filteredColSP(QueryParams(
          path: 'batch',
          orderBy: ref.watch(sortStateNotifierProvider) ?? 'id',
          queries: [
            QueryParam(
                'author',
                Map<Symbol, dynamic>.from({
                  ...ref.watch(isMineBatchNotifierProvider) == true
                      ? {
                          Symbol('isEqualTo'):
                              FirebaseAuth.instance.currentUser!.uid
                        }
                      : {},
                }))
          ])))
      .when(
          loading: () => [Container()],
          error: (e, s) {
            return [ErrorWidget(e)];
          },
          data: (batches) =>
              batches.docs.map((b) => BatchListItem(b.id)).toList());
}
