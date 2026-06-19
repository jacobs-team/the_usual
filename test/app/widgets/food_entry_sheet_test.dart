import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

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
  group(FoodEntrySheet, () {
    setUpAll(() {
      registerFallbackValue(
        const UserSettingsEvent.mealEntryModeChanged(MealEntryMode.itemized),
      );
      registerFallbackValue(MealEntryMode.wholeMeal);
      registerFallbackValue(transparentPixel);
    });

    /// Opens the sheet from a button and records the foods from whatever it
    /// pops with. When [aiRepository] or [userSettingsBloc] are given they
    /// replace the defaults, so the AI controls render and the mode toggle is
    /// observable.
    Future<List<List<FoodEntryResult>?>> showSheet(
      WidgetTester tester, {
      bool showAddToUsualMeals = false,
      MockMealAiRepository? aiRepository,
      MockUserSettingsBloc? userSettingsBloc,
    }) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final results = <List<FoodEntryResult>?>[];
      await tester.pumpPumpPumpItUP(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final sheetResult =
                  await showModalBottomSheet<FoodEntrySheetResult>(
                context: context,
                builder: (_) => FoodEntrySheet(
                  title: 'Log food',
                  confirmLabel: 'Log',
                  showAddToUsualMeals: showAddToUsualMeals,
                ),
              );
              results.add(sheetResult?.foods);
            },
            child: const Text('open'),
          ),
        ),
        deps: [
          ?aiRepository,
          ?userSettingsBloc,
        ],
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return results;
    }

    /// A configured AI repository so the sheet shows its AI controls.
    MockMealAiRepository configuredAiRepository() {
      final repository = MockMealAiRepository();
      when(() => repository.isConfigured).thenReturn(true);
      return repository;
    }

    MockUserSettingsBloc userSettingsBlocWith(MealEntryMode mealEntryMode) {
      final bloc = MockUserSettingsBloc();
      when(
        () => bloc.state,
      ).thenReturn(UserSettingsState(mealEntryMode: mealEntryMode));
      when(() => bloc.stream).thenAnswer((_) => const Stream.empty());
      return bloc;
    }

    Finder caloriesField() => find
        .descendant(
          of: find.byType(NutritionFields),
          matching: find.byType(TextFormField),
        )
        .first;

    /// The food-name fields, found by their hint so the nutrition fields in
    /// each row aren't matched.
    Finder nameFields() => find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'e.g. Chicken caesar salad',
    );

    testWidgets('renders title and sections', (tester) async {
      await showSheet(tester);

      expect(find.text('Log food'), findsOneWidget);
      expect(find.text('CALORIES'), findsOneWidget);
      expect(find.text('PROTEIN'), findsOneWidget);
      expect(find.text('FAT'), findsOneWidget);
      expect(find.text('CARBS'), findsOneWidget);
    });

    testWidgets('confirm is disabled until a name is entered', (tester) async {
      await showSheet(tester);

      final confirmBefore = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmBefore.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.pump();

      final confirmAfter = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(confirmAfter.onPressed, isNotNull);
    });

    testWidgets('confirm pops with the entered values', (tester) async {
      final results = await showSheet(tester, showAddToUsualMeals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.enterText(caloriesField(), '380');
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(
        results.single,
        equals([
          (
            name: 'Salad',
            nutrition: const Nutrition(calories: 380),
            quantity: 1,
            addToUsualMeals: true,
          ),
        ]),
      );
    });

    testWidgets('steps the quantity up before logging', (tester) async {
      final results = await showSheet(tester, showAddToUsualMeals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(
        results.single,
        equals([
          (
            name: 'Salad',
            nutrition: const Nutrition(),
            quantity: 3,
            addToUsualMeals: true,
          ),
        ]),
      );
    });

    testWidgets('toggling the checkbox flips the add-to-usuals flag', (
      tester,
    ) async {
      final results = await showSheet(tester, showAddToUsualMeals: true);

      await tester.enterText(find.byType(TextFormField).first, 'Salad');
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(
        results.single,
        equals([
          (
            name: 'Salad',
            nutrition: const Nutrition(),
            quantity: 1,
            addToUsualMeals: false,
          ),
        ]),
      );
    });

    testWidgets('the close button pops with null', (tester) async {
      final results = await showSheet(tester);

      // A single row can't be removed, so the only close icon is the sheet's.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(results.single, isNull);
    });

    testWidgets('adding and removing rows builds the result list', (
      tester,
    ) async {
      await showSheet(tester);

      await tester.enterText(nameFields().first, 'Salad');
      await tester.tap(find.text('Add item'));
      await tester.pumpAndSettle();

      expect(nameFields(), findsNWidgets(2));

      await tester.enterText(nameFields().at(1), 'Toast');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();

      expect(nameFields(), findsOneWidget);
    });

    testWidgets('confirm pops with one result per named row', (tester) async {
      final results = await showSheet(tester);

      await tester.enterText(nameFields().first, 'Salad');
      await tester.tap(find.text('Add item'));
      await tester.pumpAndSettle();
      await tester.enterText(nameFields().at(1), 'Toast');
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      expect(
        results.single,
        equals([
          (
            name: 'Salad',
            nutrition: const Nutrition(),
            quantity: 1.0,
            addToUsualMeals: false,
          ),
          (
            name: 'Toast',
            nutrition: const Nutrition(),
            quantity: 1.0,
            addToUsualMeals: false,
          ),
        ]),
      );
    });

    group('with AI configured', () {
      testWidgets('shows the AI controls when configured', (tester) async {
        await showSheet(tester, aiRepository: configuredAiRepository());

        expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
        expect(find.byIcon(Icons.photo_camera_outlined), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        // The only checkbox here is the itemize toggle.
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('the info control explains the itemize mode', (tester) async {
        await showSheet(tester, aiRepository: configuredAiRepository());

        final tooltip = tester.widget<Tooltip>(
          find.ancestor(
            of: find.byIcon(Icons.info_outline),
            matching: find.byType(Tooltip),
          ),
        );
        expect(tooltip.message, equals(MealEntryMode.itemized.detail));
      });

      testWidgets('toggling itemize remembers the mode as the default', (
        tester,
      ) async {
        final userSettingsBloc = userSettingsBlocWith(MealEntryMode.wholeMeal);
        await showSheet(
          tester,
          aiRepository: configuredAiRepository(),
          userSettingsBloc: userSettingsBloc,
        );

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.mealEntryModeChanged(
              MealEntryMode.itemized,
            ),
          ),
        ).called(1);
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });

      testWidgets('estimate without a name shows a prompt snackbar', (
        tester,
      ) async {
        await showSheet(tester, aiRepository: configuredAiRepository());

        await tester.tap(find.text('Estimate'));
        await tester.pump();

        expect(
          find.text('Type a meal name or description first.'),
          findsOneWidget,
        );
      });

      testWidgets(
        'estimate on a single whole-meal row keeps the typed name',
        (tester) async {
          final aiRepository = configuredAiRepository();
          when(
            () => aiRepository.suggestFromDescription(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: 'Chicken caesar salad',
                nutrition: Nutrition(calories: 420, protein: 35),
              ),
            ],
          );
          final results = await showSheet(
            tester,
            showAddToUsualMeals: true,
            aiRepository: aiRepository,
          );

          await tester.enterText(
            nameFields().first,
            'My salad',
          );
          await tester.pump();
          await tester.tap(find.text('Estimate'));
          await tester.pumpAndSettle();

          expect(find.text('My salad'), findsOneWidget);
          expect(find.text('420'), findsOneWidget);

          await tester.tap(find.text('Log'));
          await tester.pumpAndSettle();

          expect(
            results.single,
            equals([
              (
                name: 'My salad',
                nutrition: const Nutrition(calories: 420, protein: 35),
                quantity: 1.0,
                addToUsualMeals: true,
              ),
            ]),
          );
        },
      );

      testWidgets('itemized estimate replaces rows with the model names', (
        tester,
      ) async {
        final userSettingsBloc = userSettingsBlocWith(MealEntryMode.itemized);
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer(
          (_) async => const [
            AiMealSuggestion(
              name: 'Steak',
              nutrition: Nutrition(calories: 500),
            ),
            AiMealSuggestion(
              name: 'Potatoes',
              nutrition: Nutrition(calories: 200),
            ),
          ],
        );
        await showSheet(
          tester,
          aiRepository: aiRepository,
          userSettingsBloc: userSettingsBloc,
        );

        await tester.enterText(
          nameFields().first,
          'Steak and potatoes',
        );
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pumpAndSettle();

        expect(find.text('Steak'), findsOneWidget);
        expect(find.text('Potatoes'), findsOneWidget);
      });

      testWidgets('an empty estimate leaves the row untouched', (tester) async {
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => const []);
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(
          nameFields().first,
          'Mystery food',
        );
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pumpAndSettle();

        expect(find.text('Mystery food'), findsOneWidget);
      });

      testWidgets('a failed estimate surfaces an error snackbar', (
        tester,
      ) async {
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenThrow(Exception('network down'));
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(
          nameFields().first,
          'Salad',
        );
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Could not estimate nutrition'),
          findsOneWidget,
        );
      });

      testWidgets('estimates each named row on its own when itemized', (
        tester,
      ) async {
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            'Steak',
            mode: any(named: 'mode'),
          ),
        ).thenAnswer(
          (_) async => const [
            AiMealSuggestion(
              name: 'Steak',
              nutrition: Nutrition(calories: 500),
            ),
          ],
        );
        when(
          () => aiRepository.suggestFromDescription(
            'Potatoes',
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) async => const []);
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(nameFields().first, 'Steak');
        await tester.tap(find.text('Add item'));
        await tester.pumpAndSettle();
        await tester.enterText(
          nameFields().at(1),
          'Potatoes',
        );
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pumpAndSettle();

        expect(find.text('Steak'), findsOneWidget);
        expect(find.text('500'), findsOneWidget);
        expect(find.text('Potatoes'), findsOneWidget);
      });

      testWidgets('a failed per-row estimate surfaces an error snackbar', (
        tester,
      ) async {
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenThrow(Exception('boom'));
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(nameFields().first, 'Steak');
        await tester.tap(find.text('Add item'));
        await tester.pumpAndSettle();
        await tester.enterText(
          nameFields().at(1),
          'Potatoes',
        );
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Could not estimate nutrition'),
          findsOneWidget,
        );
      });

      testWidgets('the photo button opens the source picker', (tester) async {
        await showSheet(tester, aiRepository: configuredAiRepository());

        await tester.tap(find.text('Photo'));
        await tester.pumpAndSettle();

        expect(find.text('Photo source'), findsOneWidget);
        expect(find.text('Camera'), findsOneWidget);
        expect(find.text('Photo library'), findsOneWidget);

        // Dismiss the picker by tapping the scrim, cancelling the flow.
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(find.text('Photo source'), findsNothing);
      });

      testWidgets('a picked photo estimates and fills the row', (
        tester,
      ) async {
        ImagePickerPlatform.instance = _FakeImagePickerPlatform();

        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
            description: any(named: 'description'),
          ),
        ).thenAnswer(
          (_) async => const [
            AiMealSuggestion(
              name: 'Grilled chicken',
              nutrition: Nutrition(calories: 300, protein: 40),
            ),
          ],
        );
        await showSheet(tester, aiRepository: aiRepository);

        await tester.tap(find.text('Photo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Camera'));
        await tester.pumpAndSettle();

        expect(find.text('Grilled chicken'), findsOneWidget);
        expect(find.text('300'), findsOneWidget);
        verify(
          () => aiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
          ),
        ).called(1);
      });

      testWidgets('a typed description is kept over the photo estimate', (
        tester,
      ) async {
        ImagePickerPlatform.instance = _FakeImagePickerPlatform();

        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
            description: any(named: 'description'),
          ),
        ).thenAnswer(
          (_) async => const [
            AiMealSuggestion(
              name: 'Model name',
              nutrition: Nutrition(calories: 300),
            ),
          ],
        );
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(nameFields().first, 'My lunch');
        await tester.pump();
        await tester.tap(find.text('Photo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Photo library'));
        await tester.pumpAndSettle();

        expect(find.text('My lunch'), findsOneWidget);
        expect(find.text('Model name'), findsNothing);
        verify(
          () => aiRepository.suggestFromPhoto(
            any(),
            mode: any(named: 'mode'),
            description: 'My lunch',
          ),
        ).called(1);
      });

      testWidgets('shows the spinner while an estimate is in flight', (
        tester,
      ) async {
        final completer = Completer<List<AiMealSuggestion>>();
        final aiRepository = configuredAiRepository();
        when(
          () => aiRepository.suggestFromDescription(
            any(),
            mode: any(named: 'mode'),
          ),
        ).thenAnswer((_) => completer.future);
        await showSheet(tester, aiRepository: aiRepository);

        await tester.enterText(nameFields().first, 'Salad');
        await tester.pump();
        await tester.tap(find.text('Estimate'));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Estimating…'), findsOneWidget);

        completer.complete(const [
          AiMealSuggestion(name: 'Salad', nutrition: Nutrition(calories: 100)),
        ]);
        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });
  });

  group('FoodEntrySheet pop shape', () {
    setUp(() {
      initHydratedStorage();
      final repository = MockMealAiRepository();
      when(() => repository.isConfigured).thenReturn(false);
      final userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
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

    testWidgets('confirm pops foods with the target slot', (tester) async {
      FoodEntrySheetResult? popped;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  popped = await showModalBottomSheet<FoodEntrySheetResult>(
                    context: context,
                    builder: (_) => const FoodEntrySheet(
                      title: 'Log',
                      confirmLabel: 'Log',
                      initialMealOfTheDay: MealOfTheDay.lunch,
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Soup');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Log'));
      await tester.pumpAndSettle();

      expect(popped, isNotNull);
      expect(popped!.foods.single.name, equals('Soup'));
      expect(popped!.mealOfTheDay, equals(MealOfTheDay.lunch));
    });
  });
}
