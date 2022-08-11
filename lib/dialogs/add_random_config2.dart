import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/random_datas/random_TPT.dart';
import 'package:seeder/random_datas/random_bank_details.dart';
import 'package:seeder/random_datas/random_names.dart';
import 'package:seeder/random_datas/random_streets.dart';
import 'package:seeder/random_datas/random_suburbs.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'dart:math' as math;

class AddRandomConfig2 extends ConsumerWidget {
  /// TextEditingController for Common
  final List<TextEditingController> controllerList = [];
  final List<String> fieldLables = [];
  final TextEditingController maxAmount_inp =
      TextEditingController.fromValue(TextEditingValue(text: "1"));
  final TextEditingController minAmount_inp =
      TextEditingController.fromValue(TextEditingValue(text: "0"));
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
      'cheque deposit',
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
      title: Text('Adding Random Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Group(
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
                ],
              )),

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

              /// Start Field Section
              TextFormField(
                controller: title_inp,
                decoration: InputDecoration(labelText: 'Title'),
              ),

              ref.watch(isRandomTransaction) == false &&
                      ref.watch(categorySelector) != null
                  ? ref.watch(creditDebit) == false
                      ?
                      // Debit debit conditions
                      ref.watch(categorySelector) ==
                                  'linked account transfer' ||
                              ref.watch(categorySelector) == 'cash withdrawal'
                          ? fieldAdder(context, ref, ["Reference"])
                          : fieldAdder(context, ref, [
                              "Beneficiary _Name",
                              "Beneficiary_Account",
                              "Beneficiary_Bank",
                              "Beneficiary_BSB",
                              "Reference"
                            ])
                      //Credit conditionns
                      : ref.watch(categorySelector) == 'cash deposit'
                          ? fieldAdder(context, ref, ["Reference"])
                          : fieldAdder(context, ref, [
                              "Remiter_Name",
                              "Remiter_Account",
                              "Remiter_Bank",
                              "Remiter_BSB",
                              "Reference"
                            ])
                  : Container(),

              /// end field section

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
            onPressed: () async {
              if (!ref.read(isValiedAmount) &&
                  ref.read(periodSelector) != null &&
                  ref.read(categorySelector) != null) {
                // FirebaseFirestore.instance
                //     .collection('randomConfig')
                //     .doc(title_inp.text)
                //     .set({
                //   'credit': ref.watch(creditDebit),
                //   'cattegory': ref.watch(categorySelector),
                //   'maxAmount': double.parse(maxAmount_inp.text),
                //   'minAmount': double.parse(minAmount_inp.text),
                //   'period': ref.watch(periodSelector),
                //   'frequency': int.parse(frequency_inp.text),});
                //Navigator.of(context).pop();
                print(getListData(context, ref));
              }
            })
      ],
    );
  }

  Widget fieldAdder(
      BuildContext context, WidgetRef ref, List<String> fieldList) {
    controllerList.clear();
    fieldLables.clear();
    return Column(
        children: fieldList.map((element) {
      TextEditingController controller = TextEditingController();
      controllerList.add(controller);
      fieldLables.add(element);
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: element),
      );
    }).toList());
  }

  Map<String, dynamic> getListData(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> listData = {};
    listData['credit'] = ref.watch(creditDebit);
    listData['cattegory'] = ref.watch(categorySelector);
    listData['maxAmount'] = double.parse(maxAmount_inp.text);
    listData['minAmount'] = double.parse(minAmount_inp.text);
    listData['period'] = ref.watch(periodSelector);
    listData['frequency'] = ref.watch(periodSelector);
    ref.watch(creditDebit) == true
        ? listData.addAll(getSelfBenAccount())
        : listData.addAll(getSelfRemAccount());

    if (ref.watch(categorySelector) == 'linked account transfer' ||
        ref.watch(categorySelector) == 'cash withdrawal' ||
        ref.watch(categorySelector) == 'cash deposit') {
      listData.addAll(getSelfBenAccount());
      listData.addAll(getSelfRemAccount());
    }
    if (ref.watch(isRandomTransaction) == true) {
      listData.addAll(getRandomListData(context, ref));
    } else {
      for (var i = 0; i < fieldLables.length; i++) {
        listData[fieldLables[i].toLowerCase()] = controllerList[i].text;
      }
    }

    //print("list data ${listData}");
    return listData;
  }

  Map<String, dynamic> getRandomListData(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> rndData = {};

    // List refList = ["ATM", "Branch"];
    // var randRef = refList[math.Random().nextInt(refList.length)];
    // List tpt = [
    //   'loan',
    //   'gift',
    //   'rent',
    //   'bill',
    //   'lunch',
    //   'coffee',
    //   'food',
    //   'dinner',
    //   'thank you',
    //   'love you',
    //   'chair',
    //   'bike',
    //   'gumtree',
    //   'facebook market',
    // ];
    // var randtpt = tpt[math.Random().nextInt(tpt.length + 1)];

    if (ref.watch(categorySelector) == 'cash withdrawal' ||
        ref.watch(categorySelector) == 'cash deposit') {
      rndData["reference"] =
          '${randomRef()}, ${randomStreets()}, ${randomSuburbs()}';
    } else if (ref.watch(categorySelector) == 'linked account transfer') {
      rndData["reference"] = '';
    } else if (ref.watch(categorySelector) == 'cash deposit third party') {
      rndData["reference"] = '';
      rndData.addAll(getRandomRem());
      // rndData["Remitter _Name"] = randomName();
      // rndData["Remitter_Account"] = randomAccount();
      // rndData["Remitter_Bank"] = randomBank();
      // rndData["Remitter_BSB"] = randomBSB();
    } else if (ref.watch(categorySelector) == 'cheque deposit') {
      rndData["reference"] =
          '${randomRef()}, ${randomStreets()}, ${randomSuburbs()}';
      rndData.addAll(getRandomRem());

      // rndData["Remitter _Name"] = randomName();
      // rndData["Remitter_Account"] = randomAccount();
      // rndData["Remitter_Bank"] = randomBank();
      // rndData["Remitter_BSB"] = randomBSB();
    } else if (ref.watch(categorySelector) == 'payment' ||
        ref.watch(categorySelector) == 'IFT') {
      rndData["reference"] = '';
      rndData.addAll(getRandomBen());

      // rndData["Beneficiary_Name"] = randomName();
      // rndData["Beneficiary_Account"] = randomAccount();
      // rndData["Beneficiary_Bank"] = randomBank();
      // rndData["Beneficiary_BSB"] = randomBSB();
    } else {
      rndData["reference"] = randomTPTF();
      if (ref.watch(creditDebit) == true) {
        rndData.addAll(getRandomRem());

        // rndData["Remitter _Name"] = randomName();
        // rndData["Remitter_Account"] = randomAccount();
        // rndData["Remitter_Bank"] = randomBank();
        // rndData["Remitter_BSB"] = randomBSB();
      } else {
        rndData.addAll(getRandomBen());
        // rndData["Beneficiary_Name"] = randomName();
        // rndData["Beneficiary_Account"] = randomAccount();
        // rndData["Beneficiary_Bank"] = randomBank();
        // rndData["Beneficiary_BSB"] = randomBSB();
      }
    }

    return rndData;
  }

  Map<String, dynamic> getSelfBenAccount() {
    Map<String, dynamic> selBenData = {};
    selBenData["Beneficiary _Name"] = 'Beneficiary';
    selBenData["Beneficiary_Account"] = 'My_ account';
    selBenData["Beneficiary_Bank"] = 'my_bank';
    selBenData["Beneficiary_BSB"] = 'my bsb';
    return selBenData;
  }

  Map<String, dynamic> getSelfRemAccount() {
    Map<String, dynamic> selfRemData = {};
    selfRemData["Remitter _Name"] = 'Remitter';
    selfRemData["Remitter_Account"] = 'My_ account';
    selfRemData["Remitter_Bank"] = 'my_bank';
    selfRemData["Remitter_BSB"] = 'my bsb';
    return selfRemData;
  }

  Map<String, dynamic> getRandomBen() {
    Map<String, dynamic> benData = {};
    benData["Beneficiary_Name"] = randomName();
    benData["Beneficiary_Account"] = randomAccount();
    benData["Beneficiary_Bank"] = randomBank();
    benData["Beneficiary_BSB"] = randomBSB();
    return benData;
  }

  Map<String, dynamic> getRandomRem() {
    Map<String, dynamic> remData = {};
    remData["Remitter _Name"] = randomName();
    remData["Remitter_Account"] = randomAccount();
    remData["Remitter_Bank"] = randomBank();
    remData["Remitter_BSB"] = randomBSB();
    return remData;
  }
}
