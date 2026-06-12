// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template app_router}
/// Central navigation configuration using [GoRouter].
///
/// Defines the application's routing structure, including [StatefulShellRoute]
/// for bottom and rail navigation, route guards via redirect, and UI
/// destinations.
/// {@endtemplate}
@singleton
class AppRouter {
  /// {@macro app_router}
  AppRouter(
    // this._authCubit
  ) {
    router = GoRouter(
      initialLocation: Routes.onboarding,
      // refreshListenable: _authCubit,
      redirect: (context, state) {
        // final signedIn = _authCubit.state.signedIn;
        // final isSigningIn = state.uri.path.startsWith(Routes.signIn);
        // final isOnboarding = state.uri.path.startsWith(Routes.onboarding);

        // if (isOnboarding) {
        //   return null;
        // }

        // if (!signedIn && !isSigningIn) {
        //   return Routes.signIn;
        // }

        // If signedIn and trying to access signIn -> Force onboarding.
        // if (signedIn && isSigningIn) {
        //   return Routes.onboarding;
        // }

        return null;
      },
      routes: routes,
    );
  }

  // final AuthCubit _authCubit;

  /// The [GoRouter] instance used by the application.
  late final GoRouter router;

  /// The list of top-level and nested Routes.
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: OnboardingView());
      },
    ),
    // GoRoute(
    //   path: Routes.signIn,
    //   pageBuilder: (context, state) {
    //     return const NoTransitionPage(child: SignInView());
    //   },
    // ),
    if (kDebugMode)
      GoRoute(
        path: Routes.devTools,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: DevToolsView());
        },
      ),
  ];

  /// Data for rendering navigation bars or rails.
  static List<NavigationDestination> destinations(AppLocalizations l10n) => [
    NavigationDestination(
      icon: const Icon(Icons.coffee_outlined),
      selectedIcon: const Icon(Icons.coffee),
      label: l10n.coffeeTitle,
    ),
    NavigationDestination(
      icon: const Icon(Icons.favorite_outline),
      selectedIcon: const Icon(Icons.favorite),
      label: l10n.favoritesTitle,
    ),
  ];
}
