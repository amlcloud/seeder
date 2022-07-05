import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_list_item.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import '../widgets/entities_list.dart';
import 'filter_my_batches.dart';

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
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  // color: Colors.deepPurpleAccent,
                ),
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
              BatchFilter()
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('set')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => (((ref.watch(isMineBatchNotifierProvider) ?? false)
                          ? entities.docs
                              .where((d) => d['author'] == currentAuthorId)
                              .toList()
                          : entities.docs)
                        ..sort((a, b) => a[ref.watch(sortStateNotifierProvider) ?? 'id']
                            .compareTo(b[ref.watch(sortStateNotifierProvider) ?? 'id'])))
                      .map((entity) => BatchListItem(entity.id))
                      .toList()))
        ],
      );
}
