import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seeder/tran_config/tran_config_page.dart';
import 'entity/entities_page.dart';
import 'custom_login_page.dart';

final _key = GlobalKey<NavigatorState>();

final authProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final AsyncValue<User?> authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: EntitiesPage.routeLocation,
    routes: [
      GoRoute(
        path: EntitiesPage.routeLocation,
        name: EntitiesPage.routeName,
        builder: (context, state) {
          return EntitiesPage();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: EntitiesPage(),
        ),
      ),
      GoRoute(
        path: TranConfigPage.routeLocation,
        name: TranConfigPage.routeName,
        builder: (context, state) {
          return TranConfigPage();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: TranConfigPage(),
        ),
      ),
      // GoRoute(
      //     path: CasesPage.routeLocation,
      //     name: CasesPage.routeName,
      //     builder: (context, state) {
      //       return CasesPage();
      //     },
      //     pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
      //           context: context,
      //           state: state,
      //           child: CasesPage(),
      //         ),
      //     routes: [
      //       GoRoute(
      //         path: ':caseId', //CasePage.routeName,
      //         name: CasePage.routeName,
      //         builder: (context, state) {
      //           print(
      //               "state: ${(state.extra as Map<String, dynamic>)['caseId']}");
      //           // get id from state
      //           // final id = state.queryParameters['caseId'] ?? "";
      //           return CasePage(
      //               (state.extra as Map<String, dynamic>)['caseId']);
      //         },
      //         pageBuilder: (context, state) {
      //           // final id = state.queryParameters['caseId'] ?? "";

      //           return buildPageWithDefaultTransition<void>(
      //               context: context,
      //               state: state,
      //               child: CasePage(
      //                   (state.extra as Map<String, dynamic>)['caseId']));
      //         },
      //       ),
      //     ]),
      GoRoute(
        path: CustomLoginPage.routeLocation,
        name: CustomLoginPage.routeName,
        builder: (context, state) {
          return const CustomLoginPage();
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: CustomLoginPage(),
        ),
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // Here we guarantee that hasData == true, i.e. we have a readable value

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      if (!isAuth) {
        return CustomLoginPage.routeLocation;
      }

      final isLoggingIn = state.location == CustomLoginPage.routeLocation;
      if (isLoggingIn) return isAuth ? EntitiesPage.routeLocation : null;

      return isAuth ? null : EntitiesPage.routeLocation;
    },
  );
});
