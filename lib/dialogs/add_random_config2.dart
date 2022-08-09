import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class AddRandomConfig2 extends ConsumerWidget {
  final TextEditingController maxAmount_inp = TextEditingController();
  final TextEditingController minAmount_inp = TextEditingController();
  final TextEditingController title_inp = TextEditingController();
  final TextEditingController frequency_inp = TextEditingController();

  final isValiedAmount =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final periodSelector =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));
  final categorySelector =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));

  final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));
  final isRandomTransaction =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
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

    List<String> categoryCredit = [
      'cash deposit',
      'cash deposit third party',
      'interest',
      'cheque deposit',
      'direct credit',
      'third party transfer'
    ];
    List<String> categoryDebit = [
      'payment',
      'cash withdrawal',
      'linked account transfer',
      'third party transfer',
      'IFT',
    ];

    return AlertDialog(
      scrollable: true,
      title: Text('Adding Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose Transaction type')),
              Row(
                children: <Widget>[
                  Text("Credit: "),
                  Radio<bool>(
                    value: true,
                    groupValue: ref.watch(creditDebit),
                    onChanged: (value) {
                      ref.read(categorySelector.notifier).value = null;
                      ref.read(creditDebit.notifier).value = value!;
                    },
                  ),
                  Text("Debit: "),
                  Radio<bool>(
                    value: false,
                    groupValue: ref.watch(creditDebit),
                    onChanged: (value) {
                      ref.read(categorySelector.notifier).value = null;
                      ref.read(creditDebit.notifier).value = value!;
                    },
                  ),
                ],
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: ref.watch(categorySelector),
                  hint: Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Text("Select Category"),
                  ),
                  isExpanded: true,
                  alignment: Alignment.center,
                  icon: const Icon(Icons.arrow_downward),
                  underline: Container(),
                  onChanged: (String? newValue) {
                    ref.read(categorySelector.notifier).value = newValue;
                  },
                  items:
                      (ref.watch(creditDebit) ? categoryCredit : categoryDebit)
                          .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),

              /// Example of switch
              ref.watch(categorySelector) != null
                  ? Row(
                      children: <Widget>[
                        Text("Pick Random Details"),
                        Switch(
                            value: ref.watch(isRandomTransaction),
                            onChanged: (value) {
                              ref.read(isRandomTransaction.notifier).value =
                                  !ref.watch(isRandomTransaction);
                            })
                      ],
                    )
                  : Container(),

              ref.watch(isRandomTransaction) == false &&
                      ref.watch(categorySelector) != null
                  ? ref.watch(categorySelector) == 'payment'
                      ? TextFormField(
                          controller: title_inp,
                          decoration: InputDecoration(labelText: 'Beneficiary'),
                        )
                      : Column(
                          children: <Widget>[
                            TextFormField(
                              controller: title_inp,
                              decoration: InputDecoration(
                                  labelText: 'Bank Name/Atm Name'),
                            ),
                            TextFormField(
                              controller: minAmount_inp,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration:
                                  InputDecoration(labelText: 'Bank BSB'),
                            ),
                            TextFormField(
                              controller: title_inp,
                              decoration:
                                  InputDecoration(labelText: 'Reference'),
                            ),
                          ],
                        )
                  : Container(),

              /// end Example
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
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton<String>(
                  value: ref.watch(periodSelector),
                  hint: Container(
                    margin: EdgeInsets.only(left: 12),
                    child: Text("Select period"),
                  ),
                  isExpanded: true,
                  alignment: Alignment.center,
                  icon: const Icon(Icons.arrow_downward),
                  //elevation: 16,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    ref.read(periodSelector.notifier).value = newValue;
                  },
                  items: <String>['Week', 'Month', 'Quarter']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      //alignment: AlignmentDirectional.center,
                      value: value,
                      child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
            onPressed: () {
              if (!ref.read(isValiedAmount) &&
                  ref.read(periodSelector) != null &&
                  ref.read(categorySelector) != null) {
                FirebaseFirestore.instance
                    .collection('randomConfig')
                    .doc(title_inp.text)
                    .set({
                  'credit': ref.watch(creditDebit),
                  'cattegory': ref.watch(categorySelector),
                  'maxAmount': double.parse(maxAmount_inp.text),
                  'minAmount': double.parse(minAmount_inp.text),
                  'period': ref.watch(periodSelector),
                  'frequency': int.parse(frequency_inp.text),
                });
                Navigator.of(context).pop();
              }
            })
      ],
    );
  }
}
