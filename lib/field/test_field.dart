import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/field/add_specific_config_field.dart';
import 'package:seeder/field/field_selector.dart';
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddSpecificConfigField('SGLIbR4Wm7c7moKPgBX0');
                      });
                },
              ),
            )),
            Expanded(child: Text('Value: ${ref.watch(count)}')),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  child: const Text('Button label'),
                  onPressed: () => example(),
                ),
              ),
            )
          ]),
        ));
  }

  example() async {
    var data = await FirebaseFirestore.instance.collection("field").get();
    Map<String, dynamic> mapData = {};
    //print("example data:${data.docs}");
    data.docs.forEach((element) {
      mapData[element.data()['name']] = element.data()['name'];
    });
    //print("example data:${mapData}");

    List<dynamic> temp = ['test', 'test2', 'test3', 'test4', 'test5'];

    temp.forEach((element) {
      mapData['ben_name'] = element;
      print("Test2 : $mapData");
    });
  }
}
