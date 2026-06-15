import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(TodayView, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    void stubDailyLog(DailyLogState state) {
      when(() => dailyLogBloc.state).thenReturn(state);
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
    }

    void stubSettings(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      userSettingsBloc = MockUserSettingsBloc();
      registerFallbackValue(
        DailyLogEvent.weightOnDayChanged(DateTime(2020), 0, WeightUnit.lb),
      );
    });

    GoRouter buildRouter() {
      return GoRouter(
        initialLocation: Routes.today,
        routes: [
          GoRoute(
            path: Routes.today,
            builder: (_, _) => const TodayView(),
          ),
          GoRoute(
            path: Routes.history,
            builder: (_, _) => const Text('history-page'),
          ),
          GoRoute(
            path: Routes.settings,
            builder: (_, _) => const Text('settings-page'),
          ),
          GoRoute(
            path: Routes.devTools,
            builder: (_, _) => const Text('devtools-page'),
          ),
        ],
      );
    }

    Future<void> pumpView(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        const SizedBox.shrink(),
        router: buildRouter(),
      );
    }

    testWidgets('renders the day total and a section per meal', (
      tester,
    ) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      expect(find.text('Today'), findsOneWidget);
      expect(find.byType(MealLogSection), findsNWidgets(4));
    });

    testWidgets('prefills the weight field from today and latest weigh-ins', (
      tester,
    ) async {
      stubDailyLog(
        DailyLogState(
          weightEntries: [
            WeightEntry(
              id: 'today',
              loggedAt: DateTime.now(),
              weight: 165,
              weightUnit: WeightUnit.lb,
            ),
          ],
        ),
      );
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      final field = tester.widget<TextFormField>(
        find.descendant(
          of: find.byType(TheUsualTextField),
          matching: find.byType(TextFormField),
        ),
      );
      expect(field.initialValue, equals('165'));
    });

    testWidgets('reports a weight change through the bloc', (tester) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      await tester.enterText(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(TextFormField),
        ),
        '170',
      );

      verify(
        () => dailyLogBloc.add(
          any(
            that: isA<WeightOnDayChanged>()
                .having((event) => event.weight, 'weight', 170)
                .having((event) => event.weightUnit, 'unit', WeightUnit.lb),
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to history, settings, and dev tools', (
      tester,
    ) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      expect(find.text('history-page'), findsOneWidget);
    });

    testWidgets('navigates to settings from the gear icon', (tester) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.text('settings-page'), findsOneWidget);
    });

    testWidgets('navigates to dev tools from the code icon', (tester) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      await tester.tap(find.byIcon(Icons.code));
      await tester.pumpAndSettle();
      expect(find.text('devtools-page'), findsOneWidget);
    });
  });
}
