import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/widgets/entities_list.dart';
import 'package:seeder/widgets/entity_details.dart';
import 'package:seeder/widgets/entity_list_item.dart';

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
                      child: Column(
                    children: [EntitiesList(), buildAddEntityButton(ref)],
                  )),
                  Expanded(
                    child: EntityDetails('1'),
                  )
                ])));
  }

  buildAddEntityButton(WidgetRef ref) {
    return ElevatedButton(onPressed: () {}, child: Text('Add Entity'));
  }
}
