// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

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
      navigatorKey: rootNavigatorKey,
      initialLocation: Routes.today,
      refreshListenable: _authCubit,
      redirect: (context, state) {
        final onboardingComplete =
            getIt<OnboardingBloc>().state.step == OnboardingStep.complete;
        if (!onboardingComplete) return Routes.onboarding;
        // Onboarding is the only gate: signing in or staying offline is chosen
        // on its first screen. Once complete, never sit on that route.
        if (state.matchedLocation == Routes.onboarding) return Routes.today;
        return null;
      },
      routes: routes,
    );
  }

  final AuthCubit _authCubit;

  /// The [GoRouter] instance used by the application.
  late final GoRouter router;

  /// Navigator key for the root navigator, used to present overlays (e.g. the
  /// share-to-log sheet) without a widget context.
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// The list of top-level and nested Routes.
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: OnboardingView());
      },
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.today,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: TodayView());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.workouts,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: WorkoutsView());
              },
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) =>
          NavigationWrapper(navigationShell: navigationShell),
    ),
    GoRoute(
      path: Routes.history,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: HistoryView());
      },
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: UserSettingsView());
      },
      routes: [
        GoRoute(
          path: Routes.usualMealsSegment,
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: UsualMealsView());
          },
        ),
      ],
    ),
    if (kDebugMode)
      GoRoute(
        path: Routes.devTools,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: DevToolsView());
        },
      ),
  ];

  /// Destinations for the Meals and Workouts bottom navigation bar.
  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.restaurant_outlined),
      selectedIcon: Icon(Icons.restaurant),
      label: 'Meals',
    ),
    NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined),
      selectedIcon: Icon(Icons.fitness_center),
      label: 'Workouts',
    ),
  ];
}
