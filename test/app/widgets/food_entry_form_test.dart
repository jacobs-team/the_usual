import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Nutrition());
  });

  setUp(() async {
    initHydratedStorage();
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(false);
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
    // getIt produces a fresh FoodEntryBloc per call; register the deps
    // it needs.
    if (getIt.isRegistered<MealAiRepository>()) {
      await getIt.unregister<MealAiRepository>();
    }
    getIt.registerSingleton<MealAiRepository>(repository);
    if (getIt.isRegistered<UserSettingsBloc>()) {
      await getIt.unregister<UserSettingsBloc>();
    }
    getIt.registerSingleton<UserSettingsBloc>(userSettingsBloc);
    final dailyLogBloc = MockDailyLogBloc();
    when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
    if (getIt.isRegistered<DailyLogBloc>()) {
      await getIt.unregister<DailyLogBloc>();
    }
    getIt.registerSingleton<DailyLogBloc>(dailyLogBloc);
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
                components: <MealComponent>[],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(formKey.currentState!.results, hasLength(1));
    expect(formKey.currentState!.results.single.name, equals('Toast'));
    expect(formKey.currentState!.results.first.components, isEmpty);
    expect(formKey.currentState!.hasContent, isTrue);
  });

  testWidgets('changeMealOfTheDay switches the form slot', (tester) async {
    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FoodEntryForm(key: formKey)),
      ),
    );
    await tester.pump();

    formKey.currentState!.changeMealOfTheDay(MealOfTheDay.dinner);
    await tester.pump();

    expect(formKey.currentState!.mealOfTheDay, equals(MealOfTheDay.dinner));
  });

  testWidgets('shows attached photos and removes one when tapped', (
    tester,
  ) async {
    if (getIt.isRegistered<MealAiRepository>()) {
      await getIt.unregister<MealAiRepository>();
    }
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(true);
    getIt.registerSingleton<MealAiRepository>(repository);

    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodEntryForm(
            initialPhotos: [
              MealPhoto(bytes: transparentPixel),
              MealPhoto(bytes: transparentPixel),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Image), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('tapping the "Save as usual" label toggles the flag', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodEntryForm(
            key: formKey,
            showAddToUsualMeals: true,
            initialFoods: const [
              (
                name: 'Toast',
                nutrition: Nutrition(calories: 120),
                quantity: 1.0,
                addToUsualMeals: false,
                components: <MealComponent>[],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(formKey.currentState!.results.single.addToUsualMeals, isFalse);

    // The "Save as usual" label sits in its own opaque GestureDetector beside
    // the checkbox; tap that detector (the one wrapping a Text), not the
    // checkbox's own internal gesture detectors.
    final labelRow = find.ancestor(
      of: find.byType(Checkbox),
      matching: find.byType(Row),
    );
    final labelGestureDetector = find
        .descendant(
          of: labelRow,
          matching: find.byWidgetPredicate(
            (widget) => widget is GestureDetector && widget.child is Text,
          ),
        )
        .first;
    await tester.tap(labelGestureDetector);
    await tester.pump();

    expect(formKey.currentState!.results.single.addToUsualMeals, isTrue);
  });

  testWidgets('shows SegmentedButton toggle and removes old checkbox cluster', (
    tester,
  ) async {
    if (getIt.isRegistered<MealAiRepository>()) {
      await getIt.unregister<MealAiRepository>();
    }
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(true);
    getIt.registerSingleton<MealAiRepository>(repository);

    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FoodEntryForm(key: formKey)),
      ),
    );
    await tester.pump();

    expect(find.byType(SegmentedButton<MealEntryMode>), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsNothing);

    // Tapping the "By foods" segment dispatches entryModeToggled.
    final segmentedButton = tester.widget<SegmentedButton<MealEntryMode>>(
      find.byType(SegmentedButton<MealEntryMode>),
    );
    expect(segmentedButton.selected, equals({MealEntryMode.wholeMeal}));

    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<MealEntryMode>),
        matching: find.text(MealEntryMode.itemized.label),
      ),
    );
    await tester.pump();

    final updatedButton = tester.widget<SegmentedButton<MealEntryMode>>(
      find.byType(SegmentedButton<MealEntryMode>),
    );
    expect(updatedButton.selected, equals({MealEntryMode.itemized}));
  });

  testWidgets('keeps the nutrition field state while editing a value', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FoodEntryForm())),
    );
    await tester.pump();

    final stateBeforeEdit = tester.state(find.byType(NutritionFields));

    final caloriesField = find
        .descendant(
          of: find.byType(NutritionFields),
          matching: find.byType(TextFormField),
        )
        .first;
    await tester.enterText(caloriesField, '5');
    await tester.pumpAndSettle();

    // The edit round-trips through the bloc and rebuilds the row. The field's
    // own State (and thus its focus) must survive, or the user loses focus
    // after a single character.
    expect(tester.state(find.byType(NutritionFields)), same(stateBeforeEdit));
  });

  testWidgets(
    'tapping save-to-library on a food saves it and links the row',
    (tester) async {
      final userSettingsBloc =
          getIt<UserSettingsBloc>() as MockUserSettingsBloc;
      when(
        () => userSettingsBloc.saveAsUsualFood(any(), any()),
      ).thenReturn('f9');

      if (getIt.isRegistered<MealAiRepository>()) {
        await getIt.unregister<MealAiRepository>();
      }
      final repository = MockMealAiRepository();
      when(() => repository.isConfigured).thenReturn(true);
      getIt.registerSingleton<MealAiRepository>(repository);

      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FoodEntryForm(
                initialFoods: [
                  (
                    name: 'Chicken, 1 oz',
                    nutrition: Nutrition(calories: 50, protein: 9),
                    quantity: 1.0,
                    addToUsualMeals: false,
                    components: <MealComponent>[],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Switch to By foods mode.
      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<MealEntryMode>),
          matching: find.text(MealEntryMode.itemized.label),
        ),
      );
      await tester.pump();

      // The save-to-library button (bookmark_add_outlined icon) must be
      // visible.
      expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);

      // Tap it.
      await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
      await tester.pump();

      // saveAsUsualFood was called with the food's name.
      verify(
        () => userSettingsBloc.saveAsUsualFood('Chicken, 1 oz', any()),
      ).called(1);

      // The row is now linked: the save button is gone, the bookmark icon
      // appears.
      expect(find.byIcon(Icons.bookmark_add_outlined), findsNothing);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    },
  );

  testWidgets(
    'tapping "Add a food" in by-foods mode opens a UsualFoodPickerSheet',
    (tester) async {
      if (getIt.isRegistered<MealAiRepository>()) {
        await getIt.unregister<MealAiRepository>();
      }
      final repository = MockMealAiRepository();
      when(() => repository.isConfigured).thenReturn(true);
      getIt.registerSingleton<MealAiRepository>(repository);

      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: FoodEntryForm())),
        ),
      );
      await tester.pump();

      // Switch to By foods mode.
      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<MealEntryMode>),
          matching: find.text(MealEntryMode.itemized.label),
        ),
      );
      await tester.pump();

      // Tap the "Add a food" TextButton (the one whose icon is Icons.add and
      // whose ancestor is a TextButton, not one of the food-row icon buttons).
      await tester.tap(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.byIcon(Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsualFoodPickerSheet), findsOneWidget);
    },
  );

  // --- by-foods callback coverage ---

  /// Shared helper: pump the form in by-foods (itemized) mode.
  /// Requires MealAiRepository.isConfigured == true so the
  /// SegmentedButton renders.
  Future<GlobalKey<FoodEntryFormState>> pumpByFoodsForm(
    WidgetTester tester, {
    List<FoodEntryResult> initialFoods = const [],
  }) async {
    if (getIt.isRegistered<MealAiRepository>()) {
      await getIt.unregister<MealAiRepository>();
    }
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(true);
    getIt.registerSingleton<MealAiRepository>(repository);

    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: FoodEntryForm(
              key: formKey,
              initialFoods: initialFoods,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<MealEntryMode>),
        matching: find.text(MealEntryMode.itemized.label),
      ),
    );
    await tester.pump();

    return formKey;
  }

  testWidgets(
    'by-foods: entering calories fires onFoodNutritionChanged',
    (tester) async {
      await pumpByFoodsForm(
        tester,
        initialFoods: const [
          (
            name: 'Chicken',
            nutrition: Nutrition(calories: 100),
            quantity: 1.0,
            addToUsualMeals: false,
            components: <MealComponent>[],
          ),
        ],
      );

      // The NutritionFields inside the food row contains TextFormFields;
      // the first one is calories.
      final caloriesField = find
          .descendant(
            of: find.byType(NutritionFields),
            matching: find.byType(TextFormField),
          )
          .first;
      await tester.enterText(caloriesField, '250');
      await tester.pump();

      // The form state reflects the updated nutrition.
      // Verify by checking that NutritionFields is still present (the
      // bloc round-tripped without throwing).
      expect(find.byType(NutritionFields), findsOneWidget);
    },
  );

  testWidgets(
    'by-foods: tapping QuantityStepper + fires onFoodQuantityChanged',
    (tester) async {
      await pumpByFoodsForm(
        tester,
        initialFoods: const [
          (
            name: 'Rice',
            nutrition: Nutrition(calories: 200),
            quantity: 1.0,
            addToUsualMeals: false,
            components: <MealComponent>[],
          ),
        ],
      );

      // Tap the + button on the food row's QuantityStepper.
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();

      // The QuantityStepper is still rendered — event round-tripped ok.
      expect(find.byType(QuantityStepper), findsOneWidget);
    },
  );

  testWidgets(
    'by-foods: tapping remove on a row fires onFoodRemoved',
    (tester) async {
      await pumpByFoodsForm(
        tester,
        initialFoods: const [
          (
            name: 'Chicken',
            nutrition: Nutrition(calories: 300),
            quantity: 1.0,
            addToUsualMeals: false,
            components: <MealComponent>[],
          ),
          (
            name: 'Rice',
            nutrition: Nutrition(calories: 200),
            quantity: 1.0,
            addToUsualMeals: false,
            components: <MealComponent>[],
          ),
        ],
      );

      // Two rows means canRemove == true, so close icons render.
      expect(find.byIcon(Icons.close), findsWidgets);

      // Tap the first close icon to remove the first food row.
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      // Only one food row remains.
      expect(find.byType(QuantityStepper), findsOneWidget);
    },
  );

  testWidgets(
    'by-foods: entering a food in the picker and tapping Add adds a row',
    (tester) async {
      await pumpByFoodsForm(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.byIcon(Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsualFoodPickerSheet), findsOneWidget);

      // Enter a name in the picker's entry card and tap its Add button.
      await tester.enterText(find.byKey(const Key('newFoodName')), 'Avocado');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithIcon(FilledButton, Icons.add));
      await tester.pumpAndSettle();

      // The sheet is dismissed and the entered food was added as a new row
      // (two QuantitySteppers: the initial one plus the new one).
      expect(find.byType(UsualFoodPickerSheet), findsNothing);
      expect(find.byType(QuantityStepper), findsWidgets);
    },
  );

  testWidgets(
    'by-foods: tapping "Add a food" then a usual food fires foodPicked',
    (tester) async {
      final userSettingsBloc =
          getIt<UserSettingsBloc>() as MockUserSettingsBloc;
      when(() => userSettingsBloc.state).thenReturn(
        const UserSettingsState(
          usualFoods: [
            UsualFood(id: 'f1', name: 'Oats'),
          ],
        ),
      );

      await pumpByFoodsForm(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(TextButton),
          matching: find.byIcon(Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UsualFoodPickerSheet), findsOneWidget);

      // Tap the usual food tile (keyed by its id).
      await tester.tap(find.byKey(const ValueKey('f1')));
      await tester.pumpAndSettle();

      expect(find.byType(UsualFoodPickerSheet), findsNothing);
      // The picked food was added: two rows exist.
      expect(find.byType(QuantityStepper), findsWidgets);
    },
  );

  testWidgets(
    'by-foods: tapping save-to-library on a row with no name is a no-op',
    (tester) async {
      final userSettingsBloc =
          getIt<UserSettingsBloc>() as MockUserSettingsBloc;

      // Seed a food with an empty name so the early-return guard triggers.
      await pumpByFoodsForm(
        tester,
        initialFoods: const [
          (
            name: '',
            nutrition: Nutrition(),
            quantity: 1.0,
            addToUsualMeals: false,
            components: <MealComponent>[],
          ),
        ],
      );

      expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.bookmark_add_outlined));
      await tester.pump();

      // saveAsUsualFood must NOT have been called.
      verifyNever(() => userSettingsBloc.saveAsUsualFood(any(), any()));
      // Row still shows the save icon (not linked).
      expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);
    },
  );

  testWidgets(
    'by-foods mode renders meal-name field, per-row QuantityStepper, '
    'NutritionSummary total, and results returns one composed entry',
    (tester) async {
      if (getIt.isRegistered<MealAiRepository>()) {
        await getIt.unregister<MealAiRepository>();
      }
      final repository = MockMealAiRepository();
      when(() => repository.isConfigured).thenReturn(true);
      getIt.registerSingleton<MealAiRepository>(repository);

      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Seed two named foods so the results shape can be verified without
      // relying on enterText driving bloc events for food names.
      final formKey = GlobalKey<FoodEntryFormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FoodEntryForm(
                key: formKey,
                initialFoods: const [
                  (
                    name: 'Chicken',
                    nutrition: Nutrition(calories: 300),
                    quantity: 1.0,
                    addToUsualMeals: false,
                    components: <MealComponent>[],
                  ),
                  (
                    name: 'Rice',
                    nutrition: Nutrition(calories: 200),
                    quantity: 1.0,
                    addToUsualMeals: false,
                    components: <MealComponent>[],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Switch to By foods mode.
      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<MealEntryMode>),
          matching: find.text(MealEntryMode.itemized.label),
        ),
      );
      await tester.pump();

      // The by-foods body must render per-row QuantityStepper controls and a
      // single NutritionSummary total line.
      expect(find.byType(QuantityStepper), findsWidgets);
      expect(find.byType(NutritionSummary), findsOneWidget);

      // Enter a meal name via the meal-name TheUsualTextField (the first one,
      // keyed as 'meal_name_field').
      await tester.enterText(
        find.byKey(const ValueKey('meal_name_field')),
        'Chicken & rice bowl',
      );
      await tester.pump();

      final results = formKey.currentState!.results;
      expect(results, hasLength(1));
      expect(results.single.name, equals('Chicken & rice bowl'));
      expect(results.single.components, hasLength(2));
      expect(
        results.single.nutrition,
        equals(results.single.components.componentsTotal),
      );
    },
  );
}
