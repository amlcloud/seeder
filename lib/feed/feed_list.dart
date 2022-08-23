import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/feed/feed_list_item.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';


class FeedList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Group(
      child: ref.watch(colSP('feedSettings')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (userDoc) => userDoc.docs.isEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: ListTile(
                    tileColor: Color.fromARGB(255, 44, 44, 44),
                    focusColor: Color.fromARGB(255, 133, 116, 116),
                    title: Center(
                      child: Text('No data found'),
                    ),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: userDoc.docs
                      .map((userData) => FeedListItem(userData.id))
                      .toList())));
}
