import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/app_bar_old.dart';
import 'package:seeder/entity/entities_list.dart';
import 'package:seeder/entity/entity_details.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main_app_bar.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class EntitiesPage extends ConsumerWidget {
  static String get routeName => 'entities';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MainAppBar.getBar(context, ref),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      flex: 1,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          EntitiesList(),
                          buildAddEntityButton(context, ref),
                        ],
                      ))),
                  Expanded(
                    flex: 4,
                    child: ref.watch(activeEntity) == null
                        ? Container()
                        : EntityDetails(ref.watch(activeEntity)!),
                  )
                ])));
  }

  buildAddEntityButton(BuildContext context, WidgetRef ref) {
    TextEditingController id_inp = TextEditingController();
    TextEditingController name_inp = TextEditingController();
    TextEditingController desc_inp = TextEditingController();
    TextEditingController bsb_inp = TextEditingController();
    TextEditingController account_inp = TextEditingController();
    TextEditingController bank_inp = TextEditingController();
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
                          decoration: InputDecoration(labelText: 'ID'),
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
                        TextFormField(
                          controller: bank_inp,
                          decoration: InputDecoration(labelText: 'Bank'),
                        ),
                        TextFormField(
                          controller: account_inp,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                          ),
                        ),
                        TextFormField(
                          controller: bsb_inp,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'BSB',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      child: Text("Submit"),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('entity').add({
                          'id': id_inp.text.toString(),
                          'name': name_inp.text.toString(),
                          'desc': desc_inp.text.toString(),
                          'bank': bank_inp.text.toString().toUpperCase(),
                          'account': account_inp.text.toString(),
                          'bsb': bsb_inp.text.toString(),
                          'time Created': FieldValue.serverTimestamp(),
                          'author': FirebaseAuth.instance.currentUser!.uid,
                          // 'author': FirebaseAuth.instance.currentUser!.uid
                        });
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      },
    );
  }
}
