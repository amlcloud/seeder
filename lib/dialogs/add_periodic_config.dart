import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class AddPeriodicConfig extends ConsumerWidget {
  final TextEditingController maxAmount_inp = TextEditingController();
  final TextEditingController minAmount_inp = TextEditingController();
  final TextEditingController title_inp = TextEditingController();
  final TextEditingController day_inp = TextEditingController();

  final frequencySelector =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>('Week'));

  final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));
  final isValiedAmount =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final isValiedDay = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(false));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    maxAmount_inp.addListener(() {
      if (int.parse(minAmount_inp.text) >= int.parse(maxAmount_inp.text)) {
        ref.read(isValiedAmount.notifier).value = true;
      } else {
        ref.read(isValiedAmount.notifier).value = false;
      }
    });

    day_inp.addListener(() {
      int day = ref.read(frequencySelector) == "Week"
          ? 7
          : ref.read(frequencySelector) == "Month"
              ? 28
              : 84;
      if (int.parse(day_inp.text) > day || int.parse(day_inp.text) <= 0) {
        ref.read(isValiedDay.notifier).value = true;
      } else {
        ref.read(isValiedDay.notifier).value = false;
      }
    });

    return AlertDialog(
      scrollable: true,
      title: Text('Adding Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: title_inp,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: minAmount_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(labelText: 'Min Amount'),
              ),
              TextFormField(
                controller: maxAmount_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Max Amount',
                ),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 5),
                child: ref.watch(isValiedAmount)
                    ? Text(
                        'Max Amount should be greter than Min amount',
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    : Container(),
              ),
              DropdownButton<String>(
                value: ref.watch(frequencySelector) ?? 'Day',
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  // color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  ref.read(frequencySelector.notifier).value = newValue;
                },
                items: <String>['Week', 'Month', 'Quarter']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: day_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    labelText: ref.watch(frequencySelector) == "Week"
                        ? 'Selecy day 1-7'
                        : ref.watch(frequencySelector) == "Month"
                            ? 'Selecy day 1-28'
                            : 'Selecy day 1-84'),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 5),
                child: ref.watch(isValiedDay)
                    ? Text(
                        ref.watch(frequencySelector) == "Week"
                            ? 'please selecy day 1-7'
                            : ref.watch(frequencySelector) == "Month"
                                ? 'Please selecy day 1-28'
                                : 'Please selecy day 1-84',
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    : Container(),
              ),
              Text('Transaction type'),
              ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: ref.watch(creditDebit),
                  onChanged: (value) {
                    ref.read(creditDebit.notifier).value = value!;
                  },
                ),
                title: const Text('Credit'),
              ),
              ListTile(
                leading: Radio<bool>(
                  value: false,
                  groupValue: ref.watch(creditDebit),
                  onChanged: (value) {
                    ref.read(creditDebit.notifier).value = value!;
                  },
                ),
                title: const Text('Debit'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
            onPressed: () {
              if (!ref.read(isValiedAmount) && !ref.read(isValiedDay)) {
                FirebaseFirestore.instance
                    .collection('periodicConfig')
                    .doc(title_inp.text)
                    .set({
                  'credit': ref.read(creditDebit),
                  'maxAmount': double.parse(maxAmount_inp.text),
                  'minAmount': double.parse(minAmount_inp.text),
                  'period': ref.read(frequencySelector),
                  'day': int.parse(day_inp.text),
                });
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
