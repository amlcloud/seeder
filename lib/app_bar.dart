import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/avatar_image.dart';
import 'package:seeder/main.dart';
import 'package:seeder/setting/setting_page.dart';
import 'package:seeder/state/theme_state_notifier.dart';
import 'package:userprofile/userprofile.dart';

class MyAppBar {
  static final List<String> _tabs = ['entities', 'batches', 'feeds'];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      leading: Padding(
        padding: EdgeInsets.all(10),
        child: Image.asset(
          "assets/amlcloudlogodark_removebg_crop.png",
        ),
      ),
      title: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
              width: 500,
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
        Container(
          margin: EdgeInsets.all(2),
          child: AppBarUserProfile(),
        ),
        //Text('${FirebaseAuth.instance.currentUser!.uid}'),
        ///
        /// if person is not logged-in or anonymous show person icon
        /// otherwise show photo from his profile
        ///
        ///https://firebase.google.com/docs/auth/flutter/manage-users
        ///
        SettingPageIconButton(),
        ThemeIconButton(),
        //Icon(Icons.person),
        IconButton(
            tooltip: 'sign out',
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: Icon(Icons.exit_to_app)),
        // AvatarImage(),
      ],
    );
  }
}

class ThemeIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}

class SettingPageIconButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: "Setting",
      waitDuration: Duration(seconds: 2),
      child: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return SettingPage();
                },
              )),
          icon: Icon(Icons.settings)),
    );
  }
}
