import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:seeder/entity/available_config_list.dart';
import 'package:seeder/entity/config/available_config_list.dart';
import 'package:seeder/entity/config/selected_config_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final frequencySelector =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(true));

class PeriodicConfig extends ConsumerWidget {
  final String entityId;

  const PeriodicConfig(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Column(
          children: [
            Expanded(child: Text('periodic trn')),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                  child: Column(
                children: [
                  Text('available periodic templates'),
                  Container(
                    height: 250,
                    child: SingleChildScrollView(
                        child: AvailableConfigList(entityId, "periodicConfig")),
                  ),
                  Divider(),
                  Card(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Add templates '),
                      addPeriodicConfigButton(context, ref),
                    ],
                  ))
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text('selected periodic templates'),
                  Container(
                    height: 280,
                    child: SingleChildScrollView(
                      child: SelectedConfigList(entityId, "periodicConfig"),
                    ),
                  )
                ],
              )),
            ])
          ],
        ));
  }
}

addPeriodicConfigButton(BuildContext context, WidgetRef ref) {
  TextEditingController maxAmount_inp = TextEditingController();
  TextEditingController minAmount_inp = TextEditingController();
  TextEditingController title_inp = TextEditingController();

  return IconButton(
    icon: Icon(Icons.add),
    onPressed: () {
      showDialog(
          context: context,
          
          builder: (BuildContext context) {
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
                        decoration: InputDecoration(labelText: 'Min Amount'),
                      ),
                      TextFormField(
                        controller: maxAmount_inp,
                        decoration: InputDecoration(
                          labelText: 'Max Amount',
                        ),
                      ),
                      RadioDropButton(),
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
                        'credit': ref.watch(creditDebit),
                        'maxAmount': double.parse(maxAmount_inp.text),
                        'minAmount': double.parse(minAmount_inp.text),
                        'period': ref.watch(frequencySelector),
                      });
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    },
  );
}

class RadioDropButton extends ConsumerWidget {
  const RadioDropButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Card(
          child: Row(children: [
            Text('Period : '),
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
          ]),
        ),
        Card(
          child: Column(
            children: <Widget>[
              Text('Transaction type'),
              ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: ref.watch(creditDebit),
                  onChanged: (value) {
                    print("I am working: $value");
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
                    print("I am working: $value");
                    ref.read(creditDebit.notifier).value = value!;
                  },
                ),
                title: const Text('Debit'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
