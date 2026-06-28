# Usual Foods — Phase 1: Model + Composition Core — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the data foundation that lets a usual meal (and a logged meal) be composed of reusable base-unit foods, with no UI changes yet.

**Architecture:** Two new freezed models — `UsualFood` (a library item) and `MealComponent` (a food inside a meal, carrying a snapshot of the food plus a quantity and a link back to the library). `UsualMeal` and `MealLogEntry` each gain an optional `components` list; when present, the meal's stored `nutrition` represents one serving (the summed scaled components) and the existing `scaledNutrition`/`totalNutrition` paths are unchanged. A flat `usualFoods` library is added to `UserSettingsState`. All additions are backward-compatible defaults; persisted-state versions are bumped.

**Tech Stack:** Dart/Flutter, `freezed`, `json_serializable`, `hydrated_bloc`, `flutter_test`, `bloc_test`, `mocktail`.

## Global Constraints

- **Code generation runs in a background watcher.** Never run `build_runner`. After creating or editing a `@freezed` model, the `.freezed.dart` / `.g.dart` parts regenerate automatically. If a test fails to compile because a generated symbol is missing, the watcher is not running — stop and ask Jacob to start it. (Project rule.)
- **Never run `git commit` or `git push`.** Each task's final step is `git add` of the exact files, then ask Jacob to commit with the suggested message. Do not commit yourself. (Global rule.)
- **Use `fvm flutter` for all Flutter CLI commands**, e.g. `fvm flutter test <path>`.
- **Always use barrel files** (`package:the_usual/app/app.dart` in tests, `package:the_usual/app/model/model.dart` inside model files) over direct imports.
- **Models are `@freezed`**; snake_case is not needed here (these are app-internal, not API DTOs), so plain `@JsonSerializable(explicitToJson: true)` matches the existing `UsualMeal` / `MealLogEntry`.
- **Persisted-state changes need versioning.** Bump `_currentVersion` and the `version` default together, and route old versions through `fromJson`. Additive fields with `@Default(...)` read old JSON straight through. (Project rule.)
- **Tests:** use matchers (`equals()`, `isEmpty`, `isNull`, `isTrue`), never raw assertions. Name groups by the type under test. Run with a random seed: `--test-randomize-ordering-seed random`.
- **Naming:** variables are named after their full model type — `usualFood`, `mealComponent`, `mealLogEntry`, never `food`/`comp`/`meal`.

---

## File Structure

- Create: `lib/app/model/usual_food.dart` — the `UsualFood` library-item model.
- Create: `lib/app/model/meal_component.dart` — the `MealComponent` model + `scaledNutrition`.
- Create: `lib/app/model/extensions/meal_component_list_extensions.dart` — `componentsTotal` on `List<MealComponent>`.
- Modify: `lib/app/model/model.dart` — export the two new models.
- Modify: `lib/app/model/extensions/extensions.dart` — export the new extension.
- Modify: `lib/app/model/usual_meal.dart` — add `components`.
- Modify: `lib/app/model/meal_log_entry.dart` — add `components`.
- Modify: `lib/app/feature/user_settings/bloc/user_settings_state.dart` — add `usualFoods`, bump v3→v4.
- Modify: `lib/app/feature/today/bloc/daily_log_state.dart` — bump v1→v2.
- Create/modify matching test files under `test/app/...`.

---

### Task 1: `UsualFood` model

**Files:**
- Create: `lib/app/model/usual_food.dart`
- Modify: `lib/app/model/model.dart` (add export, keep alphabetical order)
- Test: `test/app/model/usual_food_test.dart`

**Interfaces:**
- Produces: `UsualFood({required String id, required String name, Nutrition nutrition})`, `UsualFood.fromJson`, `usualFood.toJson()`. Default `nutrition` is `const Nutrition()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/usual_food_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualFood, () {
    test('round-trips through json', () {
      const usualFood = UsualFood(
        id: 'food-1',
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5, fat: 1),
      );

      final decoded = UsualFood.fromJson(usualFood.toJson());

      expect(decoded, equals(usualFood));
    });

    test('defaults nutrition to empty when absent', () {
      final usualFood = UsualFood.fromJson(<String, dynamic>{
        'id': 'food-2',
        'name': 'Black coffee',
      });

      expect(usualFood.nutrition, equals(const Nutrition()));
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `fvm flutter test test/app/model/usual_food_test.dart`
Expected: FAIL — compile error, `Undefined name 'UsualFood'`.

- [ ] **Step 3: Create the model**

Create `lib/app/model/usual_food.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_food.freezed.dart';
part 'usual_food.g.dart';

/// {@template usual_food}
/// A base nutritional item in the user's usual foods library: a [name]
/// describing one unit (e.g. "Chicken, 1 oz") and the [nutrition] for that
/// single unit. Foods are combined into composed meals, where a [MealComponent]
/// holds the food and how many units of it the meal contains.
/// {@endtemplate}
@freezed
abstract class UsualFood with _$UsualFood {
  /// {@macro usual_food}
  @JsonSerializable(explicitToJson: true)
  const factory UsualFood({
    required String id,
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
  }) = _UsualFood;

  factory UsualFood.fromJson(Map<String, dynamic> json) =>
      _$UsualFoodFromJson(json);
}
```

Add the export to `lib/app/model/model.dart`, keeping alphabetical order (between `usual_food` and `usual_meal` — `usual_food.dart` sorts before `usual_meal.dart`):

```dart
export 'usual_food.dart';
export 'usual_meal.dart';
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `fvm flutter test test/app/model/usual_food_test.dart`
Expected: PASS (both tests). If it fails to compile on `usual_food.freezed.dart`, the codegen watcher is not running — ask Jacob to start it, then re-run.

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/model/usual_food.dart lib/app/model/usual_food.freezed.dart lib/app/model/usual_food.g.dart lib/app/model/model.dart test/app/model/usual_food_test.dart
```

Ask Jacob to commit: `feat: add UsualFood model for the usual foods library`

---

### Task 2: `MealComponent` model

**Files:**
- Create: `lib/app/model/meal_component.dart`
- Modify: `lib/app/model/model.dart` (add export)
- Test: `test/app/model/meal_component_test.dart`

**Interfaces:**
- Consumes: `Nutrition` and its `*` operator (per-unit × quantity).
- Produces: `MealComponent({required String name, Nutrition nutrition, double quantity, String? usualFoodId})` with `quantity` default `1`; `MealComponent.fromJson`; getter `Nutrition get scaledNutrition`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/meal_component_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealComponent, () {
    test('round-trips through json', () {
      const mealComponent = MealComponent(
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5, fat: 1),
        quantity: 4,
        usualFoodId: 'food-1',
      );

      final decoded = MealComponent.fromJson(mealComponent.toJson());

      expect(decoded, equals(mealComponent));
    });

    test('defaults quantity to 1, nutrition to empty, link to null', () {
      final mealComponent = MealComponent.fromJson(<String, dynamic>{
        'name': 'Rice',
      });

      expect(mealComponent.quantity, equals(1));
      expect(mealComponent.nutrition, equals(const Nutrition()));
      expect(mealComponent.usualFoodId, isNull);
    });

    test('scaledNutrition multiplies per-unit nutrition by quantity', () {
      const mealComponent = MealComponent(
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5),
        quantity: 4,
      );

      // `Nutrition.operator *` leaves unset values null (fat/carbs here), so the
      // expectation only sets the values that were present per unit.
      expect(
        mealComponent.scaledNutrition,
        equals(const Nutrition(calories: 88, protein: 20)),
      );
    });

    test('scaledNutrition supports fractional quantities', () {
      const mealComponent = MealComponent(
        name: 'Quesadilla',
        nutrition: Nutrition(calories: 300),
        quantity: 1.5,
      );

      expect(mealComponent.scaledNutrition.calories, equals(450));
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `fvm flutter test test/app/model/meal_component_test.dart`
Expected: FAIL — compile error, `Undefined name 'MealComponent'`.

- [ ] **Step 3: Create the model**

Create `lib/app/model/meal_component.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'meal_component.freezed.dart';
part 'meal_component.g.dart';

/// {@template meal_component}
/// One food within a composed meal: a snapshot of the food's [name] and
/// per-unit [nutrition], the [quantity] of units in the meal, and an optional
/// [usualFoodId] linking back to the library food it was built from. The
/// component owns its nutrition copy, so editing the library food never changes
/// a meal already built from it; the link only identifies which meals use a
/// food when the user chooses to propagate an edit.
/// {@endtemplate}
@freezed
abstract class MealComponent with _$MealComponent {
  /// {@macro meal_component}
  @JsonSerializable(explicitToJson: true)
  const factory MealComponent({
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) double quantity,
    String? usualFoodId,
  }) = _MealComponent;

  const MealComponent._();

  factory MealComponent.fromJson(Map<String, dynamic> json) =>
      _$MealComponentFromJson(json);

  /// This component's contribution to its meal's total: its per-unit
  /// [nutrition] scaled by [quantity].
  Nutrition get scaledNutrition => nutrition * quantity;
}
```

Add the export to `lib/app/model/model.dart` (alphabetical — `meal_component.dart` sorts before `meal_entry_mode.dart`):

```dart
export 'meal_component.dart';
export 'meal_entry_mode.dart';
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `fvm flutter test test/app/model/meal_component_test.dart`
Expected: PASS (four tests).

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/model/meal_component.dart lib/app/model/meal_component.freezed.dart lib/app/model/meal_component.g.dart lib/app/model/model.dart test/app/model/meal_component_test.dart
```

Ask Jacob to commit: `feat: add MealComponent model with scaledNutrition`

---

### Task 3: `componentsTotal` extension on `List<MealComponent>`

**Files:**
- Create: `lib/app/model/extensions/meal_component_list_extensions.dart`
- Modify: `lib/app/model/extensions/extensions.dart` (add export)
- Test: `test/app/model/extensions/meal_component_list_extensions_test.dart`

**Interfaces:**
- Consumes: `MealComponent.scaledNutrition`, `Nutrition.operator +`.
- Produces: `extension MealComponentListFormatting on List<MealComponent>` with `Nutrition get componentsTotal`. Later phases set a meal's stored `nutrition` to this value on each mutating event.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/extensions/meal_component_list_extensions_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('MealComponentListFormatting.componentsTotal', () {
    test('is empty for an empty list', () {
      expect(<MealComponent>[].componentsTotal, equals(const Nutrition()));
      expect(<MealComponent>[].componentsTotal.isEmpty, isTrue);
    });

    test('sums each component scaled by its quantity', () {
      const components = [
        MealComponent(
          name: 'Chicken, 1 oz',
          nutrition: Nutrition(calories: 22, protein: 5),
          quantity: 4,
        ),
        MealComponent(
          name: 'Rice, cup',
          nutrition: Nutrition(calories: 205, carbs: 45),
        ),
      ];

      final total = components.componentsTotal;

      expect(total.calories, equals(293));
      expect(total.protein, equals(20));
      expect(total.carbs, equals(45));
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `fvm flutter test test/app/model/extensions/meal_component_list_extensions_test.dart`
Expected: FAIL — compile error, `The getter 'componentsTotal' isn't defined`.

- [ ] **Step 3: Create the extension**

Create `lib/app/model/extensions/meal_component_list_extensions.dart`:

```dart
import 'package:the_usual/app/model/model.dart';

extension MealComponentListFormatting on List<MealComponent> {
  /// The combined nutrition of these components, each scaled by its quantity —
  /// one serving of a meal composed from them. Values a component leaves unset
  /// add nothing. Empty when there are no components.
  Nutrition get componentsTotal {
    var nutrition = const Nutrition();
    for (final mealComponent in this) {
      nutrition += mealComponent.scaledNutrition;
    }
    return nutrition;
  }
}
```

Add the export to `lib/app/model/extensions/extensions.dart` (alphabetical — before `meal_log_entry_list_extensions.dart`):

```dart
export 'goal_history_extensions.dart';
export 'meal_component_list_extensions.dart';
export 'meal_log_entry_list_extensions.dart';
export 'workout_set_list_extensions.dart';
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `fvm flutter test test/app/model/extensions/meal_component_list_extensions_test.dart`
Expected: PASS (two tests).

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/model/extensions/meal_component_list_extensions.dart lib/app/model/extensions/extensions.dart test/app/model/extensions/meal_component_list_extensions_test.dart
```

Ask Jacob to commit: `feat: add componentsTotal extension for composed-meal nutrition`

---

### Task 4: Add `components` to `UsualMeal`

**Files:**
- Modify: `lib/app/model/usual_meal.dart`
- Test: `test/app/model/usual_meal_test.dart` (add cases)

**Interfaces:**
- Consumes: `MealComponent`.
- Produces: `UsualMeal` gains `List<MealComponent> components` defaulting to `const <MealComponent>[]`.

- [ ] **Step 1: Add the failing tests**

Append two tests inside the existing `group(UsualMeal, () { ... })` in `test/app/model/usual_meal_test.dart`:

```dart
    test('round-trips with components', () {
      const usualMeal = UsualMeal(
        id: 'usual-3',
        name: 'Chicken & rice bowl',
        nutrition: Nutrition(calories: 293),
        components: [
          MealComponent(
            name: 'Chicken, 1 oz',
            nutrition: Nutrition(calories: 22, protein: 5),
            quantity: 4,
            usualFoodId: 'food-1',
          ),
          MealComponent(
            name: 'Rice, cup',
            nutrition: Nutrition(calories: 205, carbs: 45),
          ),
        ],
      );

      final decoded = UsualMeal.fromJson(usualMeal.toJson());

      expect(decoded, equals(usualMeal));
    });

    test('defaults components to empty for legacy json without the key', () {
      final usualMeal = UsualMeal.fromJson(<String, dynamic>{
        'id': 'usual-4',
        'name': 'Oatmeal',
        'nutrition': {'calories': 300},
      });

      expect(usualMeal.components, isEmpty);
    });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/model/usual_meal_test.dart`
Expected: FAIL — `No named parameter with the name 'components'`.

- [ ] **Step 3: Add the field**

In `lib/app/model/usual_meal.dart`, add `components` after `nutrition`:

```dart
  @JsonSerializable(explicitToJson: true)
  const factory UsualMeal({
    required String id,
    required String name,
    String? photoPath,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(<MealComponent>[]) List<MealComponent> components,
  }) = _UsualMeal;
```

The doc comment `/// A food item in the user's usuals library.` still holds; leave it unchanged.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/model/usual_meal_test.dart`
Expected: PASS (all four cases).

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/model/usual_meal.dart lib/app/model/usual_meal.freezed.dart lib/app/model/usual_meal.g.dart test/app/model/usual_meal_test.dart
```

Ask Jacob to commit: `feat: let a UsualMeal carry component foods`

---

### Task 5: Add `components` to `MealLogEntry`

**Files:**
- Modify: `lib/app/model/meal_log_entry.dart`
- Test: `test/app/model/meal_log_entry_test.dart` (add cases)

**Interfaces:**
- Consumes: `MealComponent`.
- Produces: `MealLogEntry` gains `List<MealComponent> components` defaulting to `const <MealComponent>[]`. Existing `scaledNutrition` getter is unchanged.

- [ ] **Step 1: Add the failing tests**

Append two tests inside the existing `group(MealLogEntry, () { ... })` in `test/app/model/meal_log_entry_test.dart`:

```dart
    test('round-trips with components', () {
      final mealLogEntry = MealLogEntry(
        id: 'meal-3',
        loggedAt: loggedAt,
        mealOfTheDay: MealOfTheDay.lunch,
        name: 'Chicken & rice bowl',
        nutrition: const Nutrition(calories: 293),
        components: const [
          MealComponent(
            name: 'Chicken, 1 oz',
            nutrition: Nutrition(calories: 22, protein: 5),
            quantity: 4,
            usualFoodId: 'food-1',
          ),
        ],
      );

      final decoded = MealLogEntry.fromJson(mealLogEntry.toJson());

      expect(decoded, equals(mealLogEntry));
    });

    test('defaults components to empty for legacy json without the key', () {
      final mealLogEntry = MealLogEntry.fromJson(<String, dynamic>{
        'id': 'meal-4',
        'loggedAt': loggedAt.toIso8601String(),
        'mealOfTheDay': 'dinner',
        'name': 'Tacos',
      });

      expect(mealLogEntry.components, isEmpty);
    });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/model/meal_log_entry_test.dart`
Expected: FAIL — `No named parameter with the name 'components'`.

- [ ] **Step 3: Add the field**

In `lib/app/model/meal_log_entry.dart`, add `components` after `photoPath`:

```dart
  @JsonSerializable(explicitToJson: true)
  const factory MealLogEntry({
    required String id,
    required DateTime loggedAt,
    required MealOfTheDay mealOfTheDay,
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) double quantity,
    String? usualMealId,
    String? photoPath,
    @Default(<MealComponent>[]) List<MealComponent> components,
  }) = _MealLogEntry;
```

Leave the `scaledNutrition` getter and the class doc comment unchanged.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/model/meal_log_entry_test.dart`
Expected: PASS (all four cases).

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/model/meal_log_entry.dart lib/app/model/meal_log_entry.freezed.dart lib/app/model/meal_log_entry.g.dart test/app/model/meal_log_entry_test.dart
```

Ask Jacob to commit: `feat: let a MealLogEntry carry component foods`

---

### Task 6: Add `usualFoods` library to `UserSettingsState` and bump v3 → v4

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_state.dart`
- Test: `test/app/feature/user_settings/bloc/user_settings_state_test.dart` (add cases, fix one existing assertion)

**Interfaces:**
- Consumes: `UsualFood`.
- Produces: `UserSettingsState` gains `List<UsualFood> usualFoods` (flat library, default empty); `version` default and `_currentVersion` become `4`.

- [ ] **Step 1: Write the failing tests + fix the version assertion**

In `test/app/feature/user_settings/bloc/user_settings_state_test.dart`, add a `usualFoods` group (e.g. after the `fromJson` group):

```dart
    group('usualFoods', () {
      test('defaults to empty', () {
        expect(const UserSettingsState().usualFoods, isEmpty);
      });

      test('round-trips a populated usualFoods library', () {
        const state = UserSettingsState(
          usualFoods: [
            UsualFood(
              id: 'food-1',
              name: 'Chicken, 1 oz',
              nutrition: Nutrition(calories: 22, protein: 5),
            ),
          ],
        );

        final restored = UserSettingsState.fromJson(state.toJson());

        expect(restored.usualFoods, hasLength(1));
        expect(restored.usualFoods.single.name, equals('Chicken, 1 oz'));
      });

      test('v3 data reads through with an empty library and bumps to v4', () {
        final restored = UserSettingsState.fromJson(<String, dynamic>{
          'version': 3,
          'weightUnit': 'kg',
        });

        expect(restored.usualFoods, isEmpty);
        expect(restored.version, equals(4));
      });
    });
```

In the existing `workout weight unit migration` group, update the assertion that the migrated version is current — it currently expects `3`:

```dart
        expect(state.version, equals(4));
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_state_test.dart`
Expected: FAIL — `No named parameter with the name 'usualFoods'` (and the version assertion would fail once it compiles).

- [ ] **Step 3: Add the field and bump the version**

In `lib/app/feature/user_settings/bloc/user_settings_state.dart`:

Change the `version` default from `3` to `4`:

```dart
    @Default(4) int version,
```

Add the `usualFoods` field next to `usuals`:

```dart
    /// The user's usuals library, keyed by meal timing.
    @Default(<MealOfTheDay, List<UsualMeal>>{})
    Map<MealOfTheDay, List<UsualMeal>> usuals,

    /// The user's usual foods library: reusable base-unit nutritional items
    /// that compose meals. Flat (not keyed by meal timing) because a food like
    /// "Chicken, 1 oz" is reused across meals.
    @Default(<UsualFood>[]) List<UsualFood> usualFoods,
```

Change `_currentVersion` from `3` to `4`:

```dart
  /// The version written by the current app.
  static const _currentVersion = 4;
```

No new `fromJson` branch is needed: the existing factory already rewrites any
older version with `{...migrated, 'version': _currentVersion}`, and `usualFoods`
is additive, so v3 (and earlier) data decodes with an empty library. The existing
migration `if (version <= 2)` / `if (version <= 1)` guards still apply unchanged.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_state_test.dart`
Expected: PASS (all cases, including the updated version assertion).

- [ ] **Step 5: Run the user-settings bloc test to catch version fallout**

Run: `fvm flutter test test/app/feature/user_settings/bloc/`
Expected: PASS. If any test asserted `version == 3`, update it to `4`.

- [ ] **Step 6: Stage and request commit**

```bash
git add lib/app/feature/user_settings/bloc/user_settings_state.dart lib/app/feature/user_settings/bloc/user_settings_state.freezed.dart lib/app/feature/user_settings/bloc/user_settings_state.g.dart test/app/feature/user_settings/bloc/user_settings_state_test.dart
```

Ask Jacob to commit: `feat: add usual foods library to user settings (v4)`

---

### Task 7: Bump `DailyLogState` v1 → v2 for the new `components` field

**Files:**
- Modify: `lib/app/feature/today/bloc/daily_log_state.dart`
- Test: `test/app/feature/today/bloc/daily_log_bloc_test.dart` (add a state-migration group, or create `daily_log_state_test.dart` if the bloc test is crowded — prefer adding to the existing file to match the project layout, which has no separate `daily_log_state_test.dart`).

**Interfaces:**
- Produces: `DailyLogState` `version` default and `_currentVersion` become `2`; v0/v1 data reads straight through (additive `components`).

- [ ] **Step 1: Write the failing tests**

Add a group to `test/app/feature/today/bloc/daily_log_bloc_test.dart` (top-level in `main()`, alongside the existing groups):

```dart
  group('DailyLogState fromJson', () {
    final loggedAt = DateTime(2026, 6, 14, 8, 30);

    test('reads current-version data straight through', () {
      final state = DailyLogState(
        mealEntries: [
          MealLogEntry(
            id: 'meal-1',
            loggedAt: loggedAt,
            mealOfTheDay: MealOfTheDay.breakfast,
            name: 'Eggs',
            nutrition: const Nutrition(calories: 200),
          ),
        ],
      );

      final restored = DailyLogState.fromJson(state.toJson());

      expect(restored.mealEntries, hasLength(1));
      expect(restored.version, equals(2));
    });

    test('reads v1 data with entries that have no components', () {
      final restored = DailyLogState.fromJson(<String, dynamic>{
        'version': 1,
        'mealEntries': [
          {
            'id': 'meal-1',
            'loggedAt': loggedAt.toIso8601String(),
            'mealOfTheDay': 'lunch',
            'name': 'Sandwich',
          },
        ],
        'weightEntries': <dynamic>[],
      });

      expect(restored.mealEntries.single.components, isEmpty);
      expect(restored.mealEntries.single.name, equals('Sandwich'));
    });

    test('round-trips an entry composed of components', () {
      final state = DailyLogState(
        mealEntries: [
          MealLogEntry(
            id: 'meal-2',
            loggedAt: loggedAt,
            mealOfTheDay: MealOfTheDay.dinner,
            name: 'Chicken & rice bowl',
            nutrition: const Nutrition(calories: 293),
            components: const [
              MealComponent(
                name: 'Chicken, 1 oz',
                nutrition: Nutrition(calories: 22, protein: 5),
                quantity: 4,
                usualFoodId: 'food-1',
              ),
            ],
          ),
        ],
      );

      final restored = DailyLogState.fromJson(state.toJson());

      expect(restored.mealEntries.single.components, hasLength(1));
      expect(
        restored.mealEntries.single.components.single.usualFoodId,
        equals('food-1'),
      );
    });
  });
```

Confirm the test file imports `package:the_usual/app/app.dart` (the `DailyLogState`, `DailyLogBloc`, and models come through the barrel). If `DailyLogState` is not exported via the barrel, import it from its bloc file as the existing bloc test does — match the existing import block at the top of `daily_log_bloc_test.dart`.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart`
Expected: FAIL — the `version` assertion expects `2` but the current default is `1`.

- [ ] **Step 3: Bump the version and mark v1 as a known straight-through version**

In `lib/app/feature/today/bloc/daily_log_state.dart`:

Change the `version` default from `1` to `2`:

```dart
    @Default(2) int version,
```

Change `_currentVersion` from `1` to `2`:

```dart
  /// The version written by the current app.
  static const _currentVersion = 2;
```

Add a `case 1` so v1 (which only differs by the additive `components` field) reads
straight through rather than falling to the unknown-version branch:

```dart
  factory DailyLogState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // v0 is unversioned data; v1 predates the `components` field on meal
      // entries. Both read straight through, since `components` is additive and
      // defaults to empty. When a future shape change can't be read as-is, bump
      // [_currentVersion] and add a case that migrates older versions up before
      // this one.
      case 0:
      case 1:
      case _currentVersion:
        return _$DailyLogStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's logged meals and weigh-ins: unknown keys are
        // ignored and missing ones fall back to defaults.
        return _$DailyLogStateFromJson(json);
    }
  }
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart`
Expected: PASS. If an existing bloc test asserted `version == 1` on an emitted/initial state, update it to `2`.

- [ ] **Step 5: Stage and request commit**

```bash
git add lib/app/feature/today/bloc/daily_log_state.dart lib/app/feature/today/bloc/daily_log_bloc.freezed.dart lib/app/feature/today/bloc/daily_log_bloc.g.dart test/app/feature/today/bloc/daily_log_bloc_test.dart
```

Ask Jacob to commit: `feat: version DailyLogState v2 for composed meal entries`

Note: the generated parts for `DailyLogState` live in the bloc's generated files
(`daily_log_bloc.freezed.dart` / `daily_log_bloc.g.dart`) because the state is a
`part of 'daily_log_bloc.dart'`. Stage whichever generated files the watcher
touched (`git status` will show them).

---

### Task 8: Full-suite green check

**Files:** none (verification only).

- [ ] **Step 1: Run the model and affected feature suites with a random seed**

Run:
```bash
fvm flutter test test/app/model test/app/feature/today test/app/feature/user_settings --test-randomize-ordering-seed random
```
Expected: PASS. Investigate and fix any failure caused by the version bumps (search for `equals(1)` / `equals(3)` version assertions, or `toJson` snapshots that now include `components` / `usualFoods`).

- [ ] **Step 2: Run the analyzer on the changed files**

Run: `fvm flutter analyze lib/app/model lib/app/feature/today lib/app/feature/user_settings`
Expected: No errors. (Per project rule, only fix errors, not info/warnings.)

- [ ] **Step 3: Stage and request a final commit if Step 1 or 2 required edits**

Ask Jacob to commit any fixes: `test: keep suite green after usual foods model changes`

---

## Self-Review

**Spec coverage (Phase 1 scope only — model + composition core):**
- `UsualFood` model → Task 1. ✓
- `MealComponent` (snapshot + `usualFoodId` link + quantity) → Task 2. ✓
- Composed-meal total helper (`componentsTotal`, one serving) → Task 3. ✓
- `components` on `UsualMeal` → Task 4. ✓
- `components` on `MealLogEntry`, `scaledNutrition` for meal-level quantity preserved → Task 5. ✓
- Flat `usualFoods` library on settings → Task 6. ✓
- Migrations / version bumps (UserSettings v3→4, DailyLog v1→2, additive defaults) → Tasks 6 & 7. ✓
- Out of Phase 1 (later plans): entry-sheet By-foods mode, AI itemize change, Today log composition + propagate prompt, usual foods management UI, SyncRepository `schemaVersion` bump (belongs with the first phase that changes synced data shape in a user-visible way; the additive fields already sync, so it is deferred to the UI phase that introduces them). Noted, not a Phase 1 gap.

**Placeholder scan:** No TBD/TODO; every code step shows complete code. The one inline note in Task 2 Step 1 corrects an over-specified expectation — the corrected `expect` is the version to use.

**Type consistency:** `UsualFood(id, name, nutrition)`, `MealComponent(name, nutrition, quantity, usualFoodId)` + `scaledNutrition`, `List<MealComponent>.componentsTotal`, `UsualMeal.components`, `MealLogEntry.components`, `UserSettingsState.usualFoods` — names and types are identical everywhere they appear across tasks.
