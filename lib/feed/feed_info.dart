import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/providers/firestore.dart';

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
                          "Feed Info",
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
                                    tileColor: Theme.of(context).colorScheme.onSecondary,
                                    focusColor:Theme.of(context).colorScheme.secondary,
                                    title: Text(
                                        entryData.key.toString().toUpperCase()),
                                    subtitle: entryData.key == 'time Created'
                                        ? Text(
                                            entryData.value.toDate().toString())
                                        : Text(entryData.value.toString()));
                              }
                            },
                          ).toList(),
                        )
                      ],
                    ))));
  }
}
