import 'dart:async';
import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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

class _TheUsualsAppState extends State<TheUsualsApp>
    with WidgetsBindingObserver {
  /// App-level messenger so the post-onboarding snackbar shows while the user
  /// is routed to Today.
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  StreamSubscription<List<MealPhoto>>? _shareSubscription;

  /// Photos received before onboarding completes; drained when it does.
  List<MealPhoto> _pendingShare = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Restore a previous Google session silently before first paint.
    unawaited(getIt<AuthCubit>().restoreOnStartup());
    // Hold the native splash until the session is resolved and synced, so the
    // first frame is the right screen. The timeout is a safety net so a stalled
    // auth stream can never leave the splash up indefinitely.
    unawaited(
      getIt<AuthCubit>().ready
          .timeout(const Duration(seconds: 5), onTimeout: () {})
          .whenComplete(FlutterNativeSplash.remove),
    );
    _syncNotifications();
    _syncWidget();
    // Tapping a reminder takes the user to Today, where they log meals.
    if (getIt.isRegistered<NotificationService>()) {
      getIt<NotificationService>().onReminderTapped = () =>
          getIt<AppRouter>().router.go(Routes.today);
    }
    // The OS share target is mobile-only, so the service isn't registered on
    // web.
    if (getIt.isRegistered<ShareIngestService>()) {
      _shareSubscription = getIt<ShareIngestService>().photoStream.listen(
        _handleSharedPhotos,
      );
      // Cold-start photos are fetched once here and NOT re-emitted on
      // photoStream — the service drains and resets its initial-media buffer
      // before the stream listener above is attached, so these two paths are
      // mutually exclusive and a share can never open the sheet twice.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final initial = await getIt<ShareIngestService>().takeInitialPhotos();
        if (initial.isNotEmpty) _handleSharedPhotos(initial);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_shareSubscription?.cancel());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Sync all pending tasks before backgrounding.
    if (state == AppLifecycleState.paused) {
      getIt<SyncRepository>().flushPending();
    }
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
        initialMealOfTheDay: getIt<UserSettingsBloc>().state.currentMeal(
          clock.now(),
        ),
      ),
    );
    if (result == null) return;
    for (final foodResult in result.foods) {
      final usualMealId = foodResult.addToUsualMeals
          ? getIt<UserSettingsBloc>().saveAsUsualMeal(
              result.mealOfTheDay,
              foodResult.name,
              foodResult.nutrition,
            )
          : null;
      getIt<DailyLogBloc>().add(
        DailyLogEvent.mealLogged(
          result.mealOfTheDay,
          foodResult.name,
          nutrition: foodResult.nutrition,
          quantity: foodResult.quantity,
          usualMealId: usualMealId,
        ),
      );
    }
  }

  /// Reschedules reminders from the current settings, suppressing today's
  /// reminders for meals already logged today and the weigh-in once today's
  /// weight is logged, when the user enabled that. Reads both blocs so it can
  /// run on a settings change or a log change.
  void _syncNotifications() {
    // Scheduled OS notifications are a mobile-only dependency, so the service
    // isn't registered on web. Nothing to sync there.
    if (!getIt.isRegistered<NotificationService>()) return;
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
        workoutReminder: settings.workoutReminder,
      ),
    );
  }

  /// Pushes today's calorie goal and consumed total into the lock-screen widget
  /// so it can show calories remaining. Reads both blocs so it can run on a
  /// settings change or a log change.
  void _syncWidget() {
    // The home-screen widget is a mobile-only dependency, so it isn't
    // registered on web. Nothing to sync there.
    if (!getIt.isRegistered<WidgetService>()) return;
    final settings = getIt<UserSettingsBloc>().state;
    final dayStart = settings.dayStartTime;
    final today = clock.now().logicalDay(dayStart);
    final nutrition = getIt<DailyLogBloc>().state.mealEntries
        .breakdownOn(today, dayStart)
        .nutrition;
    final dayRollover = DateUtils.addDaysToDate(today, 1).atDayStart(dayStart);
    unawaited(
      getIt<WidgetService>().updateCalories(
        goal: settings.calorieGoalHistory.goalOn(today),
        consumed: nutrition.calories ?? 0,
        protein: nutrition.protein ?? 0,
        carbs: nutrition.carbs ?? 0,
        fat: nutrition.fat ?? 0,
        dayRollover: dayRollover,
      ),
    );
  }

  /// Turns a sign-in [prompt] into a dialog, then routes the user's choice back
  /// to the cubit. Shown over the root navigator so it covers the sign-in
  /// screen or Settings, wherever the sign-in was triggered.
  Future<void> _showSignInPrompt(SignInPrompt prompt) async {
    final navigatorContext = AppRouter.rootNavigatorKey.currentContext;
    if (navigatorContext == null) return;
    final authCubit = getIt<AuthCubit>();
    switch (prompt) {
      case SignInPrompt.keepOrStartFresh:
        final keep = await showDialog<bool>(
          context: navigatorContext,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Bring your data to this account?'),
            content: const Text(
              'You can keep the meals and usuals you logged as a guest, or '
              'start fresh. Starting fresh permanently deletes the guest data '
              'on this device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Start fresh'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Keep my data'),
              ),
            ],
          ),
        );
        if (keep == null) return;
        try {
          await (keep ? authCubit.keepGuestData() : authCubit.startFresh());
        } on Object catch (error, stackTrace) {
          _showSignInError(error, stackTrace);
        }
      case SignInPrompt.replaceLocalWithCloud:
        final replace = await showDialog<bool>(
          context: navigatorContext,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Replace this device's data?"),
            content: const Text(
              'This account already has data saved in the cloud. Signing in '
              'downloads it and permanently replaces the guest data on this '
              'device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Replace'),
              ),
            ],
          ),
        );
        if (replace ?? false) {
          try {
            await authCubit.confirmReplaceWithCloud();
          } on Object catch (error, stackTrace) {
            _showSignInError(error, stackTrace);
          }
        } else {
          try {
            await authCubit.cancelSignIn();
          } on Object catch (error, stackTrace) {
            // Best-effort backout; the cubit resets its in-flight state in its
            // finally even when sign-out fails, so just log it.
            log(
              'Sign-in cancel failed',
              name: 'TheUsualsApp',
              error: error,
              stackTrace: stackTrace,
            );
          }
        }
    }
  }

  /// Logs a sign-in data-migration failure and tells the user it could not be
  /// completed. Used when a guest-data dialog choice fails after the credential
  /// is already obtained.
  void _showSignInError(Object error, StackTrace stackTrace) {
    log(
      'Sign-in could not be completed',
      name: 'TheUsualsApp',
      error: error,
      stackTrace: stackTrace,
    );
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context == null) return;
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(context.l10n.signInFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserSettingsBloc, UserSettingsState>(
          bloc: getIt<UserSettingsBloc>(),
          listener: (context, state) {
            _syncNotifications();
            _syncWidget();
          },
        ),
        // Logging a meal can suppress today's reminder for that meal timing,
        // and changes the calories remaining shown in the widget.
        BlocListener<DailyLogBloc, DailyLogState>(
          bloc: getIt<DailyLogBloc>(),
          listener: (context, state) {
            _syncNotifications();
            _syncWidget();
          },
        ),
        // A sign-in that needs a guest-data decision raises a prompt; turn it
        // into a dialog over whichever screen triggered the sign-in.
        BlocListener<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listenWhen: (previous, current) =>
              previous.pendingPrompt != current.pendingPrompt &&
              current.pendingPrompt != null,
          listener: (context, state) => _showSignInPrompt(state.pendingPrompt!),
        ),
        // A sync operation that emptied the device resets onboarding; route the
        // user back through it.
        BlocListener<OnboardingBloc, OnboardingState>(
          bloc: getIt<OnboardingBloc>(),
          listenWhen: (previous, current) =>
              previous.step == OnboardingStep.complete &&
              current.step != OnboardingStep.complete,
          listener: (context, state) =>
              getIt<AppRouter>().router.go(Routes.onboarding),
        ),
        BlocListener<OnboardingBloc, OnboardingState>(
          bloc: getIt<OnboardingBloc>(),
          listenWhen: (previous, current) =>
              previous.step != OnboardingStep.complete &&
              current.step == OnboardingStep.complete,
          listener: (context, state) {
            // A returning signed-in user resuming on a fresh install: cloud
            // data is already applied, so land them in the app without
            // committing the empty draft over it.
            if (state.completedSilently) {
              getIt<AppRouter>().router.go(Routes.today);
              return;
            }
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
