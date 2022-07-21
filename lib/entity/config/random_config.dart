import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/config_list.dart';
import 'package:seeder/entity/config/periodic_config.dart';
import 'package:seeder/entity/config/selected_config_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:fluttertoast/fluttertoast.dart';

final isValiedAmount = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

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
          Expanded(
              child: Column(
            children: [
              Text('available periodic templates'),
              Expanded(
                child: SingleChildScrollView(
                    child: ConfigList(entityId, "randomConfig")),
              ),
              Divider(),
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add templates'),
                  addRandomConfigButton(context, ref),
                ],
              ))
            ],
          ))
        ]));
  }
}

addRandomConfigButton(BuildContext context, WidgetRef ref) {
  TextEditingController maxAmount_inp = TextEditingController();
  TextEditingController minAmount_inp = TextEditingController();
  TextEditingController title_inp = TextEditingController();
  TextEditingController frequency_inp = TextEditingController();
  TextEditingController probability_inp = TextEditingController();

  maxAmount_inp.addListener(() {
    print("I am working listener");
    if (int.parse(minAmount_inp.text) > int.parse(maxAmount_inp.text)) {
      print("I am working listener inside");

      ref.read(isValiedAmount.notifier).value = true;
    } else {
      ref.read(isValiedAmount.notifier).value = false;
    }
  });

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
                      TextFormField(
                          controller: frequency_inp,
                          decoration: InputDecoration(
                              labelText: 'Times per selected period')),
                      TextFormField(
                          controller: probability_inp,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              InputDecoration(labelText: 'probability')),
                      RadioDropButton(),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (int.parse(minAmount_inp.text) >
                          int.parse(maxAmount_inp.text)) {
                        Fluttertoast.showToast(
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            msg: 'Min Amount should be lesser than max Amount');
                      } else {
                        FirebaseFirestore.instance
                            .collection('randomConfig')
                            .doc(title_inp.text)
                            .set({
                          'credit': ref.watch(creditDebit),
                          'maxAmount': double.parse(maxAmount_inp.text),
                          'minAmount': double.parse(minAmount_inp.text),
                          'period': ref.watch(frequencySelector),
                          'frequency': int.parse(frequency_inp.text),
                          'probability': int.parse(probability_inp.text),
                        });
                        Navigator.of(context).pop();
                      }
                    })
              ],
            );
          });
    },
  );
}
