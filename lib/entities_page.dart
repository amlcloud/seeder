import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/widgets/entities_list.dart';
import 'package:seeder/widgets/entity_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class EntitiesPage extends ConsumerWidget {
  const EntitiesPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('entity page rebuild');
    return Scaffold(
        appBar: MyAppBar.getBar(context),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: Column(
                    children: [
                      EntitiesList(),
                      buildAddEntityButton(context, ref)
                    ],
                  )),
                  Expanded(
                    child: EntityDetails(ref.watch(activeEntity)),
                  )
                ])));
  }
  // Code written by Joanne
  // buildAddEntityButton(WidgetRef ref) {
  //   return ElevatedButton(onPressed: () {
  //     FirebaseFirestore.instance.collection('entity').add({'id':'', 'name':'', 'desc':''});
  //   },
  //   child: Text('Add Entity'));
  // }


  // Edited version: vnguyen
  buildAddEntityButton(BuildContext context, WidgetRef ref) {
    TextEditingController id_inp = TextEditingController();
    TextEditingController name_inp = TextEditingController();
    TextEditingController desc_inp = TextEditingController();
    return ElevatedButton(
      child: Text("Add Entity"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Adding Entity...'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: id_inp,
                          decoration: InputDecoration(
                            labelText: 'ID'
                            ),
                        ),
                        TextFormField(
                          controller: name_inp,
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          controller: desc_inp,
                          decoration: InputDecoration(
                            labelText: 'Description',
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
                        FirebaseFirestore.instance.collection('entity').add({'id': id_inp.text.toString(), 'name': name_inp.text.toString(), 'desc': desc_inp.text.toString()});
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      },
    );

  }
}
