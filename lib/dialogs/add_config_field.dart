import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/custom_date_picker.dart';
import 'package:seeder/controls/custom_dropdown.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/random_datas/random_TPT.dart';
import 'package:seeder/random_datas/random_bank_details.dart';
import 'package:seeder/random_datas/random_names.dart';
import 'package:seeder/random_datas/random_streets.dart';
import 'package:seeder/random_datas/random_suburbs.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:intl/intl.dart';

class AddConfigField extends ConsumerWidget {
  AddConfigField(this.configType, this.entityId);
  final String configType;
  final String entityId;
  final List<TextEditingController> controllerList = [];
  final List<String> fieldLables = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final isValiedAmount =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final isValiedDateTime =
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
  final isValiedDayFreq =
      StateNotifierProvider<GenericStateNotifier<bool>, bool>(
          (ref) => GenericStateNotifier<bool>(false));
  final TextEditingController title_inp = TextEditingController();
  final TextEditingController maxAmount_inp =
      TextEditingController.fromValue(TextEditingValue(text: "1"));
  final TextEditingController minAmount_inp =
      TextEditingController.fromValue(TextEditingValue(text: "0"));
  final TextEditingController dayFrequency_inp =
      TextEditingController.fromValue(TextEditingValue(text: "1"));
  final TextEditingController dateTime_inp = TextEditingController.fromValue(
      TextEditingValue(text: DateTime.now().toUtc().toString()));
  final TextEditingController benBSB_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomBSB()));
  final TextEditingController benAccount_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomAccount()));
  final TextEditingController benName_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomName()));
  final TextEditingController benBank_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomBank()));
  final TextEditingController remBSB_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomBSB()));
  final TextEditingController remAccount_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomAccount()));
  final TextEditingController remName_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomName()));
  final TextEditingController remBank_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomBank()));
  final TextEditingController reference_inp =
      TextEditingController.fromValue(TextEditingValue(text: randomTPTF()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    reference_inp.text =
        ref.watch(categorySelector) == 'linked account transfer' ||
                ref.watch(categorySelector) == 'cash withdrawal' ||
                ref.watch(categorySelector) == 'cheque deposit'
            ? '${randomRef()}, ${randomStreets()}, ${randomSuburbs()}'
            : randomTPTF();

    maxAmount_inp.addListener(() {
      if (int.parse(minAmount_inp.text) >= int.parse(maxAmount_inp.text)) {
        ref.read(isValiedAmount.notifier).value = true;
      } else {
        ref.read(isValiedAmount.notifier).value = false;
      }
    });

    var dayOrFrequence = configType == "periodicConfig" ? "Day" : "Frequency";

    dayFrequency_inp.addListener(() {
      int day = ref.read(periodSelector) == "Week"
          ? 7
          : ref.read(periodSelector) == "Month"
              ? 28
              : 84;
      if (int.parse(dayFrequency_inp.text) > day ||
          int.parse(dayFrequency_inp.text) <= 0) {
        ref.read(isValiedDayFreq.notifier).value = true;
      } else {
        ref.read(isValiedDayFreq.notifier).value = false;
      }
    });

    List<String> categoryCredit = [
      'cash deposit',
      'cash deposit third party',
      'cheque deposit',
      'third party transfer'
    ];
    List<String> categoryDebit = [
      'purchase',
      'payment',
      'cash withdrawal',
      'linked account transfer',
      'third party transfer',
      'IFT',
    ];
    if (ref.watch(categorySelector) == 'linked account transfer' ||
        ref.watch(categorySelector) == 'cash withdrawal' ||
        ref.watch(categorySelector) == 'cheque deposit') {
      reference_inp.text =
          '${randomRef()}, ${randomStreets()}, ${randomSuburbs()}';
    }

    return AlertDialog(
      scrollable: true,
      title: Text(configType == "PeriodicConfig"
          ? 'Adding Periodic Config...'
          : 'Adding Random Config...'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: title_inp,
                decoration: InputDecoration(labelText: 'Title'),
              ),
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
              CustomDropdown(
                  "Select Category",
                  (ref.watch(creditDebit) ? categoryCredit : categoryDebit),
                  categorySelector),
              ref.watch(categorySelector) != null
                  ? ref.watch(creditDebit) == false
                      ? ref.watch(categorySelector) ==
                                  'linked account transfer' ||
                              ref.watch(categorySelector) == 'cash withdrawal'
                          ? TextFormField(
                              controller: reference_inp,
                              decoration: InputDecoration(
                                labelText: 'Reference',
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: benName_inp,
                                  decoration: InputDecoration(
                                      labelText: 'Beneficiary Name'),
                                ),
                                TextFormField(
                                  controller: benAccount_inp,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Beneficiary Account',
                                  ),
                                ),
                                TextFormField(
                                  controller: benBSB_inp,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      labelText: 'Beneficiary BSB'),
                                ),
                                TextFormField(
                                  controller: benBank_inp,
                                  decoration: InputDecoration(
                                    labelText: 'Beneficiary Bank',
                                  ),
                                ),
                                TextFormField(
                                  controller: reference_inp,
                                  decoration: InputDecoration(
                                    labelText: 'Reference',
                                  ),
                                ),
                              ],
                            )
                      : ref.watch(categorySelector) == 'cash deposit'
                          ? TextFormField(
                              controller: reference_inp,
                              decoration: InputDecoration(
                                labelText: 'Reference',
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: remName_inp,
                                  decoration: InputDecoration(
                                      labelText: 'Remitter Name'),
                                ),
                                TextFormField(
                                  controller: remAccount_inp,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Remitter Account',
                                  ),
                                ),
                                TextFormField(
                                  controller: remBSB_inp,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      labelText: 'Remitter BSB'),
                                ),
                                TextFormField(
                                  controller: remBank_inp,
                                  decoration: InputDecoration(
                                    labelText: 'Remitter Bank',
                                  ),
                                ),
                                TextFormField(
                                  controller: reference_inp,
                                  decoration: InputDecoration(
                                    labelText: 'Reference',
                                  ),
                                ),
                              ],
                            )
                  : Container(),

              /// specificConfig doesnt need min or max ammount and periods just need amount.
              configType == 'specificConfig'
                  ? Column(
                      children: <Widget>[
                        TextFormField(
                          controller: minAmount_inp,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(labelText: 'Amount'),
                        ),
                        CustomDatePicker('Select date', dateTime_inp)
                      ],
                    )
                  : Column(
                      children: <Widget>[
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
                        CustomDropdown("Select period",
                            ['Week', 'Month', 'Quarter'], periodSelector),
                        TextFormField(
                          controller: dayFrequency_inp,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              labelText: ref.watch(periodSelector) == "Week"
                                  ? 'Selecy ${dayOrFrequence} 1-7'
                                  : ref.watch(periodSelector) == "Month"
                                      ? 'Selecy ${dayOrFrequence} 1-28'
                                      : 'Selecy ${dayOrFrequence} 1-84'),
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(top: 5),
                          child: ref.watch(isValiedDayFreq)
                              ? Text(
                                  ref.watch(periodSelector) == "Week"
                                      ? 'please selecy ${dayOrFrequence} 1-7'
                                      : ref.watch(periodSelector) == "Month"
                                          ? 'Please selecy ${dayOrFrequence} 1-28'
                                          : 'Please selecy ${dayOrFrequence} 1-84',
                                  style: Theme.of(context).textTheme.labelSmall,
                                )
                              : Container(),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            child: Text("Submit"),
            onPressed: () async {
              if (!ref.read(isValiedAmount) &&
                      !ref.read(isValiedDayFreq) &&
                      ref.read(periodSelector) != null ||
                  configType == 'specificConfig' &&
                      ref.read(categorySelector) != null) {
                //print(getListData(context, ref));

                await getListData(context, ref, configType).then((resData) {
                  print(resData);
                  if (configType == 'specificConfig') {
                    FirebaseFirestore.instance
                        .collection('entity')
                        .doc(entityId)
                        .collection('specificConfig')
                        .doc(title_inp.text)
                        .set(resData)
                        .then((res) {
                      print("Done");
                      Navigator.of(context).pop();
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection(configType)
                        .doc(title_inp.text)
                        .set(resData)
                        .then((res) {
                      print("Done");
                      Navigator.of(context).pop();
                    });
                  }
                });
              }
            })
      ],
    );
  }

  Future<Map<String, dynamic>> getListData(
      BuildContext context, WidgetRef ref, String configType) async {
    Map<String, dynamic> listData = {};
    listData['credit'] = ref.watch(creditDebit);
    listData['cattegory'] = ref.watch(categorySelector);
    listData["reference"] = reference_inp.text;
    listData['author'] = FirebaseAuth.instance.currentUser!.uid;

    /// Differing fields are based on the config type.
    if (configType == "periodicConfig") {
      listData['day'] = int.parse(dayFrequency_inp.text);
      listData['maxAmount'] = double.parse(maxAmount_inp.text);
      listData['minAmount'] = double.parse(minAmount_inp.text);
      listData['period'] = ref.watch(periodSelector);
    } else if (configType == "randomConfig") {
      listData['frequency'] = int.parse(dayFrequency_inp.text);
      listData['maxAmount'] = double.parse(maxAmount_inp.text);
      listData['minAmount'] = double.parse(minAmount_inp.text);
      listData['period'] = ref.watch(periodSelector);
    } else {
      listData['amount'] = double.parse(minAmount_inp.text);
      listData['timestamp'] = DateTime.parse(dateTime_inp.text);
    }

    /// Differing fields values are based on the categorySelector.
    if (ref.watch(categorySelector) == 'linked account transfer' ||
        ref.watch(categorySelector) == 'cash withdrawal' ||
        ref.watch(categorySelector) == 'cash deposit') {
      listData.addAll(await getSelfAccountDetails(entityId, "Beneficiary"));
      listData.addAll(await getSelfAccountDetails(entityId, "Remitter"));
    } else if (ref.watch(creditDebit)) {
      listData.addAll(await getSelfAccountDetails(entityId, "Beneficiary"));
      listData["Remitter_Name"] = remName_inp.text;
      listData["Remitter_Account"] = int.parse(remAccount_inp.text);
      listData["Remitter_Bank"] = remBank_inp.text;
      listData["Remitter_BSB"] = int.parse(remBSB_inp.text);
    } else {
      listData.addAll(await getSelfAccountDetails(entityId, "Remitter"));
      listData["Beneficiary_Name"] = benName_inp.text;
      listData["Beneficiary_Account"] = int.parse(benAccount_inp.text);
      listData["Beneficiary_Bank"] = benBank_inp.text;
      listData["Beneficiary_BSB"] = int.parse(benBSB_inp.text);
    }

    return listData;
  }
}

Future<Map<String, dynamic>> getSelfAccountDetails(
    String entityId, String requiredDetail) async {
  DocumentSnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore.instance.collection('entity').doc(entityId).get();
  Map<String, dynamic> selBenData = {};
  if (requiredDetail == "Beneficiary") {
    selBenData["Beneficiary_Name"] = data.data()!['name'];
    selBenData["Beneficiary_Account"] = data.data()!['account'];
    selBenData["Beneficiary_Bank"] = data.data()!['bank'];
    selBenData["Beneficiary_BSB"] = data.data()!['bsb'];
  } else {
    selBenData["Remitter_Name"] = data.data()!['name'];
    selBenData["Remitter_Account"] = data.data()!['account'];
    selBenData["Remitter_Bank"] = data.data()!['bank'];
    selBenData["Remitter_BSB"] = data.data()!['bsb'];
  }
  return selBenData;
}
