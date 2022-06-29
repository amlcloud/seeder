import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entities_page.dart';
import 'package:seeder/sandbox/sandbox.dart';
import 'package:seeder/sandbox/sandbox_launcher.dart';
import 'package:seeder/sets_page.dart';
import 'package:seeder/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MaterialApp(
    title: 'Data Generator',
    themeMode: ThemeMode.dark,
    darkTheme: darkTheme,
    home: SandboxLauncher(
        // sandbox for texting individual widgets
        sandbox: Material(child: Sandbox()),
        // the main app
        app: TheApp()),
  )));
}

class TheApp extends StatelessWidget {
  const TheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) {
            // print('onGenerateRoute: ${settings}');
            if (settings.name == '/' || settings.name == 'entities') {
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => EntitiesPage());
            } else if (settings.name == 'sets') {
              return PageRouteBuilder(pageBuilder: (_, __, ___) => SetsPage());
            } else {
              throw 'no page to show';
            }
          },
        ));
  }
}
