import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class AddRandomConfig extends ConsumerWidget {
  final TextEditingController maxAmount_inp = TextEditingController();
  final TextEditingController minAmount_inp = TextEditingController();
  final TextEditingController title_inp = TextEditingController();
  final TextEditingController frequency_inp = TextEditingController();
  final TextEditingController probability_inp = TextEditingController();

  final isValiedAmount =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final frequencySelector =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>('Day'));

  final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    maxAmount_inp.addListener(() {
      if (int.parse(minAmount_inp.text) >= int.parse(maxAmount_inp.text)) {
        ref.read(isValiedAmount.notifier).value = true;
      } else {
        ref.read(isValiedAmount.notifier).value = false;
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
              TextFormField(
                controller: frequency_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Frequency',
                ),
              ),
              TextFormField(
                controller: probability_inp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Probability %',
                ),
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
              if (!ref.read(isValiedAmount)) {
                FirebaseFirestore.instance
                    .collection('randomConfig')
                    .doc(title_inp.text)
                    .set({
                  'credit': ref.watch(creditDebit),
                  'maxAmount': double.parse(maxAmount_inp.text),
                  'minAmount': double.parse(minAmount_inp.text),
                  'period': ref.watch(frequencySelector),
                  'frequency': int.parse(frequency_inp.text),
                  'Probability': int.parse(probability_inp.text),
                });
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
