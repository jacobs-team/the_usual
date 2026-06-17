import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(GoalsSection, () {
    late UserSettingsBloc userSettingsBloc;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
    });

    testWidgets('seeds the fields from the stored goals', (tester) async {
      stub(const UserSettingsState(calorieGoal: 2000, weightGoal: 70));
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      expect(find.text('2000'), findsOneWidget);
      expect(find.text('70.0'), findsOneWidget);
    });

    testWidgets('dispatches calorieGoalChanged on calorie field change', (
      tester,
    ) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      final calorieField = find.descendant(
        of: find.byType(MacroField),
        matching: find.byType(EditableText),
      );
      await tester.enterText(calorieField, '1800');

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.calorieGoalChanged(1800),
        ),
      ).called(1);
    });

    testWidgets('dispatches weightGoalChanged when the weight field changes', (
      tester,
    ) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      final weightField = find.descendant(
        of: find.byType(WeightInput),
        matching: find.byType(EditableText),
      );
      await tester.enterText(weightField, '65.5');

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightGoalChanged(65.5),
        ),
      ).called(1);
    });

    testWidgets('dispatches weightUnitSelected when the unit chip is tapped', (
      tester,
    ) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      await tester.tap(find.widgetWithText(ChoiceChip, WeightUnit.kg.name));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightUnitSelected(WeightUnit.kg),
        ),
      ).called(1);
    });
  });
}
