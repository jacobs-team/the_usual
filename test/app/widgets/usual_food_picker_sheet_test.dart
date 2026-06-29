import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

void main() {
  setUp(() async {
    initHydratedStorage();
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(
      const UserSettingsState(
        usualFoods: [
          UsualFood(
            id: 'f1',
            name: 'Chicken, 1 oz',
            nutrition: Nutrition(calories: 50, protein: 9),
          ),
          UsualFood(
            id: 'f2',
            name: 'Brown rice, 1 cup',
            nutrition: Nutrition(calories: 215, carbs: 45),
          ),
        ],
      ),
    );
    if (getIt.isRegistered<UserSettingsBloc>()) {
      await getIt.unregister<UserSettingsBloc>();
    }
    getIt.registerSingleton<UserSettingsBloc>(userSettingsBloc);
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => TheUsualBottomSheet.show<UsualFoodPickerResult>(
                context,
                builder: (_) => const UsualFoodPickerSheet(),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
  }

  testWidgets('renders a ListTile per usual food plus the new-food tile', (
    tester,
  ) async {
    await pumpSheet(tester);

    expect(find.byKey(const Key('pickerNewFood')), findsOneWidget);
    expect(find.byKey(const ValueKey('f1')), findsOneWidget);
    expect(find.byKey(const ValueKey('f2')), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('tapping a food pops the sheet with that UsualFood', (
    tester,
  ) async {
    UsualFoodPickerResult? poppedResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                poppedResult =
                    await TheUsualBottomSheet.show<UsualFoodPickerResult>(
                      context,
                      builder: (_) => const UsualFoodPickerSheet(),
                    );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('f1')));
    await tester.pumpAndSettle();

    expect(poppedResult, isA<PickedFoodPickerResult>());
    final picked = poppedResult! as PickedFoodPickerResult;
    expect(picked.usualFood.id, equals('f1'));
    expect(picked.usualFood.name, equals('Chicken, 1 oz'));
  });

  testWidgets('tapping "New food" pops the sheet with NewFoodPickerResult', (
    tester,
  ) async {
    UsualFoodPickerResult? poppedResult;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                poppedResult =
                    await TheUsualBottomSheet.show<UsualFoodPickerResult>(
                      context,
                      builder: (_) => const UsualFoodPickerSheet(),
                    );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pickerNewFood')));
    await tester.pumpAndSettle();

    expect(poppedResult, isA<NewFoodPickerResult>());
  });

  testWidgets('shows NutritionSummary as subtitle for each food', (
    tester,
  ) async {
    await pumpSheet(tester);

    expect(find.byType(NutritionSummary), findsNWidgets(2));
  });
}
