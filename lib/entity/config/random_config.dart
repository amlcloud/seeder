import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/add_config_field.dart';
import 'package:seeder/entity/config/config_list.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RandomConfig extends ConsumerWidget {
  final String currentAuthor = FirebaseAuth.instance.currentUser!.uid;
  final String entityId;
  RandomConfig(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docFP('entity/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Column(children: [
                Expanded(
                    child: Column(
                  children: [
                    Text('available random templates'),
                    Expanded(
                      child: SingleChildScrollView(
                          child: ConfigList(entityId, "randomConfig",
                              entityDoc.data()!["author"] == currentAuthor)),
                    ),
                    Divider(),
                    // Card(
                    //     child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text('Add templates '),
                    //     IconButton(
                    //       icon: Icon(Icons.add),
                    //       onPressed: entityDoc.data()!['author'] == currentAuthor? () {
                    //           showDialog(
                    //               context: context,
                    //               builder: (BuildContext context) {
                    //                 return AddConfigField("randomConfig", entityId);
                    //               });
                    //       }:null,
                    //     )
                    //   ],
                    // )),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(400, 40),
                        ),
                        label: const Text('Add random config'),
                        onPressed: entityDoc.data()!['author'] == currentAuthor
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddConfigField(
                                          "randomConfig", entityId);
                                    });
                              }
                            : null,
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ))
              ])));
}
