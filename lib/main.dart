import 'package:auth/main.dart';
import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:sandbox/sandbox_launcher2.dart';
import 'package:seeder/sandbox_app.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:theme/config.dart';
import 'firebase_options.dart';
import 'main_app_widget.dart';

void main() async {
  Chain.capture(() async {
    WidgetsFlutterBinding.ensureInitialized();

    AuthConfig.enableGoogleAuth = true;
    AuthConfig.enableGithubAuth = false;
    AuthConfig.enableSsoAuth = false;
    AuthConfig.enableEmailAuth = false;
    // AuthConfig.enablePhoneAuth = false;
    AuthConfig.enableAnonymousAuth = false;
    // AuthConfig.enableAppleAuth = false;
    AuthConfig.enableSignupOption = false;
    AuthConfig.enableLinkedinOption = false;
    AuthConfig.enableFacebookOption = false;
    AuthConfig.enableTwitterOption = false;

    // ThemeModeConfig. = true;
    ThemeModeConfig.defaultToLightTheme = true;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kReleaseMode) {
      await dotenv.load(fileName: "assets/env.production");
    } else {
      await dotenv.load(fileName: "assets/env.development");
    }

    runApp(SandboxLauncher2(
      enabled: const String.fromEnvironment('SANDBOX') == 'true',
      app: ProviderScope(child: MainApp()),
      sandbox: SandboxApp(),
      getInitialState: () async {
        final res = kUSR == null
            ? Future.value(false)
            : kDB
                .doc('sandbox/${kUSR!.uid}')
                .get()
                .then((doc) => doc.data()?['sandbox'] ?? false);
        return res;
      },
      saveState: (state) {
        return kUSR == null
            ? Future.value(false)
            : kDB.doc('sandbox/${kUSR!.uid}').set({'sandbox': state});
      },
    ));
  }, onError: (error, Chain chain) {
    // print('Caught error $error\nStack trace: ${Trace.format(new Chain.forTrace(chain))}');
    print('ERROR: $error\n${condenseError(error, chain)}');
  });
}

final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));

final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
    (ref) => GenericStateNotifier<bool>(false));


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:seeder/batch/batch_page.dart';
// import 'package:seeder/entity/entities_page.dart';
// import 'package:seeder/feed/feed_page.dart';
// import 'package:seeder/login_page.dart';
// import 'package:seeder/state/generic_state_notifier.dart';
// import 'package:seeder/state/theme_state_notifier.dart';
// import 'package:seeder/theme.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
//   runApp(ProviderScope(child: MainApp()));
// }

// class MainApp extends ConsumerWidget {
//   const MainApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool isDarkTheme = ref.watch(themeStateNotifierProvider);
//     return MaterialApp(
//       title: 'Data Generator',
//       themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
//       theme: lightTheme,
//       darkTheme: darkTheme,
//       home: TheApp(),
//     );
//   }
// }

// final isLoggedIn = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
//     (ref) => GenericStateNotifier<bool>(false));

// final isLoading = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
//     (ref) => GenericStateNotifier<bool>(false));

// class TheApp extends ConsumerStatefulWidget {
//   const TheApp({Key? key}) : super(key: key);
//   @override
//   TheAppState createState() => TheAppState();
// }

// class TheAppState extends ConsumerState<TheApp> {
//   //bool isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     ref.read(isLoading.notifier).value = true;
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         ref.read(isLoggedIn.notifier).value = false;
//         ref.read(isLoading.notifier).value = false;
//       } else {
//         ref.read(isLoggedIn.notifier).value = true;
//         ref.read(isLoading.notifier).value = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (ref.watch(isLoading)) {
//       return Center(
//         child: Container(
//           alignment: Alignment(0.0, 0.0),
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       // fixme: should only one Scaffold
//       return Scaffold(
//           body: ref.watch(isLoggedIn) == false
//               ? LoginPage()
//               : DefaultTabController(
//                   initialIndex: 0,
//                   length: 3,
//                   child: Navigator(
//                     onGenerateRoute: (RouteSettings settings) {
//                       // print('onGenerateRoute: ${settings}');
//                       if (settings.name == '/' || settings.name == 'entities') {
//                         return PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => EntitiesPage());
//                       } else if (settings.name == 'batches') {
//                         return PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => BatchesPage());
//                       } else if (settings.name == 'feeds') {
//                         return PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => FeedsPage());
//                       } else {
//                         throw 'no page to show';
//                       }
//                     },
//                   )));
//     }
//   }
// }
