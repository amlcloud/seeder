import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entity_details.dart';
import 'package:seeder/widgets/entity_list_item.dart';                                // new
import 'package:cloud_firestore/cloud_firestore.dart';

class EntitiesPage extends ConsumerWidget {
  const EntitiesPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('entity page rebuild');
    return Scaffold(
        appBar: MyAppBar.getBar(context),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: Column(
                    children: [
                      buildEntitiesList(ref),
                      buildAddEntityButton(ref)
                    ],
                  )),
                  Expanded(
                    child: EntityDetails('1'),
                  )
                ])));
  }

  ListView buildEntitiesList(WidgetRef ref) {
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: ref.watch(colStreamProvider('entity')).when(
            loading: () => [Container()],
            error: (e, s) => [ErrorWidget(e)],
            data: (entities) => entities.docs
                .map((entity) => EntityListItem(entity.id))
                .toList()));
  }

  buildAddEntityButton(WidgetRef ref) {
    return ElevatedButton(onPressed: () {
      FirebaseFirestore.instance.collection('entity').add({'id':'', 'name':'', 'desc':''});
    }, 
    child: Text('Add Entity'));
  }
}
