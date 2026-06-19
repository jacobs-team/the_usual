import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

void main() {
  setUp(() {
    initHydratedStorage();
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(false);
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
    // getIt produces a fresh FoodEntryBloc per call; register the deps it needs.
    if (getIt.isRegistered<MealAiRepository>()) {
      getIt.unregister<MealAiRepository>();
    }
    getIt.registerSingleton<MealAiRepository>(repository);
    if (getIt.isRegistered<UserSettingsBloc>()) {
      getIt.unregister<UserSettingsBloc>();
    }
    getIt.registerSingleton<UserSettingsBloc>(userSettingsBloc);
    if (!getIt.isRegistered<FoodEntryBloc>()) {
      getIt.registerFactory<FoodEntryBloc>(
        () => FoodEntryBloc(
          getIt<MealAiRepository>(),
          getIt<UserSettingsBloc>(),
        ),
      );
    }
  });

  testWidgets('seeds a row per initial food and exposes results', (
    tester,
  ) async {
    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodEntryForm(
            key: formKey,
            initialFoods: const [
              (
                name: 'Toast',
                nutrition: Nutrition(calories: 120),
                quantity: 1.0,
                addToUsualMeals: false,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(formKey.currentState!.results, hasLength(1));
    expect(formKey.currentState!.results.single.name, equals('Toast'));
    expect(formKey.currentState!.hasContent, isTrue);
  });
}
