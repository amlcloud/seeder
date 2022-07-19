import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/available_config_list.dart';
import 'package:seeder/entity/config/periodic_config.dart';
import 'package:seeder/entity/config/selected_config_list.dart';

class RandomConfig extends ConsumerWidget {
  final String entityId;
  const RandomConfig(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Column(children: [
          Expanded(child: Text('periodic trn')),
          Expanded(
              child: Column(children: [
            Column(
              children: [
                Card(
                    child: ListTile(
                  leading: Switch(
                      value:
                          true, //ref.watch(isMineBatchNotifierProvider) ?? false,
                      onChanged: (value) {
                        //ref.read(isMineBatchNotifierProvider.notifier).value = value;
                      }),
                  title: Text('monthly salary'),
                  subtitle: Slider(
                    value: 10, //_currentSliderValue,
                    max: 100,
                    divisions: 5,
                    // label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      // setState(() {
                      //   _currentSliderValue = value;
                      // });
                    },
                  ),
                  trailing: IconButton(icon: Icon(Icons.add), onPressed: () {}),
                )),
                IconButton(icon: Icon(Icons.add), onPressed: () {}),
              ],
            )
          ]))
        ]));
  }
}

addPeriodicConfigButton(BuildContext context, WidgetRef ref) {
  TextEditingController maxAmount_inp = TextEditingController();
  TextEditingController minAmount_inp = TextEditingController();
  TextEditingController title_inp = TextEditingController();
  TextEditingController frequency_inp = TextEditingController();

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
                      TextFormField(
                          controller: frequency_inp,
                          decoration: InputDecoration(
                              labelText: 'Times per selected period')),
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
                          .collection('randomConfig')
                          .doc(title_inp.text)
                          .set({
                        'credit': ref.watch(creditDebit),
                        'maxAmount': double.parse(maxAmount_inp.text),
                        'minAmount': double.parse(minAmount_inp.text),
                        'period': ref.watch(frequencySelector),
                        'frequency': int.parse(frequency_inp.text),
                      });
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    },
  );
}
