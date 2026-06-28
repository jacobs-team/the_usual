import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(GoalsSection, () {
    late UserSettingsBloc userSettingsBloc;
    late StreamController<UserSettingsState> stateController;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => stateController.stream);
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      stateController = StreamController<UserSettingsState>.broadcast();
    });

    tearDown(() => stateController.close());

    testWidgets('seeds the fields from the stored goals', (tester) async {
      stub(
        UserSettingsState(
          calorieGoalHistory: [
            CalorieGoalEntry(
              effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
              calories: 2000,
            ),
          ],
          weightGoalHistory: [
            WeightGoalEntry(
              effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
              weightUnit: WeightUnit.lb,
              weight: 70,
            ),
          ],
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      final calorieField = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(MacroField),
          matching: find.byType(EditableText),
        ),
      );
      expect(calorieField.controller.text, equals('2000'));

      final weightField = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(WeightInput),
          matching: find.byType(EditableText),
        ),
      );
      expect(weightField.controller.text, equals('70.0'));
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

      // Unit chips render in WeightUnit.values order inside the weight field.
      final kgChip = find
          .descendant(
            of: find.byType(WeightInput),
            matching: find.byType(ChoiceChip),
          )
          .at(WeightUnit.values.indexOf(WeightUnit.kg));
      await tester.tap(kgChip);

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.weightUnitSelected(WeightUnit.kg),
        ),
      ).called(1);
    });

    testWidgets('re-seeds the fields when the goals change underneath it', (
      tester,
    ) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      final updated = UserSettingsState(
        calorieGoalHistory: [
          CalorieGoalEntry(
            effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
            calories: 2500,
          ),
        ],
        weightGoalHistory: [
          WeightGoalEntry(
            effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
            weightUnit: WeightUnit.lb,
            weight: 88,
          ),
        ],
      );
      when(() => userSettingsBloc.state).thenReturn(updated);
      stateController.add(updated);
      await tester.pump();

      final calorieField = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(MacroField),
          matching: find.byType(EditableText),
        ),
      );
      expect(calorieField.controller.text, equals('2500'));

      final weightField = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(WeightInput),
          matching: find.byType(EditableText),
        ),
      );
      expect(weightField.controller.text, equals('88.0'));
    });

    testWidgets('re-seeds only the weight field when just the goal weight '
        'changes', (tester) async {
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const GoalsSection(),
      );

      // Calorie goal stays unset while the weight goal changes, so the listener
      // fires on the weight-goal arm of its condition.
      final updated = UserSettingsState(
        weightGoalHistory: [
          WeightGoalEntry(
            effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
            weightUnit: WeightUnit.lb,
            weight: 99,
          ),
        ],
      );
      when(() => userSettingsBloc.state).thenReturn(updated);
      stateController.add(updated);
      await tester.pump();

      final weightField = tester.widget<EditableText>(
        find.descendant(
          of: find.byType(WeightInput),
          matching: find.byType(EditableText),
        ),
      );
      expect(weightField.controller.text, equals('99.0'));
    });
  });
}
