import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batches_page/batch_page.dart';
import 'package:seeder/entities_page.dart';
import 'package:seeder/sandbox/sandbox.dart';
import 'package:seeder/sandbox/sandbox_launcher.dart';
import 'package:seeder/state/generic_state_notifier.dart';
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
    // home: SandboxLauncher(
    //     // sandbox for texting individual widgets
    //     sandbox: Material(child: Sandbox()),
    // the main app
    // app: TheApp()),
    home: TheApp(),
  )));
}

final isLogedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

class TheApp extends ConsumerStatefulWidget {
  const TheApp({Key? key}) : super(key: key);
  @override
  TheAppState createState() => TheAppState();
}

class TheAppState extends ConsumerState<TheApp> {
  @override
  void initState() {
    super.initState();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // print('User is currently signed out!');
      } else {
        ref.read(isLogedIn.notifier).value = true;
        // print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(isLogedIn) == false
            ? Column(
                children: [
                  Text('please log in'),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signInAnonymously();
                        ref.read(isLogedIn.notifier).value = true;
                      },
                      child: Text('log-in')),
                ],
              )
            : DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Navigator(
                  onGenerateRoute: (RouteSettings settings) {
                    // print('onGenerateRoute: ${settings}');
                    if (settings.name == '/' || settings.name == 'entities') {
                      return PageRouteBuilder(
                          pageBuilder: (_, __, ___) => EntitiesPage());
                    } else if (settings.name == 'batches') {
                      return PageRouteBuilder(
                          pageBuilder: (_, __, ___) => BatchesPage());
                    } else {
                      throw 'no page to show';
                    }
                  },
                )));
  }
}
