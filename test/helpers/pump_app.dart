import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/l10n/l10n.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpPumpPumpItUP(
    Widget widget, {
    List<Object> deps = const [],
    Locale locale = const Locale('en'),
    GoRouter? router,
  }) async {
    initHydratedStorage();
    final getIt = GetIt.instance;
    await getIt.reset();

    final authCubit = MockAuthCubit();
    when(() => authCubit.state).thenReturn(const AuthState());

    final onboardingBloc = MockOnboardingBloc();
    when(() => onboardingBloc.state).thenReturn(const OnboardingState());
    when(() => onboardingBloc.stream).thenAnswer((_) => const Stream.empty());
    final dailyLogBloc = MockDailyLogBloc();
    when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
    when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
    final workoutLogBloc = MockWorkoutLogBloc();
    when(() => workoutLogBloc.state).thenReturn(const WorkoutLogState());
    when(
      () => workoutLogBloc.stream,
    ).thenAnswer((_) => const Stream.empty());
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
    when(
      () => userSettingsBloc.stream,
    ).thenAnswer((_) => const Stream.empty());

    final mealAiRepository = MockMealAiRepository();
    when(() => mealAiRepository.isConfigured).thenReturn(false);

    getIt
      ..registerSingleton<AuthCubit>(authCubit)
      ..registerSingleton<ConnectivityCubit>(MockConnectivityCubit())
      ..registerSingleton<DevToolsCubit>(MockDevToolsCubit())
      ..registerSingleton<OnboardingBloc>(onboardingBloc)
      ..registerSingleton<DailyLogBloc>(dailyLogBloc)
      ..registerSingleton<WorkoutLogBloc>(workoutLogBloc)
      ..registerSingleton<UserSettingsBloc>(userSettingsBloc)
      ..registerSingleton<NotificationService>(MockNotificationService())
      ..registerSingleton<CoffeeApi>(MockCoffeeApi())
      ..registerSingleton<RestClient>(MockRestClient())
      ..registerSingleton<FileCacheService>(MockFileCacheService())
      ..registerSingleton<MealAiRepository>(mealAiRepository)
      ..registerFactory<FoodEntryBloc>(
        () => FoodEntryBloc(
          getIt<MealAiRepository>(),
          getIt<UserSettingsBloc>(),
        ),
      );

    for (final instance in [...deps]) {
      await _registerOverride(instance);
    }

    // Lazy so the router binds to whichever AuthCubit the test registered.
    getIt.registerLazySingleton<AppRouter>(
      () => AppRouter(getIt<AuthCubit>()),
    );

    if (router != null) {
      await pumpWidget(
        MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          routerConfig: router,
          builder: (context, child) => Layout(child: child!),
        ),
      );
    } else {
      await pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: Layout(child: Scaffold(body: widget)),
        ),
      );
    }

    await pump();
  }

  Future<void> _registerOverride(Object instance) async {
    final getIt = GetIt.instance;

    if (instance is AuthCubit) {
      getIt
        ..unregister<AuthCubit>()
        ..registerSingleton<AuthCubit>(instance);
    } else if (instance is ConnectivityCubit) {
      getIt
        ..unregister<ConnectivityCubit>()
        ..registerSingleton<ConnectivityCubit>(instance);
    } else if (instance is DevToolsCubit) {
      getIt
        ..unregister<DevToolsCubit>()
        ..registerSingleton<DevToolsCubit>(instance);
    } else if (instance is OnboardingBloc) {
      getIt
        ..unregister<OnboardingBloc>()
        ..registerSingleton<OnboardingBloc>(instance);
    } else if (instance is DailyLogBloc) {
      getIt
        ..unregister<DailyLogBloc>()
        ..registerSingleton<DailyLogBloc>(instance);
    } else if (instance is WorkoutLogBloc) {
      getIt
        ..unregister<WorkoutLogBloc>()
        ..registerSingleton<WorkoutLogBloc>(instance);
    } else if (instance is UserSettingsBloc) {
      getIt
        ..unregister<UserSettingsBloc>()
        ..registerSingleton<UserSettingsBloc>(instance);
    } else if (instance is NotificationService) {
      getIt
        ..unregister<NotificationService>()
        ..registerSingleton<NotificationService>(instance);
    } else if (instance is CoffeeApi) {
      getIt
        ..unregister<CoffeeApi>()
        ..registerSingleton<CoffeeApi>(instance);
    } else if (instance is RestClient) {
      getIt
        ..unregister<RestClient>()
        ..registerSingleton<RestClient>(instance);
    } else if (instance is FileCacheService) {
      getIt
        ..unregister<FileCacheService>()
        ..registerSingleton<FileCacheService>(instance);
    } else if (instance is MealAiRepository) {
      getIt
        ..unregister<MealAiRepository>()
        ..registerSingleton<MealAiRepository>(instance);
    }
  }
}
