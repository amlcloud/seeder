import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/doc_field_drop_down.dart';
import 'package:seeder/controls/doc_field_text_edit.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';

import '../common.dart';

class Income extends ConsumerWidget {
  final String entityId;
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> dayDraftNP =
      StateNotifierProvider<GenericStateNotifier<int?>, int?>(
          (ref) => GenericStateNotifier<int?>(1));
  Income(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Row(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: DocFieldDropDown(
          FirebaseFirestore.instance.doc('entity/${entityId}'),
          'incomeType',
          ['salary', 'centrelink'],
        )),
        Expanded(
            child: DocFieldTextEdit(
                FirebaseFirestore.instance.doc('entity/${entityId}'),
                'incomeAmount',
                decoration: InputDecoration(hintText: "Income Amount"))),
        Expanded(child: buildAddDay(ref))
      ]);

  Widget buildAddDay(WidgetRef ref) {
    return Row(
      children: [
        Row(
            children: ref.watch(docSP('entity/${entityId}')).when(
                loading: () => [],
                error: (e, s) => [ErrorWidget(e)],
                data: (entityDoc) =>
                    !entityDoc.exists || entityDoc.data()!['days'] == null
                        ? []
                        : entityDoc
                            .data()!['days']
                            .map<Widget>((day) => Text(day.toString()))
                            .toList())),
        DropdownButton<int>(
          value: ref.watch(dayDraftNP),
          onChanged: (int? newValue) {
            ref.read(dayDraftNP.notifier).value = newValue;
          },
          items: DAYS_IN_MONTH
              .map((day) => DropdownMenuItem<int>(
                  value: day, child: Text(day.toString())))
              .toList(),
        ),
        OutlinedButton(
            onPressed: () {
              FirebaseFirestore.instance.doc('entity/${entityId}').update({
                'days':
                    FieldValue.arrayUnion([ref.read(dayDraftNP.notifier).value])
              });
            },
            child: Text('add'))
      ],
    );
  }
}
