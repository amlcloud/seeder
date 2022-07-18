import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final frequencyNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));
final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class PeriodicConfig extends ConsumerWidget {
  const PeriodicConfig({Key? key}) : super(key: key);

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
                  Column(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('monthly salary'),
                        subtitle: Text('\$2000-\$10000'),
                        //trailing: addPeriodicConfigButton(context, ref),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('weekly salary'),
                        subtitle: Text('\$500-\$1000'),
                        trailing:
                            IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      )),
                      addPeriodicConfigButton(context, ref),
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text('selected periodic templates'),
                  Column(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('Spotify subscription'),
                        subtitle: Text('\$12.95, monthly on 15th'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('gas bill'),
                        subtitle: Text('~\$434, quarterly on 1st'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('fortnightly salary'),
                        subtitle: Text('~\$434, fortnightly on 11th'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      ))
                    ],
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
                        controller: minAmount_inp,
                        decoration: InputDecoration(labelText: 'Min Amount'),
                      ),
                      TextFormField(
                        controller: maxAmount_inp,
                        decoration: InputDecoration(
                          labelText: 'Max Amount',
                        ),
                      ),
                      //         Row(
                      //   children: [
                      //     Text('Frequency:'),
                      //     DropdownButton<String>(
                      //       value: ref.watch(sortStateNotifierProvider) ?? 'id',
                      //       onChanged: (String? newValue) {
                      //         ref.read(sortStateNotifierProvider.notifier).value =
                      //             newValue;
                      //       },
                      //       items: <String>['time Created', 'name', 'id']
                      //           .map<DropdownMenuItem<String>>((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(value.toUpperCase()),
                      //         );
                      //       }).toList(),
                      //     ),
                      //   ],
                      // ),
                      Card(
                          child: Column(
                        children: [
                          Text('Please select type'),
                          ListTile(
                            leading: Radio<bool>(
                              value: true,
                              groupValue: ref.watch(creditDebit),
                              onChanged: (values) {
                                print("I am working: $values");
                                ref.read(creditDebit.notifier).value = values!;
                              },
                            ),
                            title: const Text('Credit'),
                          ),
                          ListTile(
                            leading: Radio<bool>(
                              value: false,
                              groupValue: ref.watch(creditDebit),
                              onChanged: (values) {
                                print("I am working: $values");
                                ref.read(creditDebit.notifier).value = values!;
                              },
                            ),
                            title: const Text('Debit'),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text("Submit"),
                    onPressed: () {
                      // FirebaseFirestore.instance.collection('periodicConfig').add({
                      //   'credit':
                      //   'maxAmount': double.parse(maxAmount_inp.text),
                      //   'minAmount': double.parse(minAmount_inp.text),
                      //   'period':
                      // });
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    },
  );
}
