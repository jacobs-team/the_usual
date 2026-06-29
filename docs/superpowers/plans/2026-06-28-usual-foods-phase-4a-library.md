# Usual Foods — Phase 4a: Library data + management screen — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the `usualFoods` library a curatable, first-class collection: add CRUD events to `UserSettingsBloc`, and a flat "Usual Foods" management screen (mirroring Usual Meals) reachable from settings, where the user adds, edits, and deletes base-unit foods.

**Architecture:** `usualFoods` is a flat `List<UsualFood>` on `UserSettingsState` (added in Phase 1), so its events and screen mirror the usual-meals ones but without the `MealOfTheDay` key. A new `UsualFoodsView` lists the foods as inline-editable `ExpandableNutrition` cards with a FAB that adds via the existing `FoodEntrySheet` (whole-meal mode). Linking foods into meals (the picker, per-food save, propagation) is Phase 4b.

**Tech Stack:** Dart/Flutter, `flutter_bloc`/`HydratedBloc`, `freezed`, `go_router`, `flutter_test`, `bloc_test`, `mocktail`.

## Key implementation decisions (baked in)

1. **Mirror the usual-meals patterns exactly**, dropping `MealOfTheDay`: events `usualFoodAdded(name, nutrition, {id})`, `usualFoodRemoved(id)`, `usualFoodNutritionChanged(id, nutrition)`, `usualFoodNameChanged(id, name)`, plus `String saveAsUsualFood(name, nutrition)` (dedupe by lowercased name, like `saveAsUsualMeal`).
2. **The management screen populates the library directly** via the existing `FoodEntrySheet` (whole-meal mode: a name + nutrition, `showQuantity: false`), so 4a is self-contained even before meals link to the library.
3. **Reuse `ExpandableNutrition`** for the editable food rows (name + nutrition + remove), and `ConfirmDialog` for delete — exactly as `usual_meal_list.dart` does. No new row widget unless the screen file exceeds ~250 lines.
4. **Scope: library CRUD + management screen only.** No `FoodDraft.usualFoodId`, no picker, no per-food save, no propagation, no composed-entry footer — all Phase 4b.

## Global Constraints

- **Do NOT `git commit`/`git push`, and do NOT commit.** Work accumulates in the working tree on `main`; Jacob commits. Each task ends by leaving changes in the working tree.
- **Do NOT run `build_runner`.** A background watcher regenerates `.freezed.dart`/`.g.dart`. If a test fails to compile on a missing generated symbol, wait a few seconds and re-run; if still missing, report DONE_WITH_CONCERNS — never invoke codegen.
- **Use `fvm flutter`** for all Flutter CLI commands.
- **Barrel imports** (`package:the_usual/app/app.dart`, `package:the_usual/design_system/design_system.dart`). Views get blocs via `getIt<T>()`, not `context.read`.
- **`@freezed` events; exhaustive `switch` in `on<Event>`.** `BlocSelector` over `BlocBuilder`.
- **Naming:** variables named after their full model type (`usualFood`, `mealOfTheDay`).
- **Reuse design tokens** (`AppDesign.spacing`/`radius`). Reuse `ExpandableNutrition`, `NutritionFields`, `FoodEntrySheet`, `ConfirmDialog`, `TheUsualBottomSheet`.
- **Tests:** matchers not raw asserts; `blocTest`; `mocktail`; `initHydratedStorage()` in HydratedBloc tests; locate widgets by type/key/icon, NOT UI strings; run with `--test-randomize-ordering-seed random`.
- **Facts:** `UsualFood({required String id, required String name, Nutrition nutrition = const Nutrition()})`. `UserSettingsState.usualFoods` is `@Default(<UsualFood>[]) List<UsualFood>`. `UserSettingsBloc` uses `static const _uuid = Uuid()`. `FoodEntrySheet` returns `FoodEntrySheetResult(foods: List<FoodEntryResult>, mealOfTheDay)` where each `FoodEntryResult` has `name`, `nutrition`, `quantity`, `addToUsualMeals`, `components`.

---

## File Structure

- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart` — four `usualFood*` events.
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart` — their handlers + `saveAsUsualFood` + a `usualFoodCount` getter on the state.
- Create: `lib/app/feature/user_settings/view/usual_foods_view.dart` — the flat management screen.
- Create: `lib/app/feature/user_settings/widgets/usual_food_list.dart` — the inline-editable list body.
- Create: `lib/app/feature/user_settings/widgets/usual_foods_tile.dart` — the settings entry-point tile.
- Modify: the routes file (`Routes`) + the router (`GoRoute`) — add `usualFoods`. (Find exact files: `Routes.usualMeals`/`usualMealsSegment` live in the routes constants file; the `GoRoute` for usuals is in the app router — mirror them.)
- Modify: `lib/app/feature/user_settings/view/user_settings_view.dart` — add the tile under "YOUR FOOD".
- Modify: barrels as needed (`view`/`widgets` barrels for the feature).
- Tests alongside each.

---

### Task 1: `usualFood` CRUD events + `saveAsUsualFood`

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart`
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`
- Test: `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`, `test/app/feature/user_settings/bloc/user_settings_state_test.dart`

**Interfaces:**
- Produces:
  - `UserSettingsEvent.usualFoodAdded(String name, Nutrition nutrition, {String? id}) = SettingsUsualFoodAdded`
  - `UserSettingsEvent.usualFoodRemoved(String id) = SettingsUsualFoodRemoved`
  - `UserSettingsEvent.usualFoodNutritionChanged(String id, Nutrition nutrition) = SettingsUsualFoodNutritionChanged`
  - `UserSettingsEvent.usualFoodNameChanged(String id, String name) = SettingsUsualFoodNameChanged`
  - `String UserSettingsBloc.saveAsUsualFood(String name, Nutrition nutrition)` — returns the id of an existing food with that (lowercased) name, else creates one and returns its new id.
  - `int UserSettingsState.usualFoodCount` getter.

- [ ] **Step 1: Write the failing tests**

In `user_settings_bloc_test.dart` (mirror the file's harness — `UserSettingsBloc()` direct build, `initHydratedStorage()` in `setUp`):

```dart
    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualFoodAdded adds a food with a generated id',
      build: () => UserSettingsBloc(),
      act: (bloc) => bloc.add(
        const UserSettingsEvent.usualFoodAdded(
          'Chicken, 1 oz', Nutrition(calories: 22, protein: 5),
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.usualFoods, hasLength(1));
        expect(bloc.state.usualFoods.single.name, equals('Chicken, 1 oz'));
      },
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualFoodNameChanged and usualFoodNutritionChanged edit in place',
      build: () => UserSettingsBloc(),
      seed: () => const UserSettingsState(
        usualFoods: [UsualFood(id: 'f1', name: 'Chicken', nutrition: Nutrition(calories: 22))],
      ),
      act: (bloc) => bloc
        ..add(const UserSettingsEvent.usualFoodNameChanged('f1', 'Chicken, 1 oz'))
        ..add(const UserSettingsEvent.usualFoodNutritionChanged('f1', Nutrition(calories: 25))),
      verify: (bloc) {
        expect(bloc.state.usualFoods.single.name, equals('Chicken, 1 oz'));
        expect(bloc.state.usualFoods.single.nutrition.calories, equals(25));
      },
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualFoodRemoved deletes by id',
      build: () => UserSettingsBloc(),
      seed: () => const UserSettingsState(
        usualFoods: [UsualFood(id: 'f1', name: 'Chicken')],
      ),
      act: (bloc) => bloc.add(const UserSettingsEvent.usualFoodRemoved('f1')),
      verify: (bloc) => expect(bloc.state.usualFoods, isEmpty),
    );

    test('saveAsUsualFood returns existing id for a duplicate name, else creates', () {
      final bloc = UserSettingsBloc();
      final firstId = bloc.saveAsUsualFood('Chicken, 1 oz', const Nutrition(calories: 22));
      final sameId = bloc.saveAsUsualFood('chicken, 1 oz', const Nutrition(calories: 99));
      expect(sameId, equals(firstId));
      expect(bloc.state.usualFoods, hasLength(1));
      final otherId = bloc.saveAsUsualFood('Rice, 100 g', const Nutrition(calories: 205));
      expect(otherId, isNot(equals(firstId)));
      expect(bloc.state.usualFoods, hasLength(2));
    });
```

In `user_settings_state_test.dart`:

```dart
    test('usualFoodCount counts the library', () {
      const state = UserSettingsState(
        usualFoods: [UsualFood(id: 'a', name: 'Chicken'), UsualFood(id: 'b', name: 'Rice')],
      );
      expect(state.usualFoodCount, equals(2));
    });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/user_settings/bloc/`
Expected: FAIL — the events / `saveAsUsualFood` / `usualFoodCount` don't exist.

- [ ] **Step 3: Add the events**

In `user_settings_event.dart`, after the `usualMeal*` events:

```dart
  const factory UserSettingsEvent.usualFoodAdded(
    String name,
    Nutrition nutrition, {
    String? id,
  }) = SettingsUsualFoodAdded;
  const factory UserSettingsEvent.usualFoodRemoved(String id) =
      SettingsUsualFoodRemoved;
  const factory UserSettingsEvent.usualFoodNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = SettingsUsualFoodNutritionChanged;
  const factory UserSettingsEvent.usualFoodNameChanged(String id, String name) =
      SettingsUsualFoodNameChanged;
```

- [ ] **Step 4: Add the switch cases, handlers, `saveAsUsualFood`, and `usualFoodCount`**

In `user_settings_bloc.dart`, add the four cases to the exhaustive switch and the handlers, mirroring the `usualMeal*` handlers but on the flat `usualFoods` list:

```dart
        SettingsUsualFoodAdded() => _onUsualFoodAdded(event, emit),
        SettingsUsualFoodRemoved() => emit(
          state.copyWith(
            usualFoods: state.usualFoods
                .where((usualFood) => usualFood.id != event.id)
                .toList(),
          ),
        ),
        SettingsUsualFoodNutritionChanged() => emit(
          state.copyWith(
            usualFoods: [
              for (final usualFood in state.usualFoods)
                if (usualFood.id == event.id)
                  usualFood.copyWith(nutrition: event.nutrition)
                else
                  usualFood,
            ],
          ),
        ),
        SettingsUsualFoodNameChanged() => _onUsualFoodNameChanged(event, emit),
```

```dart
  void _onUsualFoodAdded(
    SettingsUsualFoodAdded event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;
    final alreadyExists = state.usualFoods.any(
      (usualFood) => usualFood.name.toLowerCase() == name.toLowerCase(),
    );
    if (alreadyExists) return;
    emit(
      state.copyWith(
        usualFoods: [
          ...state.usualFoods,
          UsualFood(id: event.id ?? _uuid.v4(), name: name, nutrition: event.nutrition),
        ],
      ),
    );
  }

  void _onUsualFoodNameChanged(
    SettingsUsualFoodNameChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;
    emit(
      state.copyWith(
        usualFoods: [
          for (final usualFood in state.usualFoods)
            if (usualFood.id == event.id)
              usualFood.copyWith(name: name)
            else
              usualFood,
        ],
      ),
    );
  }

  /// Returns the id of the usual food whose name matches [name]
  /// (case-insensitive), creating one with [nutrition] when none exists.
  String saveAsUsualFood(String name, Nutrition nutrition) {
    final trimmed = name.trim();
    for (final usualFood in state.usualFoods) {
      if (usualFood.name.toLowerCase() == trimmed.toLowerCase()) {
        return usualFood.id;
      }
    }
    final id = _uuid.v4();
    add(UserSettingsEvent.usualFoodAdded(trimmed, nutrition, id: id));
    return id;
  }
```

In `user_settings_state.dart`, add near `usualMealCount`:

```dart
  /// The number of saved usual foods in the library.
  int get usualFoodCount => usualFoods.length;
```

- [ ] **Step 5: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/`
Expected: PASS (all, including pre-existing).

- [ ] **Step 6: Leave changes in the working tree (no commit)**

---

### Task 2: `UsualFoodsView` management screen + `UsualFoodList`

**Files:**
- Create: `lib/app/feature/user_settings/view/usual_foods_view.dart`
- Create: `lib/app/feature/user_settings/widgets/usual_food_list.dart`
- Modify: the feature's `view`/`widgets` barrel files to export them.
- Test: `test/app/feature/user_settings/view/usual_foods_view_test.dart`

**Interfaces:**
- Consumes: `UserSettingsBloc` events from Task 1, `UsualFood`, `ExpandableNutrition`, `FoodEntrySheet`, `ConfirmDialog`.
- Produces: `UsualFoodsView` (a `Scaffold` with an app bar titled "Usual foods", a `UsualFoodList` body, and a FAB that opens `FoodEntrySheet`). `UsualFoodList` (a `BlocSelector` on `usualFoods` rendering one editable card per food, or an empty-state message).

- [ ] **Step 1: Write the failing widget test**

Create `usual_foods_view_test.dart` (mirror `usual_meals_view_test.dart`'s harness — mock `UserSettingsBloc` via `getIt`, `pumpApp` or a `MaterialApp` host). Assert:

```dart
    testWidgets('renders an editable card per usual food', (tester) async {
      // seed mock UserSettingsBloc state with two usualFoods, pump UsualFoodsView
      expect(find.byType(ExpandableNutrition), findsNWidgets(2));
    });

    testWidgets('shows an empty state when the library is empty', (tester) async {
      // seed empty usualFoods
      expect(find.byType(ExpandableNutrition), findsNothing);
      // an empty-state Text is present (find by a Key('usualFoodsEmpty') you add)
      expect(find.byKey(const Key('usualFoodsEmpty')), findsOneWidget);
    });

    testWidgets('editing a food name dispatches usualFoodNameChanged', (tester) async {
      // enter text in the first card's name field
      verify(() => userSettingsBloc.add(
        any(that: isA<SettingsUsualFoodNameChanged>()),
      )).called(greaterThan(0));
    });

    testWidgets('the FAB is present to add a food', (tester) async {
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
```

(Use the exact mock/getIt/pump setup from `usual_meals_view_test.dart`.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/user_settings/view/usual_foods_view_test.dart`
Expected: FAIL — `UsualFoodsView` doesn't exist.

- [ ] **Step 3: Build `UsualFoodList`**

Create `usual_food_list.dart`: a `BlocSelector<UserSettingsBloc, UserSettingsState, (List<UsualFood>, bool)>` selecting `(state.usualFoods, state.expandNutritionByDefault)`. When empty, a centred empty-state `Text` keyed `const Key('usualFoodsEmpty')` ("No usual foods yet. Tap + to add one."). Otherwise a `ListView` of `Card`s (one per `usualFood`, keyed by id), each wrapping `ExpandableNutrition`:

```dart
ExpandableNutrition(
  name: usualFood.name,
  nutrition: usualFood.nutrition,
  expandedByDefault: expandNutritionByDefault,
  onNameChanged: (name) => getIt<UserSettingsBloc>()
      .add(UserSettingsEvent.usualFoodNameChanged(usualFood.id, name)),
  onChanged: (nutrition) => getIt<UserSettingsBloc>()
      .add(UserSettingsEvent.usualFoodNutritionChanged(usualFood.id, nutrition)),
  onRemoved: () async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Delete usual food?',
      message: 'This permanently deletes "${usualFood.name}". '
          'Meals you already built with it are unaffected.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed) return;
    getIt<UserSettingsBloc>().add(UserSettingsEvent.usualFoodRemoved(usualFood.id));
  },
)
```

Note `ExpandableNutrition` has no `quantity`, so no stepper — correct for a library food (per-unit nutrition only). Match the card padding/margins used in `usual_meal_section.dart`.

- [ ] **Step 4: Build `UsualFoodsView`**

Create `usual_foods_view.dart`: a `Scaffold` with an `AppBar(title: Text('Usual foods'))`, body `UsualFoodList`, and a `FloatingActionButton` whose `onPressed` opens the entry sheet and adds each result as a usual food:

```dart
onPressed: () async {
  final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
    context,
    builder: (context) => const FoodEntrySheet(
      title: 'Add a usual food',
      confirmLabel: 'Add',
      showQuantity: false,
    ),
  );
  if (result == null) return;
  for (final foodResult in result.foods) {
    getIt<UserSettingsBloc>()
        .add(UserSettingsEvent.usualFoodAdded(foodResult.name, foodResult.nutrition));
  }
},
```

Export both from the feature barrels.

- [ ] **Step 5: Run to verify pass**

Run: `fvm flutter test test/app/feature/user_settings/view/usual_foods_view_test.dart`
Expected: PASS.

- [ ] **Step 6: Leave changes in the working tree (no commit)**

---

### Task 3: Route + settings entry-point tile

**Files:**
- Modify: the routes constants file (where `Routes.usualMeals` / `Routes.usualMealsSegment` live) — add `usualFoods` / `usualFoodsSegment`.
- Modify: the app router (where the usuals `GoRoute` is defined) — add a `GoRoute` for `usualFoods` mounting `UsualFoodsView`, mirroring the usual-meals route nesting.
- Create: `lib/app/feature/user_settings/widgets/usual_foods_tile.dart` — mirror `usual_meals_tile.dart` (shows the count via a `BlocSelector` on `usualFoodCount`, `context.push(Routes.usualFoods)`).
- Modify: `lib/app/feature/user_settings/view/user_settings_view.dart` — add `UsualFoodsTile` in the "YOUR FOOD" section, next to `UsualMealsTile`.
- Modify: feature `widgets` barrel.
- Test: `test/app/feature/user_settings/view/user_settings_view_test.dart` (tile present + navigates) — mirror the usual-meals tile test if one exists.

**Interfaces:**
- Consumes: `Routes.usualFoods`, `UsualFoodsView`, `UserSettingsState.usualFoodCount`.
- Produces: a tile in settings that pushes the usual-foods route.

- [ ] **Step 1: Read the exact route + tile patterns**

Read the routes constants file and the app router for how `usualMeals` is declared and nested, and `usual_meals_tile.dart` for the tile pattern. Mirror them precisely (segment string `'usual-foods'`).

- [ ] **Step 2: Write the failing test**

In `user_settings_view_test.dart`, mirror the usual-meals-tile test (if present): assert a `UsualFoodsTile` renders and tapping it navigates to `Routes.usualFoods` (use the test's existing router/navigation-observer pattern; find the tile by type or a `Key`).

```dart
    testWidgets('tapping the usual foods tile navigates to the usual foods route', (tester) async {
      // pump settings, tap UsualFoodsTile, assert UsualFoodsView (or the route) is shown
    });
```

- [ ] **Step 3: Add the route**

Add `static const usualFoodsSegment = 'usual-foods';` and `static const usualFoods = '$usualMeals/...';` consistent with how `usualMeals` is built (match the existing nesting style — if `usualMeals` is `'/settings/usuals'` with segment `'usuals'`, add `usualFoods = '/settings/usual-foods'` with segment `'usual-foods'`). Add the matching `GoRoute(path: Routes.usualFoodsSegment, builder: (_, _) => const UsualFoodsView())` under the same parent as the usual-meals route.

- [ ] **Step 4: Add the tile + place it in settings**

Create `usual_foods_tile.dart` mirroring `usual_meals_tile.dart` (a `BlocSelector` on `usualFoodCount` for the subtitle/count, `onTap: () => context.push(Routes.usualFoods)`, title "Usual foods"). Add `UsualFoodsTile()` to the "YOUR FOOD" section in `user_settings_view.dart`, just after `UsualMealsTile`.

- [ ] **Step 5: Run to verify pass**

Run: `fvm flutter test test/app/feature/user_settings/view/user_settings_view_test.dart`
Expected: PASS.

- [ ] **Step 6: Leave changes in the working tree (no commit)**

---

### Task 4: Full-suite green + analyzer

- [ ] **Step 1: Run the user_settings + widgets suites with a random seed**

Run:
```bash
fvm flutter test test/app/feature/user_settings test/app/widgets --test-randomize-ordering-seed random
```
Expected: PASS apart from the known-unrelated pre-existing `usual_meal_list_test.dart` "edits and removes" failure (developer's ConfirmDialog WIP) — confirm it's the same one; do not fix it. Fix any genuine fallout from the new screen/route/tile.

- [ ] **Step 2: Analyzer clean on touched dirs**

Run: `fvm flutter analyze lib/app/feature/user_settings`
Expected: No errors (fix errors only).

- [ ] **Step 3: Leave changes in the working tree (no commit)**

---

## Self-Review

**Spec coverage (Phase 4a slice — the library as a first-class, manageable collection):**
- Usual foods CRUD + `saveAsUsualFood` → Task 1. ✓
- A management surface parallel to usual meals (flat) → Tasks 2, 3. ✓
- Reachable from settings → Task 3. ✓
- Deferred to Phase 4b (NOT gaps): `FoodDraft.usualFoodId` + setting the link, the food picker on "Add a food", per-food "save as a usual food", the "also update N meals" propagate prompt, and the composed-entry "update usual" footer. Stated in Key Decisions.

**Placeholder scan:** Task 1 carries complete event/handler code. Tasks 2–3 specify the widgets/route/tile with exact event wiring and reuse (`ExpandableNutrition`, `FoodEntrySheet`, `ConfirmDialog`, the mirrored route/tile) plus concrete test cases; the implementer reads the named usual-meals files to match structure.

**Type consistency:** `usualFoodAdded(String name, Nutrition nutrition, {String? id})`, `usualFoodRemoved(String id)`, `usualFoodNutritionChanged(String id, Nutrition)`, `usualFoodNameChanged(String id, String name)`, `saveAsUsualFood(String name, Nutrition) → String`, `usualFoodCount`, `Routes.usualFoods` — names are consistent across events, handlers, screen, tile, and route.
