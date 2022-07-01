import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/widgets/entity_list_item.dart';

class EntitiesList extends ConsumerWidget {
  printEntity(tempData) {
    print(tempData);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            children: [
              Text('sort by:'),
              DropdownButton<String>(
                value: ref.watch(activeSort),
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
                items: <String>['name', 'id']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('entity')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => (entities.docs
                        ..sort((a, b) => a[ref.watch(activeSort) ?? 'id']
                            .compareTo(b[ref.watch(activeSort) ?? 'id'])))
                      .map((entity) => EntityListItem(entity.id))
                      .toList()))
        ],
      );
}
