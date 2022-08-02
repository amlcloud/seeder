import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/main.dart';

class MyAppBar {
  static final List<String> _tabs = ['entities', 'batches'];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
              width: 300,
              child: TabBar(
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
              ))),
      actions: [
        //Text('${FirebaseAuth.instance.currentUser!.uid}'),
        ///
        /// if person is not logged-in or anonymous show person icon
        /// otherwise show photo from his profile
        ///
        ///https://firebase.google.com/docs/auth/flutter/manage-users
        ///
        Icon(Icons.person),
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
