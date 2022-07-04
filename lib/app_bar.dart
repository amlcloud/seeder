import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/main.dart';

class MyAppBar {
  static final List<String> _tabs = ['entities', 'batches'];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: TabBar(
        tabs: _tabs
            .map((t) => Tab(
                iconMargin: EdgeInsets.all(0),
                child:
                    // GestureDetector(
                    //     behavior: HitTestBehavior.translucent,
                    //onTap: () => navigatePage(text, context),
                    //child:
                    Text(t.toUpperCase(),
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            color:
                                // Theme.of(context).brightness == Brightness.light
                                //     ? Color(DARK_GREY)
                                //:
                                Colors.white))))
            .toList(),
        onTap: (index) {
          Navigator.of(context).pushNamed(_tabs[index]);
        },
      ),
      actions: [
        IconButton(
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: Icon(Icons.exit_to_app))
      ],
    );
  }
}
