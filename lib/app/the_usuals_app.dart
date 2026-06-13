import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template the_usuals_app}
/// The root widget of the application.
///
/// This widget configures the [MaterialApp] with:
/// * Routing via [AppRouter].
/// * Theming via [AppTheme].
/// * Localization via [AppLocalizations].
/// * Responsive layout support via the [Layout] widget.
/// {@endtemplate}
class TheUsualsApp extends StatelessWidget {
  /// {@macro the_usuals_app}
  const TheUsualsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // BlocListener<AuthCubit, AuthState>(
        //   bloc: getIt<AuthCubit>(),
        //   listenWhen: (previous, current) =>
        //       previous.signedIn && !current.signedIn,
        //   listener: (context, state) =>
        //       getIt<CoffeeBloc>().add(const ClearFeed()),
        // ),
        BlocListener<OnboardingBloc, OnboardingState>(
          bloc: getIt<OnboardingBloc>(),
          listenWhen: (previous, current) =>
              previous.step != OnboardingStep.complete &&
              current.step == OnboardingStep.complete,
          listener: (context, state) {
            final settings = state.settings;
            getIt<UserSettingsBloc>().add(
              UserSettingsEvent.settingsCommitted(settings),
            );
            final startingWeight = settings.startingWeight;
            if (startingWeight != null) {
              getIt<DailyLogBloc>().add(
                DailyLogEvent.weightLogged(startingWeight, settings.weightUnit),
              );
            }
            for (final MapEntry(key: mealOfTheDay, value: usualMeals)
                in settings.usuals.entries) {
              for (final usualMeal in usualMeals) {
                if (state.firstLogSelectedIds.contains(usualMeal.id)) {
                  getIt<DailyLogBloc>().add(
                    DailyLogEvent.mealLogged(
                      mealOfTheDay,
                      usualMeal.name,
                      calories: usualMeal.calories,
                      usualMealId: usualMeal.id,
                      photoPath: usualMeal.photoPath,
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
      child: BlocSelector<DevToolsCubit, DevToolsState, bool>(
        bloc: getIt<DevToolsCubit>(),
        selector: (state) => state.isDarkMode,
        builder: (context, isDarkMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: getIt<AppRouter>().router,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: !kDebugMode
                ? ThemeMode.system
                : isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Layout(child: child!),
          );
        },
      ),
    );
  }
}
