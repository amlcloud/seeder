import 'package:flutter/material.dart';
import 'package:seeder/people_page.dart';
import 'package:seeder/sets_page.dart';
import 'package:seeder/theme.dart';

import 'dev_frame.dart';

void main() {
  runApp(TheApp());
}

class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Data Generator',
        themeMode: ThemeMode.dark,
        darkTheme: darkTheme,
        home: WillPopScope(
          onWillPop: () async => false,
          child: DevFrameLauncher(
              child: DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Navigator(
                    onGenerateRoute: (RouteSettings settings) {
                      // print('onGenerateRoute: ${settings}');
                      if (settings.name == '/' || settings.name == 'entities') {
                        return PageRouteBuilder(
                            pageBuilder: (_, __, ___) => PeoplePage());
                      } else if (settings.name == 'sets') {
                        return PageRouteBuilder(
                            pageBuilder: (_, __, ___) => SetsPage());
                      } else {
                        throw 'no page to show';
                      }
                    },
                  ))),
        ));
  }
}
