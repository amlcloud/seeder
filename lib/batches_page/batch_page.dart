import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/batches_page/batch_details.dart';
import 'package:seeder/batches_page/batch_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MyAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: Column(
                    children: [BatchList(), buildAddSetButton(ref)],
                  )),
                  Expanded(
                    child: BatchDetails(ref.watch(activeBatch)),
                  )
                ])));
  }

  Widget buildAddSetButton(WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('set')
              .add({'id': '', 'name': '', 'desc': ''});
        },
        child: Text('Add Entity'));
  }
}
