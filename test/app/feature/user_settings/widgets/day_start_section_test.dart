import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(DayStartSection, () {
    late UserSettingsBloc userSettingsBloc;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      registerFallbackValue(const TimeOfDay(hour: 0, minute: 0));
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows the current day-start time', (tester) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const DayStartSection(),
      );

      expect(find.text('New day starts at'), findsOneWidget);
      expect(find.byType(ActionChip), findsOneWidget);
    });

    testWidgets('dispatches dayStartTimeChanged for a picked time', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const DayStartSection(),
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.dayStartTimeChanged(
            TimeOfDay(hour: 0, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('ignores a cancelled time picker', (tester) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const DayStartSection(),
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(
        () => userSettingsBloc.add(
          const UserSettingsEvent.dayStartTimeChanged(
            TimeOfDay(hour: 0, minute: 0),
          ),
        ),
      );
    });
  });
}
