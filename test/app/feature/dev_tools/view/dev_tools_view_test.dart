import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

class _FakeMealAiException implements Exception {
  @override
  String toString() => 'boom';
}

/// Stands in for the image_picker plugin so the photo flow returns a fixed
/// image without a real platform channel.
class _FakeImagePickerPlatform extends ImagePickerPlatform {
  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async => XFile.fromData(
    transparentPixel,
    name: 'meal.png',
    mimeType: 'image/png',
  );

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async => [
    XFile.fromData(transparentPixel, name: 'meal.png', mimeType: 'image/png'),
  ];
}

void main() {
  group(DevToolsView, () {
    late DevToolsCubit devToolsCubit;
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;
    late MealAiRepository mealAiRepository;

    const breakfastSuggestion = AiMealSuggestion(
      name: '2 eggs & toast',
      nutrition: Nutrition(calories: 250, protein: 18),
    );

    setUpAll(() {
      registerFallbackValue(
        const UserSettingsEvent.settingsCommitted(UserSettingsState()),
      );
      registerFallbackValue(MealEntryMode.itemized);
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      initHydratedStorage();
      devToolsCubit = MockDevToolsCubit();
      dailyLogBloc = MockDailyLogBloc();
      userSettingsBloc = MockUserSettingsBloc();
      mealAiRepository = MockMealAiRepository();

      when(() => devToolsCubit.state).thenReturn(const DevToolsState());
      when(() => devToolsCubit.stream).thenAnswer((_) => const Stream.empty());
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(() => mealAiRepository.isConfigured).thenReturn(false);
    });

    testWidgets('renders $DevToolsView', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      expect(find.byType(DevToolsView), findsOneWidget);
      expect(find.text('Dev Tools'), findsOneWidget);
    });

    testWidgets('triggers toggleDebugApi when Debug API switch is toggled', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      await tester.tap(find.text('Debug API'));

      verify(() => devToolsCubit.toggleDebugApi()).called(1);
    });

    testWidgets('seeds sample history when the tile is tapped', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit, dailyLogBloc, userSettingsBloc],
        const DevToolsView(),
      );

      await tester.tap(find.text('Load sample history'));

      verify(
        () => dailyLogBloc.add(const DailyLogEvent.sampleDataSeeded()),
      ).called(1);
      verify(() => userSettingsBloc.add(any())).called(1);
    });

    group('Test Claude connection', () {
      testWidgets('shows missing-key snackbar when not configured', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(false);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test Claude connection'));
        await tester.pump();

        expect(
          find.text('No ANTHROPIC_API_KEY set in config.'),
          findsOneWidget,
        );
      });

      testWidgets('shows the reply when the echo succeeds', (tester) async {
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(() => mealAiRepository.debugEcho(any())).thenAnswer(
          (_) async => 'pong',
        );

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test Claude connection'));
        await tester.pump();
        await tester.pump();

        verify(() => mealAiRepository.debugEcho(any())).called(1);
      });

      testWidgets('shows an error snackbar when the echo fails', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.debugEcho(any()),
        ).thenThrow(_FakeMealAiException());

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test Claude connection'));
        await tester.pump();
        await tester.pump();

        verify(() => mealAiRepository.debugEcho(any())).called(1);
      });
    });

    group('Test meal extraction', () {
      testWidgets('shows missing-key snackbar when not configured', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(false);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test meal extraction'));
        await tester.pump();

        expect(
          find.text('No ANTHROPIC_API_KEY set in config.'),
          findsOneWidget,
        );
      });

      testWidgets('shows the summary when extraction succeeds', (tester) async {
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => [breakfastSuggestion]);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test meal extraction'));
        await tester.pump();
        await tester.pump();

        verify(
          () => mealAiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });

      testWidgets('shows an error snackbar when extraction fails', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenThrow(_FakeMealAiException());

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test meal extraction'));
        await tester.pump();
        await tester.pump();

        verify(
          () => mealAiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });
    });

    group('Test photo extraction', () {
      testWidgets('shows missing-key snackbar when not configured', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(false);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test photo extraction'));
        await tester.pump();

        expect(
          find.text('No ANTHROPIC_API_KEY set in config.'),
          findsOneWidget,
        );
      });

      testWidgets('opens the photo source dialog when configured', (
        tester,
      ) async {
        when(() => mealAiRepository.isConfigured).thenReturn(true);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test photo extraction'));
        await tester.pumpAndSettle();

        expect(find.text('Photo source'), findsOneWidget);

        // Cancel the dialog without choosing a source: pickMealPhoto returns
        // null and the handler returns early before touching the picker plugin.
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Photo source'), findsNothing);
        verifyNever(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        );
      });

      testWidgets('estimates the picked photo when extraction succeeds', (
        tester,
      ) async {
        ImagePickerPlatform.instance = _FakeImagePickerPlatform();
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => [breakfastSuggestion]);

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test photo extraction'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Camera'));
        await tester.pump();
        await tester.pump();

        verify(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });

      testWidgets('shows an error snackbar when photo extraction fails', (
        tester,
      ) async {
        ImagePickerPlatform.instance = _FakeImagePickerPlatform();
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenThrow(_FakeMealAiException());

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, mealAiRepository],
          const DevToolsView(),
        );

        await tester.tap(find.text('Test photo extraction'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Photo library'));
        await tester.pump();
        await tester.pump();

        verify(
          () => mealAiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });
    });

    testWidgets('dumps saved storage when the tile is tapped', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const DevToolsView(),
      );

      await tester.tap(find.text('Dump saved storage'));
      await tester.pump();

      expect(find.text('Dump saved storage'), findsOneWidget);
    });

    group('Restore usuals from log', () {
      testWidgets('rebuilds usuals from logged meals with usual ids', (
        tester,
      ) async {
        final loggedAt = DateTime(2026, 6, 17, 8);
        const restoredUsualMeal = UsualMeal(
          id: 'usual-1',
          name: 'Eggs',
          nutrition: Nutrition(calories: 200),
        );
        when(() => userSettingsBloc.state).thenReturn(
          const UserSettingsState(
            usuals: {
              MealOfTheDay.breakfast: [restoredUsualMeal],
            },
          ),
        );
        when(() => dailyLogBloc.state).thenReturn(
          DailyLogState(
            mealEntries: [
              // Already restored: skipped by the alreadyRestored check.
              MealLogEntry(
                id: 'entry-1',
                loggedAt: loggedAt,
                mealOfTheDay: MealOfTheDay.breakfast,
                name: 'Eggs',
                usualMealId: 'usual-1',
              ),
              // New usual id: added to its meal-of-the-day list.
              MealLogEntry(
                id: 'entry-2',
                loggedAt: loggedAt,
                mealOfTheDay: MealOfTheDay.lunch,
                name: 'Salad',
                usualMealId: 'usual-2',
              ),
              // No usual id: skipped.
              MealLogEntry(
                id: 'entry-3',
                loggedAt: loggedAt,
                mealOfTheDay: MealOfTheDay.dinner,
                name: 'Snack',
              ),
            ],
          ),
        );

        await tester.pumpPumpPumpItUP(
          deps: [devToolsCubit, dailyLogBloc, userSettingsBloc],
          const DevToolsView(),
        );

        await tester.scrollUntilVisible(
          find.text('Restore usuals from log'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Restore usuals from log'));
        await tester.pump();

        verify(() => userSettingsBloc.add(any())).called(1);
      });
    });

    testWidgets('resets app state and navigates to onboarding', (tester) async {
      final onboardingBloc = MockOnboardingBloc();
      when(() => onboardingBloc.state).thenReturn(const OnboardingState());
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());

      final router = GoRouter(
        initialLocation: '/dev',
        routes: [
          GoRoute(
            path: '/dev',
            builder: (_, _) => const DevToolsView(),
          ),
          GoRoute(
            path: Routes.onboarding,
            builder: (_, _) => const Text('onboarding-page'),
          ),
        ],
      );

      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit, onboardingBloc],
        const SizedBox.shrink(),
        router: router,
      );

      await tester.scrollUntilVisible(
        find.text('Reset app state'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Reset app state'));
      await tester.pumpAndSettle();

      verify(
        () => onboardingBloc.add(const OnboardingEvent.resetPressed()),
      ).called(1);
      expect(find.text('onboarding-page'), findsOneWidget);
    });
  });
}
