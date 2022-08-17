import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/add_specific_config.dart';
import 'package:seeder/entity/config/specific_config_list.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpecificConfig extends ConsumerWidget {
  final String entityId;
  final String currentAuthor = FirebaseAuth.instance.currentUser!.uid;
  SpecificConfig(this.entityId);

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
                    Text('available periodic templates'),
                    Expanded(
                      child: SingleChildScrollView(
                          child: SpecificConfigList(entityId)),
                    ),
                    Divider(),
                    Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Add templates '),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (entityDoc.data()!['author'] == currentAuthor) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddSpecificConfig(entityId);
                                  });
                            }
                          },
                        )
                      ],
                    ))
                  ],
                ))
              ])));
}
