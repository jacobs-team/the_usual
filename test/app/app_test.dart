import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../helpers/helpers.dart';

void main() {
  group(TheUsualsApp, () {
    late OnboardingBloc onboardingBloc;
    late UserSettingsBloc userSettingsBloc;
    late DailyLogBloc dailyLogBloc;
    late NotificationService notificationService;

    const completeState = OnboardingState(
      activeStepIndex: 7,
      firstLogSelectedIds: ['u'],
      settings: UserSettingsState(
        startingWeight: 165,
        usuals: {
          MealOfTheDay.breakfast: [
            UsualMeal(
              id: 'u',
              name: 'Eggs',
              nutrition: Nutrition(calories: 300),
            ),
          ],
        },
      ),
    );

    setUpAll(() {
      registerFallbackValue(ReminderStyle.notifications);
      registerFallbackValue(MealCheckinScheduleMode.perMeal);
      registerFallbackValue(WeightCheckinFrequency.daily);
      registerFallbackValue(WeightTimeOfDay.morning);
      registerFallbackValue(
        const MealReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 9, minute: 0),
        ),
      );
      registerFallbackValue(<MealOfTheDay, MealReminder>{});
    });

    setUp(() async {
      await GetIt.instance.reset();
      initHydratedStorage();

      onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());

      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());

      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());

      notificationService = MockNotificationService();
      when(
        () => notificationService.sync(
          reminderStyle: any(named: 'reminderStyle'),
          scheduleMode: any(named: 'scheduleMode'),
          mealReminders: any(named: 'mealReminders'),
          endOfDayReminder: any(named: 'endOfDayReminder'),
          weightCheckinFrequency: any(named: 'weightCheckinFrequency'),
          weightTimeOfDay: any(named: 'weightTimeOfDay'),
        ),
      ).thenAnswer((_) async {});

      GetIt.instance
        ..registerSingleton<OnboardingBloc>(onboardingBloc)
        ..registerSingleton<UserSettingsBloc>(userSettingsBloc)
        ..registerSingleton<DailyLogBloc>(dailyLogBloc)
        ..registerSingleton<NotificationService>(notificationService)
        ..registerLazySingleton<AppRouter>(AppRouter.new);
    });

    tearDown(() => GetIt.instance.reset());

    testWidgets('syncs notifications on startup and renders the router', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const TheUsualsApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      verify(
        () => notificationService.sync(
          reminderStyle: any(named: 'reminderStyle'),
          scheduleMode: any(named: 'scheduleMode'),
          mealReminders: any(named: 'mealReminders'),
          endOfDayReminder: any(named: 'endOfDayReminder'),
          weightCheckinFrequency: any(named: 'weightCheckinFrequency'),
          weightTimeOfDay: any(named: 'weightTimeOfDay'),
        ),
      ).called(greaterThanOrEqualTo(1));

      // Tapping a reminder routes to Today.
      final onReminderTapped =
          verify(
                () => notificationService.onReminderTapped = captureAny(),
              ).captured.last
              as void Function();
      onReminderTapped();
      await tester.pumpAndSettle();
    });

    testWidgets('commits onboarding and seeds the log when it completes', (
      tester,
    ) async {
      whenListen(
        onboardingBloc,
        Stream.value(completeState),
        initialState: const OnboardingState(activeStepIndex: 5),
      );
      // Emitting a settings change drives the notification re-sync listener.
      whenListen(
        userSettingsBloc,
        Stream.value(const UserSettingsState(themeMode: ThemeMode.dark)),
        initialState: const UserSettingsState(),
      );

      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const TheUsualsApp());
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          UserSettingsEvent.settingsCommitted(completeState.settings),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.weightLogged(165, WeightUnit.lb),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Eggs',
            nutrition: Nutrition(calories: 300),
            usualMealId: 'u',
          ),
        ),
      ).called(1);
    });
  });
}
