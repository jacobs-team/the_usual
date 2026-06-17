import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UsualMealList, () {
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

    testWidgets('renders a section with the meal usuals', (tester) async {
      stub(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const UsualMealList(mealOfTheDay: MealOfTheDay.breakfast),
      );

      expect(find.byType(UsualMealSection), findsOneWidget);
      expect(find.text('Eggs'), findsOneWidget);
    });

    testWidgets('adds, edits, and removes usual meals through the bloc', (
      tester,
    ) async {
      stub(
        const UserSettingsState(
          expandNutritionByDefault: true,
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const UsualMealList(mealOfTheDay: MealOfTheDay.breakfast),
      );

      final rowCalories = find
          .descendant(
            of: find.byType(ExpandableNutrition),
            matching: find.byType(TextFormField),
          )
          .first;
      await tester.enterText(rowCalories, '300');
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'a',
            Nutrition(calories: 300),
          ),
        ),
      ).called(1);

      final rowName = find
          .descendant(
            of: find.byType(ExpandableNutrition),
            matching: find.byType(EditableText),
          )
          .first;
      await tester.enterText(rowName, 'Scrambled eggs');
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNameChanged(
            MealOfTheDay.breakfast,
            'a',
            'Scrambled eggs',
          ),
        ),
      ).called(1);

      await tester.tap(find.byIcon(Icons.delete_forever_outlined).first);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'a'),
        ),
      ).called(1);

      final composerName = find
          .descendant(
            of: find.byType(UsualMealComposer),
            matching: find.byType(TextFormField),
          )
          .first;
      await tester.enterText(composerName, 'Oats');
      await tester.tap(find.byIcon(Icons.add).first);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Oats',
            Nutrition(),
          ),
        ),
      ).called(1);
    });
  });
}
