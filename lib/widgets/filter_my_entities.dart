import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/widgets/entities_list.dart';
import 'package:seeder/widgets/entity_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final filterMine = StateNotifierProvider<GenericStateNotifier<bool?>, bool?>(
    (ref) => GenericStateNotifier<bool?>(false));

class FilterMyEntities extends ConsumerWidget {
  final currentAuthorId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(children: [
        Text('Mine Only'),
        Switch(
            value: ref.watch(filterMine) ?? false,
            onChanged: (value) {
              ref.read(filterMine.notifier).value = value;
              print(currentAuthorId);
            })
      ]);
}
