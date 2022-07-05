import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/selected_list_item.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entity_list_item.dart';

import 'batch_page.dart';

// class SelectedEntitiesList extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) => ListView(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       children: ref
//           .watch(
//               colSP('set/AJTOzkGsch2sO9tviKQF/SelectedEntity'))
//           .when(
//               loading: () => [Container()],
//               error: (e, s) => [ErrorWidget(e)],
//               data: (entities) => entities.docs
//                   .map((entity) => Card(
//                         child: Row(children: [
//                           Expanded(
//                             child: SelectedListItem(entity.id),
//                           ),
//                           IconButton(onPressed: () {}, icon: Icon(Icons.remove))
//                         ]),
//                       ))
//                   .toList()));
// }

class SelectedEntitiesList extends ConsumerWidget {
  final String setId = 'BUVlUXhvauQzw384GxE7';
  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('set/${ref.watch(activeBatch)}/SelectedEntity')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          data: (entities) => entities.docs
              .map((entity) => Card(
                    child: Row(children: [
                      Expanded(
                        child: SelectedListItem(entity.id),
                      ),
                      IconButton(onPressed: () {
                        print(entity.id);
                      }, icon: Icon(Icons.remove))
                    ]),
                  ))
              .toList()));
}