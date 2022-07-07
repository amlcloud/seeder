import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_list_item.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/filter_my_entities.dart';

class BatchList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Row(
            children: [
              Text('sort by:'),
              DropdownButton<String>(
                value: null,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  // color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {},
                items: <String>['time created', 'name', 'id']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              FilterMyEntities()
            ],
          ),
          ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: ref.watch(colSP('batch')).when(
                  loading: () => [Container()],
                  error: (e, s) => [ErrorWidget(e)],
                  data: (entities) => entities.docs //..sort((a,b))
                      .map((entity) => BatchListItem(entity.id))
                      .toList()))
        ],
      );
}
