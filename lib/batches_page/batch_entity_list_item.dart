import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class BatchEntityListItem extends ConsumerWidget {
  final String path;
  const BatchEntityListItem(this.path);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (entityDoc) => entityDoc.exists == false
            ? Center(child: Text('No entity data exists'))
            : ListTile(
              tileColor: Color.fromARGB(255, 44, 44, 44),
              focusColor: Color.fromARGB(255, 133, 116, 116),
                title: Text(
                  entityDoc.data()!['name'] ?? 'name',
                ),
                trailing: 
                  Column(
                    children: <Widget>[
                    Text(entityDoc.data()!['id'] ?? 'id')]),
                subtitle: Text(entityDoc.data()!['desc'] ?? 'desc')
              ),
    );
  }
}
