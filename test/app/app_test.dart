import 'dart:async';

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
    late ShareIngestService shareIngestService;
    late MockMealAiRepository mealAiRepository;

    const completeState = OnboardingState(
      step: OnboardingStep.complete,
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
      registerFallbackValue(MealEntryMode.wholeMeal);
      registerFallbackValue(<MealPhoto>[]);
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
          skipLoggedMealReminders: any(named: 'skipLoggedMealReminders'),
          mealsLoggedToday: any(named: 'mealsLoggedToday'),
          weighedInToday: any(named: 'weighedInToday'),
        ),
      ).thenAnswer((_) async {});

      shareIngestService = MockShareIngestService();
      when(
        () => shareIngestService.photoStream,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => shareIngestService.takeInitialPhotos(),
      ).thenAnswer((_) async => const <MealPhoto>[]);

      mealAiRepository = MockMealAiRepository();
      when(() => mealAiRepository.isConfigured).thenReturn(false);

      GetIt.instance
        ..registerSingleton<OnboardingBloc>(onboardingBloc)
        ..registerSingleton<UserSettingsBloc>(userSettingsBloc)
        ..registerSingleton<DailyLogBloc>(dailyLogBloc)
        ..registerSingleton<NotificationService>(notificationService)
        ..registerSingleton<ShareIngestService>(shareIngestService)
        ..registerSingleton<MealAiRepository>(mealAiRepository)
        ..registerFactory<FoodEntryBloc>(
          () => FoodEntryBloc(
            GetIt.instance<MealAiRepository>(),
            GetIt.instance<UserSettingsBloc>(),
          ),
        )
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

      // Built with a runtime key so the constructor runs rather than folding
      // to a compile-time const.
      await tester.pumpWidget(TheUsualsApp(key: UniqueKey()));
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

    testWidgets('re-syncs notifications when the daily log changes', (
      tester,
    ) async {
      whenListen(
        dailyLogBloc,
        Stream.value(
          DailyLogState(
            mealEntries: [
              MealLogEntry(
                id: 'm1',
                loggedAt: testNow,
                mealOfTheDay: MealOfTheDay.breakfast,
                name: 'Eggs',
                nutrition: const Nutrition(calories: 300),
              ),
            ],
          ),
        ),
        initialState: const DailyLogState(),
      );

      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const TheUsualsApp());
      await tester.pumpAndSettle();

      // The daily-log change drives the re-sync listener.
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
    });

    testWidgets('commits onboarding and seeds the log when it completes', (
      tester,
    ) async {
      whenListen(
        onboardingBloc,
        Stream.value(completeState),
        initialState: const OnboardingState(step: OnboardingStep.goals),
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

    group('share flow', () {
      final sharedPhoto = MealPhoto(bytes: transparentPixel);

      setUp(() {
        // Stub AI so the auto-estimate triggered by the share sheet resolves.
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
            description: any(named: 'description'),
          ),
        ).thenAnswer(
          (_) async => const [
            AiMealSuggestion(
              name: 'Shared meal',
              nutrition: Nutrition(calories: 500),
            ),
          ],
        );
      });

      testWidgets(
        'a share while onboarding is complete opens the entry sheet',
        (tester) async {
          // Onboarding is complete so shares open the sheet immediately.
          when(
            () => onboardingBloc.state,
          ).thenReturn(
            const OnboardingState(step: OnboardingStep.complete),
          );

          final shareController = StreamController<List<MealPhoto>>();
          addTearDown(shareController.close);
          when(
            () => shareIngestService.photoStream,
          ).thenAnswer((_) => shareController.stream);

          tester.view.physicalSize = const Size(1200, 3000);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(TheUsualsApp(key: UniqueKey()));
          await tester.pumpAndSettle();

          // Emit a share while the app is already running.
          shareController.add([sharedPhoto]);
          await tester.pumpAndSettle();

          expect(find.byType(FoodEntrySheet), findsOneWidget);
        },
      );

      testWidgets(
        'a share while onboarding is incomplete is buffered and opens after onboarding completes',
        (tester) async {
          // Onboarding is not yet complete; shares must be buffered.
          when(
            () => onboardingBloc.state,
          ).thenReturn(const OnboardingState());

          final shareController = StreamController<List<MealPhoto>>.broadcast();
          addTearDown(shareController.close);
          when(
            () => shareIngestService.photoStream,
          ).thenAnswer((_) => shareController.stream);

          // Broadcast so multiple listeners (MultiBlocListener + GoRouter) can
          // each subscribe without throwing "Stream has already been listened to".
          final onboardingController =
              StreamController<OnboardingState>.broadcast();
          addTearDown(onboardingController.close);
          when(
            () => onboardingBloc.stream,
          ).thenAnswer((_) => onboardingController.stream);

          tester.view.physicalSize = const Size(1200, 3000);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(TheUsualsApp(key: UniqueKey()));
          await tester.pumpAndSettle();

          // A share arrives before onboarding completes; sheet must not open yet.
          shareController.add([sharedPhoto]);
          await tester.pumpAndSettle();

          expect(find.byType(FoodEntrySheet), findsNothing);

          // Onboarding completes; the buffered share should now open the sheet.
          when(
            () => onboardingBloc.state,
          ).thenReturn(
            const OnboardingState(step: OnboardingStep.complete),
          );
          onboardingController.add(
            const OnboardingState(step: OnboardingStep.complete),
          );
          await tester.pumpAndSettle();

          expect(find.byType(FoodEntrySheet), findsOneWidget);
        },
      );
    });
  });
}
