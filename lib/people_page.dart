import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entity_details.dart';

class EntitiesPage extends ConsumerWidget {
  const EntitiesPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: ref.watch(colStreamProvider('entity')).when(
                              loading: () => [Container()],
                              error: (e, s) => [ErrorWidget(e)],
                              data: (entities) => entities.docs
                                  .map((entity) => Card(
                                          child: ListTile(
                                        leading: Icon(Icons.home),
                                        title: Text('Entity ${entity.id}'),
                                        trailing: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Edit')),
                                        subtitle:
                                            Text('customer with a lot of debt'),
                                      )))
                                  .toList()))),
                  Expanded(
                    child: EntityDetails('1'),
                  )
                ])));
  }
}
