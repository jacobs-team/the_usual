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
  AppRouter(
    // this._authCubit
  ) {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: Routes.today,
      refreshListenable: getIt<AuthCubit>(),
      redirect: (context, state) {
        final onboardingComplete =
            getIt<OnboardingBloc>().state.step == OnboardingStep.complete;
        if (!onboardingComplete) return Routes.onboarding;

        final status = getIt<AuthCubit>().state.status;
        final atSignIn = state.matchedLocation == Routes.signIn;
        if (status == AuthStatus.unknown && !atSignIn) return Routes.signIn;
        if (status != AuthStatus.unknown && atSignIn) return Routes.today;
        return null;
      },
      routes: routes,
    );
  }

  // final AuthCubit _authCubit;

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
    GoRoute(
      path: Routes.signIn,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SignInView());
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
              path: Routes.history,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: HistoryView());
              },
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) =>
          NavigationWrapper(navigationShell: navigationShell),
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

  /// Destinations for the Today and History bottom navigation bar.
  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.today_outlined),
      selectedIcon: Icon(Icons.today),
      label: 'Today',
    ),
    NavigationDestination(
      icon: Icon(Icons.history_outlined),
      selectedIcon: Icon(Icons.history),
      label: 'History',
    ),
  ];
}
