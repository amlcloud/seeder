import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creditNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class RandomConfig extends ConsumerWidget {

  const RandomConfig({
    Key? key,
  }) : super(key: key);

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
                        trailing:
                            IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('weekly salary'),
                        subtitle: Text('\$500-\$1000'),
                        trailing:
                            IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      )),
                      IconButton(icon: Icon(Icons.add), onPressed: () {
                        showDialog(
                          context: context,
                            builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text('Adding Config'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      // TextFormField(
                                      //   controller: id_inp,
                                      //   decoration: InputDecoration(labelText: 'CREDIT'),
                                      // ),
                                       Text('CREDIT:'),
                                       DropdownButton<String>(
                                        value: '',
                                        onChanged: (String? newValue) {
                                          ref.read(creditNotifierProvider.notifier).value =newValue;
                                        },
                                        items: <String>['True', 'False']
                                          .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value.toUpperCase()),
                                            );
                                          }).toList(),
                                      ),
                
                                    ],
                                  ),
                                ),
                              ),
                          actions: [
                            TextButton(
                              child: Text("Submit"),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('batch').add({
                                  // 'id': id_inp.text.toString(),
                                  // 'name': name_inp.text.toString(),
                                  // 'desc': desc_inp.text.toString(),
                                  // 'time Created': FieldValue.serverTimestamp(),
                                  // 'author': FirebaseAuth.instance.currentUser!.uid,
                                }).then((value) => {
                                  if (value != null)
                                    {FirebaseFirestore.instance.collection('batch')}
                                });

                                Navigator.of(context).pop();
                              })
                          ],
                            );
                          });
      }),
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
