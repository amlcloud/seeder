import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/entities_page.dart';
import 'package:seeder/providers/firestore.dart';

class BatchListItem extends ConsumerWidget {
  final String setId;
  const BatchListItem(this.setId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('set/' + setId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : Card(
                child: Column(
                children: [
                  ListTile(
                    title: Text(
                      entityDoc.data()!['name'] ?? 'name',
                    ),
                    trailing: Text(entityDoc.data()!['id'] ?? 'id'),
                    subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                    onTap: () {
                      ref.read(activeBatch.notifier).value = setId;
                    },
                  )
                ],
              )));
  }
}
