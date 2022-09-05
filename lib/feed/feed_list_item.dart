import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/feed/feed_page.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedListItem extends ConsumerWidget {
  final String userDocId;
  const FeedListItem(this.userDocId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP('feedSettings/' + userDocId)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (userData) => userData.exists == false
            ? Center(child: Text('No user data found'))
            : Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.onSecondary,
                  focusColor: Theme.of(context).colorScheme.secondary,
                  trailing: userData.data()!['author'] ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('feedSettings')
                                .doc(userDocId)
                                .delete()
                                .then((value) => ref
                                    .watch(activeFeed.notifier)
                                    .value = null);
                          },
                          padding: EdgeInsets.all(10),
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        )
                      : Text(''),
                  leading: Text(
                    userData.data()!['name'],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  title: Text(userData.data()!['id']),
                  subtitle: Text(userData.data()!['desc']),
                  onTap: () {
                    ref.read(activeFeed.notifier).value = userData.id;
                  },
                ),
              ));
  }
}
