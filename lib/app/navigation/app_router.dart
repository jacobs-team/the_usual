// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/cubit/auth_cubit.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_template/app/navigation/navigation_wrapper.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

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
  AppRouter(this._authCubit) {
    router = GoRouter(
      initialLocation: Routes.coffee,
      refreshListenable: _authCubit,
      redirect: (context, state) {
        final signedIn = _authCubit.state.signedIn;
        final isSigningIn = state.uri.path.startsWith(Routes.signIn);

        // If not signedIn and trying to access a protected route - Force
        // signIn.
        if (!signedIn && !isSigningIn) {
          return Routes.signIn;
        }

        // If signedIn and trying to access signIn -> Force coffee.
        if (signedIn && isSigningIn) {
          return Routes.coffee;
        }

        return null;
      },
      routes: routes,
    );
  }

  final AuthCubit _authCubit;

  /// The [GoRouter] instance used by the application.
  late final GoRouter router;

  /// The list of top-level and nested Routes.
  static final List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.coffee,
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: CoffeeView(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.favorites,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: FavoritesView());
              },
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) =>
          NavigationWrapper(navigationShell: navigationShell),
    ),
    GoRoute(
      path: Routes.signIn,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SignInView());
      },
    ),
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
