import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/widgets/entities_list.dart';
import 'package:seeder/widgets/entity_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class EntitiesPage extends ConsumerWidget {
 // const EntitiesPage();
  static String entityViewId = '1';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("sample id $entityViewId");
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
                    children: [EntitiesList(), buildAddEntityButton(ref)],
                  )),
                  Expanded(
                    child: EntityDetails(ref.watch(activeEntity)),
                  )
                ])));
  }

  buildAddEntityButton(WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('entity')
              .add({'id': '', 'name': '', 'desc': ''});
        },
        child: Text('Add Entity'));
  }
}
