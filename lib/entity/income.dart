import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/create_recurrent_payment_dialog.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';

import '../common.dart';

class RecurrentIncome extends ConsumerWidget {
  final String entityId;
  final StateNotifierProvider<GenericStateNotifier<int?>, int?> dayDraftNP =
      StateNotifierProvider<GenericStateNotifier<int?>, int?>(
          (ref) => GenericStateNotifier<int?>(1));
  RecurrentIncome(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Column(children: [buildPayments(ref), addPaymentButton(context, ref)]);

  Widget buildPayments(WidgetRef ref) {
    return Column(
        children: ref.watch(colSP('entity/$entityId/config')).when(
            loading: () => [],
            error: (e, s) => [ErrorWidget(e)],
            data: (configs) => configs.docs
                .map((config) => ListTile(
                      leading: Text(config.data()['type']),
                      title: Text(config.data()['name']),
                      subtitle: Text(
                          '\$${config.data()['amount'].toString()} on ${config.data()['days'].toString()}'),
                    ))
                .toList()));
  }

  // Row(mainAxisSize: MainAxisSize.max, children: [
  //   Expanded(
  //       child: DocFieldDropDown(
  //     FirebaseFirestore.instance.doc('entity/${entityId}'),
  //     'incomeType',
  //     ['salary', 'centrelink'],
  //   )),
  //   Expanded(
  //       child: DocFieldTextEdit(
  //           FirebaseFirestore.instance.doc('entity/${entityId}'),
  //           'incomeAmount',
  //           decoration: InputDecoration(hintText: "Income Amount"))),
  //   Expanded(child: buildAddDay(ref))
  // ]);

  Widget addPaymentButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AddRecurrentPaymentDialog(entityId),
        );
      },
      icon: Icon(Icons.add),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
    );
  }

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
