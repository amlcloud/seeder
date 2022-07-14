import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/entity/filter_my_entities.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';

final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class EntitiesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            children: [
              Text('sort by: '),
              DropdownButton<String>(
                value: ref.watch(activeSort) ?? 'id',
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  // color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  ref.read(activeSort.notifier).value = newValue;
                },
                items: <String>['name', 'id', 'time Created']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
              ),
              FilterMyEntities(),
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: sortAndFilterOnServer(ref))
        ],
      );

  List<Widget> sortAndFilterOnServer(WidgetRef ref) => 
    ref
      .watch(filteredColSP(
          QueryParams(path: 'entity', orderBy: 'time Created', queries: [
        QueryParam(
            'author',
            Map<Symbol, dynamic>.from({
              ...ref.watch(filterMine) == true
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
            print(e);
            return [ErrorWidget(e)];
          },
          data: (entities) => (((ref.watch(filterMine) ?? false)
                  ? entities.docs
                      .where((d) =>
                          d['author'] == FirebaseAuth.instance.currentUser!.uid)
                      .toList()
                  : entities.docs)
                ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                    .compareTo(b[ref.watch(activeSort) ?? 'id'])))
              .map((entity) => EntityListItem(entity.id))
              .toList());

  List<Widget> sortAndFilterOnClient(WidgetRef ref) =>
      ref.watch(colSP('entity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => (((ref.watch(filterMine) ?? false)
                  ? entities.docs
                      .where((d) =>
                          d['author'] == FirebaseAuth.instance.currentUser!.uid)
                      .toList()
                  : entities.docs)
                ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                    .compareTo(b[ref.watch(activeSort) ?? 'id'])))
              .map((entity) => EntityListItem(entity.id))
              .toList());
}
