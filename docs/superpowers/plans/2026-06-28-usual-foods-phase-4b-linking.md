# Usual Foods — Phase 4b: Linking meals to the library — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When building a meal by foods, the user can pick a food from their usual-foods library (pre-filled and linked) or save a typed food to the library (linked), so meal components carry a `usualFoodId` back to the library entry.

**Architecture:** Add `usualFoodId` to `FoodDraft` and thread it into the `MealComponent`s built at the two construction sites (the form's `results` getter and `ComposedMealFields._components`). Two new `FoodEntryBloc` events: `foodPicked(UsualFood)` adds a linked, pre-filled row; `foodSavedAsUsual(id, usualFoodId)` stamps the link onto an existing row after the widget saves it via `UserSettingsBloc.saveAsUsualFood`. The by-foods builder gains a per-food "save to library" affordance and a picker on "Add a food".

**Tech Stack:** Dart/Flutter, `flutter_bloc`, `freezed`, `flutter_test`, `bloc_test`, `mocktail`.

## Key implementation decisions (baked in)

1. **Snapshot semantics hold:** picking or saving a food sets the component's `usualFoodId` (the link), but the component still OWNS its name/nutrition copy. Editing the component's macros in the meal changes the copy, not the library food; the link stays so Phase 4c propagation can match. This matches the spec's snapshot+propagate design.
2. **"Add a food" opens a picker** (a bottom sheet listing the usual-foods library, each tappable, plus a "New food" option at the top that adds a blank row — today's behavior). Picking a food dispatches `foodPicked`. When the library is empty, the picker shows only "New food" (or the button adds a blank row directly).
3. **Per-food "save to library"** is an explicit action on each food row (an icon/text button, not a deferred checkbox): tapping it calls `UserSettingsBloc.saveAsUsualFood(name, nutrition)` and dispatches `foodSavedAsUsual(rowId, usualFoodId)` to stamp the link. A row that already has a `usualFoodId` shows a "saved/linked" state instead.
4. **Scope: linking only.** The propagate prompt ("also update N meals") and the composed-entry "update usual" footer are Phase 4c.

## Global Constraints

- **Do NOT `git commit`/`git push`, and do NOT commit.** Working tree on `main`; Jacob commits. Each task ends by leaving changes in the working tree.
- **Do NOT run `build_runner`.** Watcher regenerates `.freezed.dart`/`.g.dart`. If a test won't compile on a missing generated symbol, wait and re-run; else DONE_WITH_CONCERNS — never invoke codegen.
- **Use `fvm flutter`.** Barrel imports. Blocs via `getIt<T>()` in views. `@freezed` events; exhaustive `switch`.
- **Naming:** `usualFood`, `foodDraft`, `mealComponent`, full type names.
- Reuse `TheUsualBottomSheet`, `NutritionSummary`, design tokens. Tests: matchers; `blocTest`; `mocktail`; find widgets by type/key/icon; `--test-randomize-ordering-seed random`.
- **Facts:** `FoodDraft({required String id, String name = '', double quantity = 1, Nutrition nutrition = const Nutrition(), bool addToUsualMeals = false})` (in-memory only, NOT persisted — no migration concern). `UsualFood({required String id, required String name, Nutrition nutrition})`. `UserSettingsBloc.saveAsUsualFood(String name, Nutrition) → String id`. `MealComponent` has `usualFoodId` (Phase 1). `MealComponent` is built in (a) `food_entry_form.dart` `results` getter itemized branch and (b) `composed_meal_fields.dart` `_components` getter — both currently pass no `usualFoodId`.

---

## File Structure

- Modify: `lib/app/model/food_draft.dart` — add `usualFoodId`.
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_event.dart` + `meal_entry_bloc.dart` — `foodPicked`, `foodSavedAsUsual`.
- Modify: `lib/app/widgets/inputs/food_entry_form.dart` — thread `usualFoodId` into the `results` itemized `MealComponent`s; wire the picker + per-food save into `ComposedMealFields`.
- Modify: `lib/app/widgets/inputs/composed_meal_fields.dart` — thread `usualFoodId` into `_components`; per-food "save to library" affordance; "Add a food" opens the picker.
- Create: `lib/app/widgets/inputs/usual_food_picker_sheet.dart` — the bottom-sheet picker of library foods.
- Tests alongside.

---

### Task 1: `FoodDraft.usualFoodId` threaded into `MealComponent`

**Files:**
- Modify: `lib/app/model/food_draft.dart`
- Modify: `lib/app/widgets/inputs/food_entry_form.dart` (the `results` itemized `MealComponent` build)
- Modify: `lib/app/widgets/inputs/composed_meal_fields.dart` (the `_components` getter)
- Test: `test/app/model/food_draft_test.dart`, `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**
- Produces: `FoodDraft` gains `String? usualFoodId` (default null). Both `MealComponent` construction sites pass `usualFoodId: foodDraft.usualFoodId`.

- [ ] **Step 1: Write the failing tests**

In `food_draft_test.dart`, assert the field defaults null and round-trips via copyWith:

```dart
    test('usualFoodId defaults to null and is settable', () {
      const foodDraft = FoodDraft(id: 'd1');
      expect(foodDraft.usualFoodId, isNull);
      expect(foodDraft.copyWith(usualFoodId: 'f1').usualFoodId, equals('f1'));
    });
```

In `food_entry_form_test.dart`, extend a by-foods `results` test: seed the form's foods to include a draft with a `usualFoodId` (via the picker path is heavy — instead assert at the component level once Task 2/4 can set it; for THIS task, assert the plumbing by driving `results` with a linked draft if the harness allows, else assert the `_components`/`results` map passes it through). Minimal reliable test: a unit-style check that a `FoodDraft(usualFoodId: 'f1')` produces a `MealComponent(usualFoodId: 'f1')` through the form's results — if the form harness can seed foods with the field, assert `results.single.components.single.usualFoodId == 'f1'`.

(If seeding the bloc's foods with a `usualFoodId` from the widget test is impractical at this task, cover the threading with a focused test in Task 2 once `foodPicked` can create such a draft, and keep this task's test to the `FoodDraft` model only. Note which you did in the report.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/model/food_draft_test.dart`
Expected: FAIL — `usualFoodId` undefined.

- [ ] **Step 3: Add the field + thread it**

In `food_draft.dart`, add to the factory:

```dart
    String? usualFoodId,
```

In `food_entry_form.dart` `results` itemized branch and `composed_meal_fields.dart` `_components`, add to each `MealComponent(...)`:

```dart
      usualFoodId: foodDraft.usualFoodId,
```

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/model/food_draft_test.dart test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 2: `foodPicked` + `foodSavedAsUsual` events

**Files:**
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_event.dart` + `meal_entry_bloc.dart`
- Test: `test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`

**Interfaces:**
- Produces:
  - `MealEntryEvent.foodPicked(UsualFood usualFood) = MealEntryFoodPicked` → appends a `FoodDraft` with a fresh uuid, `name` = food.name, `nutrition` = food.nutrition, `quantity` 1, `usualFoodId` = food.id.
  - `MealEntryEvent.foodSavedAsUsual(String id, String usualFoodId) = MealEntryFoodSavedAsUsual` → stamps `usualFoodId` onto the row with `id` (via the existing `_mapFood`).

- [ ] **Step 1: Write the failing bloc tests**

In `meal_entry_bloc_test.dart` (reuse the harness):

```dart
    blocTest<FoodEntryBloc, MealEntryState>(
      'foodPicked appends a linked, pre-filled row',
      build: buildBloc,
      act: (bloc) => bloc.add(const MealEntryEvent.foodPicked(
        UsualFood(id: 'f1', name: 'Chicken, 1 oz', nutrition: Nutrition(calories: 22, protein: 5)),
      )),
      verify: (bloc) {
        final foodDraft = bloc.state.foods.last;
        expect(foodDraft.name, equals('Chicken, 1 oz'));
        expect(foodDraft.usualFoodId, equals('f1'));
        expect(foodDraft.nutrition.calories, equals(22));
      },
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodSavedAsUsual stamps the link onto the row',
      build: buildBloc,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'd1', name: 'Rice, 100 g')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodSavedAsUsual('d1', 'f2')),
      expect: () => [isA<MealEntryState>().having(
        (s) => s.foods.single.usualFoodId, 'usualFoodId', 'f2')],
    );
```

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: FAIL — events undefined.

- [ ] **Step 3: Add the events + handlers**

In `meal_entry_event.dart`:

```dart
  const factory MealEntryEvent.foodPicked(UsualFood usualFood) =
      MealEntryFoodPicked;
  const factory MealEntryEvent.foodSavedAsUsual(String id, String usualFoodId) =
      MealEntryFoodSavedAsUsual;
```

In `meal_entry_bloc.dart`, add the cases to the exhaustive switch:

```dart
        MealEntryFoodPicked() => emit(
          state.copyWith(
            foods: [
              ...state.foods,
              FoodDraft(
                id: _uuid.v4(),
                name: event.usualFood.name,
                nutrition: event.usualFood.nutrition,
                usualFoodId: event.usualFood.id,
              ),
            ],
          ),
        ),
        MealEntryFoodSavedAsUsual() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(usualFoodId: event.usualFoodId),
            ),
          ),
        ),
```

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 3: Per-food "save to library" in the by-foods builder

**Files:**
- Modify: `lib/app/widgets/inputs/composed_meal_fields.dart` (the per-food row) + `lib/app/widgets/inputs/food_entry_form.dart` (the callback that calls `saveAsUsualFood` + dispatches `foodSavedAsUsual`)
- Test: `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**
- Consumes: `UserSettingsBloc.saveAsUsualFood`, `MealEntryEvent.foodSavedAsUsual`, the row's current name/nutrition.
- Produces: each composed food row has a "Save to library" action (icon/text button). Tapping it (when the row has a non-empty name) calls `getIt<UserSettingsBloc>().saveAsUsualFood(name, nutrition)` and dispatches `foodSavedAsUsual(rowId, id)`. A row whose `usualFoodId` is already set shows a non-interactive "linked" indicator instead.

- [ ] **Step 1: Write the failing widget test**

In `food_entry_form_test.dart` (by-foods mode, mock `UserSettingsBloc.saveAsUsualFood` returning an id):

```dart
    testWidgets('tapping save-to-library on a food saves it and links the row', (tester) async {
      when(() => userSettingsBloc.saveAsUsualFood(any(), any())).thenReturn('f9');
      // switch to By foods, enter a food name + macros, tap the row's save-to-library action
      verify(() => userSettingsBloc.saveAsUsualFood('Chicken, 1 oz', any())).called(1);
      // and a foodSavedAsUsual was dispatched onto the FoodEntryBloc (assert via the row now showing linked state, or that components carry usualFoodId in results)
    });
```

(Use the file's existing by-foods harness from Phase 2a/3; find the save action by an `Icon` (e.g. `Icons.bookmark_add_outlined`) or a `Key`.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: FAIL — no save-to-library action.

- [ ] **Step 3: Add the per-food save affordance**

In `ComposedMealFields`'s food row, add an action button (icon `Icons.bookmark_add_outlined` with tooltip "Save to library", or a small text button). Plumb a new callback `onFoodSaveToLibrary(String id)` up to `FoodEntryForm`, which:

```dart
onFoodSaveToLibrary: (id) {
  final foodDraft = _bloc.state.foods.firstWhere((f) => f.id == id);
  final name = foodDraft.name.trim();
  if (name.isEmpty) return;
  final usualFoodId =
      getIt<UserSettingsBloc>().saveAsUsualFood(name, foodDraft.nutrition);
  _bloc.add(MealEntryEvent.foodSavedAsUsual(id, usualFoodId));
},
```

When `foodDraft.usualFoodId != null`, render a non-interactive "linked" indicator (e.g. a filled `Icons.bookmark` or a small "In library" label) instead of the save button.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 4: Food picker on "Add a food"

**Files:**
- Create: `lib/app/widgets/inputs/usual_food_picker_sheet.dart`
- Modify: `lib/app/widgets/inputs/composed_meal_fields.dart` (the "Add a food" button) + `lib/app/widgets/inputs/food_entry_form.dart` (open the picker, dispatch `foodPicked` or `foodAdded`)
- Modify: inputs widgets barrel.
- Test: `test/app/widgets/usual_food_picker_sheet_test.dart` (+ a by-foods builder test that "Add a food" opens it)

**Interfaces:**
- Consumes: `UserSettingsState.usualFoods`, `MealEntryEvent.foodPicked`, `MealEntryEvent.foodAdded`.
- Produces: `UsualFoodPickerSheet` — a `TheUsualBottomSheet` listing each `UsualFood` (name + `NutritionSummary`) tappable, plus a "New food" option that returns a sentinel. Pops with the chosen `UsualFood?` (null = cancel) or a "new" signal. `ComposedMealFields`' "Add a food" opens it: a picked food → `foodPicked(usualFood)`; "New food" → `foodAdded` (today's blank row).

- [ ] **Step 1: Write the failing tests**

`usual_food_picker_sheet_test.dart`: pump the sheet with a seeded `usualFoods` list; assert one tappable row per food (by type/key) and a "New food" option (by `Key('pickerNewFood')`); tapping a food pops that `UsualFood`.

In the by-foods builder test: tapping "Add a food" shows a `UsualFoodPickerSheet`.

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/widgets/usual_food_picker_sheet_test.dart`
Expected: FAIL — the sheet doesn't exist.

- [ ] **Step 3: Build the picker + wire it**

Create `usual_food_picker_sheet.dart`: a `TheUsualBottomSheet` titled "Add a food" whose body is a `ListView` — a leading "New food" `ListTile` keyed `const Key('pickerNewFood')` (pops a `_NewFood` sentinel / returns null-with-a-flag), then one `ListTile` per usual food (title = name, subtitle = `NutritionSummary(usualFood.nutrition)`) that pops that `UsualFood`. Read foods via `getIt<UserSettingsBloc>().state.usualFoods` (or a `BlocSelector`). To distinguish "picked a food" vs "new food" vs "cancel", return a small result type or use `Navigator.pop(usualFood)` for a pick and a distinct sentinel for "new".

In `ComposedMealFields`' "Add a food", open the sheet; on a picked `UsualFood` dispatch `MealEntryEvent.foodPicked(usualFood)`; on "New food" dispatch the existing `MealEntryEvent.foodAdded(...)`. Export the sheet from the inputs barrel.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/widgets/usual_food_picker_sheet_test.dart test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 5: Full-suite green + analyzer

- [ ] **Step 1: Run the affected suites with a random seed**

Run:
```bash
fvm flutter test test/app/model test/app/widgets test/app/feature/meal_entry --test-randomize-ordering-seed random
```
Expected: PASS (apart from any known-unrelated pre-existing failure — confirm it's the same `usual_meal_list_test.dart` one and unrelated). Fix genuine fallout.

- [ ] **Step 2: Analyzer clean on touched dirs**

Run: `fvm flutter analyze lib/app/widgets/inputs lib/app/feature/meal_entry lib/app/model`
Expected: No errors.

- [ ] **Step 3: Leave changes in the working tree (no commit)**

---

## Self-Review

**Spec coverage (Phase 4b slice — meals consume/link the library):**
- `usualFoodId` link on components → Task 1. ✓
- Pick a library food into a meal (linked) → Tasks 2, 4. ✓
- Save a typed food to the library (linked) → Tasks 2, 3. ✓
- Snapshot semantics preserved (link without losing the owned copy) → Key Decisions + Task 1. ✓
- Deferred to Phase 4c (NOT gaps): the "also update N meals" propagate prompt on a usual-food edit, and the composed-entry "update usual" footer. Stated in Key Decisions.

**Placeholder scan:** Tasks 1–2 carry complete model/event/handler code. Tasks 3–4 specify the widget affordance + picker structure with exact event wiring, reused widgets, and concrete test cases.

**Type consistency:** `FoodDraft.usualFoodId` (String?), `MealEntryEvent.foodPicked(UsualFood)`, `MealEntryEvent.foodSavedAsUsual(String id, String usualFoodId)`, `saveAsUsualFood(name, nutrition) → String`, `MealComponent.usualFoodId` — names consistent across model, events, handlers, builder, and picker.
