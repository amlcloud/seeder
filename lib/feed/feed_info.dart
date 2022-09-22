import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../state/generic_state_notifier.dart';

final postResult =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));
final resLoader = StateNotifierProvider<GenericStateNotifier<bool?>, bool?>(
    (ref) => GenericStateNotifier<bool?>(false));

class FeedInfo extends ConsumerWidget {
  const FeedInfo(this.userDocId);
  final String userDocId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Group(
        child: ref.watch(docSP('feedSettings/' + userDocId)).when(
            loading: () => Container(),
            error: (e, s) => ErrorWidget(e),
            data: (userData) => userData.exists == false
                ? Center(child: Text('No user data found'))
                : Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                            child: Text(
                          "Feed Information",
                          style: Theme.of(context).textTheme.headline6,
                        )),
                        Column(
                          children: (userData.data()!.entries.toList()
                                ..sort(((a, b) => a.key.compareTo(b.key))))
                              .map(
                            (entryData) {
                              if (entryData.key == 'batchId' ||
                                  entryData.key == 'author') {
                                return Container();
                              } else {
                                return ListTile(
                                    tileColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    focusColor:
                                        Theme.of(context).colorScheme.secondary,
                                    title: Text(
                                        entryData.key.toString().toUpperCase()),
                                    subtitle: entryData.key == 'time Created'
                                        ? Text(
                                            entryData.value.toDate().toString())
                                        : Text(entryData.value.toString()));
                              }
                            },
                          ).toList(),
                        ),
                        userData.data()!['author'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Group(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Post selected batch transaction to the main application',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: <Widget>[
                                              ElevatedButton(
                                                child: const Text(
                                                    'Post transaction'),
                                                onPressed: () {
                                                  ref
                                                      .read(resLoader.notifier)
                                                      .value = true;
                                                  postBatch(userData, ref);
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: ref.watch(resLoader) ==
                                                        true
                                                    ? SizedBox(
                                                        height: 15.0,
                                                        width: 15.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      )
                                                    : ref.watch(postResult) !=
                                                            null
                                                        ? Text(ref
                                                            .watch(postResult)
                                                            .toString())
                                                        : Container(),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ))
                            : Container(),
                      ],
                    ))));
  }
}

Future<void> postBatch(
    DocumentSnapshot<Map<String, dynamic>> userData, WidgetRef ref) async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('postBatch');
  final resp = await callable
      .call(<String, dynamic>{
        'feedId': userData.id,
        'batchId': userData.data()!['batchId'],
      })
      .then((value) => {
            ref.read(postResult.notifier).value = value.data,
            ref.read(resLoader.notifier).value = false
          })
      .catchError((err) => {
            ref.read(postResult.notifier).value = 'Somthing went wrong',
            ref.read(resLoader.notifier).value = false
          });
}
