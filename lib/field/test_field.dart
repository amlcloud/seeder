import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/field/add_specific_config_field.dart';
import 'package:seeder/random_datas/random_bank_details.dart';
import 'package:seeder/random_datas/random_names.dart';
import 'package:seeder/random_datas/random_retailers.dart';
import 'package:seeder/random_datas/random_streets.dart';
import 'package:seeder/random_datas/random_suburbs.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class TestField extends ConsumerWidget {
  TestField({Key? key}) : super(key: key);
  final count = StateNotifierProvider<GenericStateNotifier<int?>, int?>(
      (ref) => GenericStateNotifier<int?>(1));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Center(
          child: Column(children: [
            Expanded(
              child: Center(
                child: ElevatedButton(
                  child: const Text('Button label'),
                  onPressed: () async => await example(),
                ),
              ),
            )
          ]),
        ));
  }

  example() async {
    // var data =
    //     await FirebaseFirestore.instance.collection("samplePersonName").get();
    Map<String, dynamic> mapData = {};
    List<String> temp = [];
    //print("example data:${data.docs}");
    // data.docs.forEach((element) {
    //   print(element);
    //   temp.add(element.data().toString());
    //   //mapData[element.data()['name']] = element.data()['name'];
    // });
    // return temp;
    mapData["name"] = randomName();
    mapData["bank"] = randomBank();
    mapData["bsb"] = randomBSB();
    mapData["account"] = randomAccount();
    mapData['branch'] = "${randomSuburbs()}, ${randomStreets()}";
    mapData["retailers"] = randomRetailers();
    print("example data:${mapData}");
  }
}
