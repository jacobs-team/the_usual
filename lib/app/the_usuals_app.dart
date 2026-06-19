import 'dart:async';

import 'package:clock/clock.dart';
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
class TheUsualsApp extends StatefulWidget {
  /// {@macro the_usuals_app}
  const TheUsualsApp({super.key});

  @override
  State<TheUsualsApp> createState() => _TheUsualsAppState();
}

class _TheUsualsAppState extends State<TheUsualsApp> {
  /// App-level messenger so the post-onboarding snackbar shows while the user
  /// is routed to Today.
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  StreamSubscription<List<MealPhoto>>? _shareSubscription;

  /// Photos received before onboarding completes; drained when it does.
  List<MealPhoto> _pendingShare = const [];

  @override
  void initState() {
    super.initState();
    _syncNotifications();
    // Tapping a reminder takes the user to Today, where they log meals.
    getIt<NotificationService>().onReminderTapped = () =>
        getIt<AppRouter>().router.go(Routes.today);
    _shareSubscription = getIt<ShareIngestService>().photoStream.listen(
      _handleSharedPhotos,
    );
    // Cold-start photos are fetched once here and NOT re-emitted on photoStream:
    // the service drains and resets its initial-media buffer before the stream
    // listener above is attached, so these two paths are mutually exclusive and
    // a share can never open the sheet twice.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initial = await getIt<ShareIngestService>().takeInitialPhotos();
      if (initial.isNotEmpty) _handleSharedPhotos(initial);
    });
  }

  @override
  void dispose() {
    unawaited(_shareSubscription?.cancel());
    super.dispose();
  }

  void _handleSharedPhotos(List<MealPhoto> photos) {
    if (photos.isEmpty) return;
    final onboardingComplete =
        getIt<OnboardingBloc>().state.step == OnboardingStep.complete;
    if (!onboardingComplete) {
      _pendingShare = [..._pendingShare, ...photos];
      return;
    }
    unawaited(_openShareSheet(photos));
  }

  Future<void> _openShareSheet(List<MealPhoto> photos) async {
    final navigatorContext = AppRouter.rootNavigatorKey.currentContext;
    if (navigatorContext == null) return;
    getIt<AppRouter>().router.go(Routes.today);
    final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
      navigatorContext,
      builder: (context) => FoodEntrySheet(
        title: 'Log from photo',
        confirmLabel: 'Log',
        showMealSelector: true,
        showAddToUsualMeals: true,
        initialPhotos: photos,
        autoEstimate: true,
        initialMealOfTheDay: MealOfTheDay.fromTime(
          TimeOfDay.fromDateTime(clock.now()),
        ),
      ),
    );
    if (result == null) return;
    for (final foodResult in result.foods) {
      if (foodResult.addToUsualMeals) {
        getIt<UserSettingsBloc>().add(
          UserSettingsEvent.usualMealAdded(
            result.mealOfTheDay,
            foodResult.name,
            foodResult.nutrition,
          ),
        );
      }
      getIt<DailyLogBloc>().add(
        DailyLogEvent.mealLogged(
          result.mealOfTheDay,
          foodResult.name,
          nutrition: foodResult.nutrition,
          quantity: foodResult.quantity,
        ),
      );
    }
  }

  /// Reschedules reminders from the current settings, suppressing today's
  /// reminders for meals already logged today and the weigh-in once today's
  /// weight is logged, when the user enabled that. Reads both blocs so it can
  /// run on a settings change or a log change.
  void _syncNotifications() {
    final settings = getIt<UserSettingsBloc>().state;
    final today = clock.now().logicalDay(settings.dayStartTime);
    final dailyLog = getIt<DailyLogBloc>().state;
    final mealsLoggedToday = dailyLog.mealEntries
        .breakdownOn(today, settings.dayStartTime)
        .entriesByMeal
        .keys
        .toSet();
    final weighedInToday =
        dailyLog.weightOn(today, settings.dayStartTime) != null;
    unawaited(
      getIt<NotificationService>().sync(
        reminderStyle: settings.reminderStyle,
        scheduleMode: settings.mealCheckinScheduleMode,
        mealReminders: settings.mealReminders,
        endOfDayReminder: settings.endOfDayReminder,
        weightCheckinFrequency: settings.weightCheckinFrequency,
        weightTimeOfDay: settings.weightTimeOfDay,
        skipLoggedMealReminders: settings.skipLoggedMealReminders,
        mealsLoggedToday: mealsLoggedToday,
        weighedInToday: weighedInToday,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserSettingsBloc, UserSettingsState>(
          bloc: getIt<UserSettingsBloc>(),
          listener: (context, state) => _syncNotifications(),
        ),
        // Logging a meal can suppress today's reminder for that meal timing.
        BlocListener<DailyLogBloc, DailyLogState>(
          bloc: getIt<DailyLogBloc>(),
          listener: (context, state) => _syncNotifications(),
        ),
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
                      nutrition: usualMeal.nutrition,
                      quantity: state.firstLogQuantities[usualMeal.id] ?? 1,
                      usualMealId: usualMeal.id,
                      photoPath: usualMeal.photoPath,
                    ),
                  );
                }
              }
            }
            // Onboarding has no completion screen: drop the user into Today and
            // point out that everything is editable in Settings.
            getIt<AppRouter>().router.go(Routes.today);
            if (_pendingShare.isNotEmpty) {
              final photos = _pendingShare;
              _pendingShare = const [];
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _openShareSheet(photos),
              );
            }
            _scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text(
                  "You're all set. Change your goals or usual meals anytime "
                  'in Settings.',
                ),
              ),
            );
          },
        ),
      ],
      child: BlocSelector<UserSettingsBloc, UserSettingsState, ThemeMode>(
        bloc: getIt<UserSettingsBloc>(),
        selector: (state) => state.themeMode,
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _scaffoldMessengerKey,
            routerConfig: getIt<AppRouter>().router,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Layout(child: child!),
          );
        },
      ),
    );
  }
}
