import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class AddPeriodicConfig extends ConsumerWidget {
  final TextEditingController maxAmount_inp = TextEditingController();
  final TextEditingController minAmount_inp = TextEditingController();
  final TextEditingController title_inp = TextEditingController();

  final frequencySelector =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));

  final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));

  @override
  Widget build(BuildContext context, WidgetRef ref) => AlertDialog(
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
                  decoration: InputDecoration(labelText: 'Min Amount'),
                ),
                TextFormField(
                  controller: maxAmount_inp,
                  decoration: InputDecoration(
                    labelText: 'Max Amount',
                  ),
                ),
                DropdownButton<String>(
                  value: ref.watch(frequencySelector) ?? 'Daily',
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
                  items: <String>[
                    'Daily',
                    'Weekly',
                    'Monthly',
                    'Quarterly',
                    'Yearly'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
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
                FirebaseFirestore.instance
                    .collection('periodicConfig')
                    .doc(title_inp.text)
                    .set({
                  'credit': ref.read(creditDebit),
                  'maxAmount': double.parse(maxAmount_inp.text),
                  'minAmount': double.parse(minAmount_inp.text),
                  'period': ref.read(frequencySelector),
                });
                Navigator.of(context).pop();
              })
        ],
      );
}
