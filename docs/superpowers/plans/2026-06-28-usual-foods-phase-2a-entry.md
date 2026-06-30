# Usual Foods — Phase 2a: By-foods entry + composed-meal logging — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "By foods" mode to the meal-entry form that builds one composed meal (a name plus component foods with steppers and a live total), have the AI itemize into base-unit components, and log/save that composed meal through the primary Today "Something New" path.

**Architecture:** Reuse the existing `MealEntryMode` (`wholeMeal` | `itemized`) as the form's "Whole meal / By foods" toggle. Whole-meal mode is today's behavior unchanged (flat rows, each row → its own independent entry) minus the removed itemize checkbox. By-foods mode renders a composed builder: one meal-name field plus a list of component rows, producing a single `FoodEntryResult` carrying `components`. `FoodEntryResult` keeps being a `List<...>` so callers' per-result loops stay intact; whole-meal yields N results with empty `components`, by-foods yields one result with `components`. The logging events (`MealLogged`, `saveAsUsualMeal`, `usualMealAdded`) gain an additive `components` parameter.

**Tech Stack:** Dart/Flutter, `flutter_bloc`, `freezed`, `injectable`, `schemantic` (AI JSON schema), `flutter_test`, `bloc_test`, `mocktail`.

## Key implementation decisions (baked into this plan)

1. **The toggle IS `MealEntryMode`.** `itemized` == "By foods"; `wholeMeal` == "Whole meal". No new enum. The itemize checkbox in `food_entry_form.dart` is replaced by a `SegmentedButton<MealEntryMode>`.
2. **`FoodEntryResult` stays a list element; gains `components`.** Whole-meal builds one result per named row with `components: const []`. By-foods builds exactly one result: `name` = meal name, `nutrition` = the components' total (one serving), `quantity` = 1, `components` = the rows.
3. **Per-food "Save as a usual food" (library write) and the food picker are DEFERRED to the Phase 4 library work** — they have no payoff without a browse/reuse surface, and Phase 2a's goal is editable composition. The `usualFoods` field from Phase 1 stays unused until then. The by-foods per-food editor in 2a edits name/quantity/macros only.
4. **Composed display in the Today log (the inline expand-to-tweak interaction) is Phase 3.** In 2a, a logged composed meal renders with today's `LoggedEntryRow` (name + summed nutrition); its `components` persist but aren't shown/expanded yet. That is expected, not a gap.
5. **Scope is the Today "Something New" path only** (`meal_log_section.dart`). Onboarding (build-usuals, first-log), settings "Add meal", and share-to-log migrate in Phase 2b.

## Global Constraints

- **Do NOT run `git commit`/`git push`, and do NOT commit.** Work accumulates in the working tree on `main`; Jacob commits. Each task ends by leaving changes in the working tree (no `git add`/commit). (Global rule + this project's established SDD convention.)
- **Do NOT run `build_runner`.** A background watcher regenerates `.freezed.dart`/`.g.dart`. If a test fails to compile on a missing generated symbol, wait a few seconds and re-run; if still missing, report DONE_WITH_CONCERNS — never invoke codegen.
- **Use `fvm flutter`** for all Flutter CLI commands.
- **Barrel imports:** `package:the_usual/app/app.dart` in tests and feature code; design tokens via `package:the_usual/design_system/design_system.dart`.
- **Models/states/events are `@freezed`.** Use exhaustive `switch` in `on<Event>`. Wrap async bloc handlers in try-catch, emitting loading→success/failure.
- **Views get blocs via `getIt<T>()`, not `context.read`.** Prefer `BlocSelector` over `BlocBuilder`; select multiple values with a record.
- **Naming:** variables named after their full model type (`mealComponent`, `mealLogEntry`, `foodDraft`, `mealOfTheDay`).
- **Responsive:** `context.layout`/`isMobile` if needed; reuse `AppDesign.spacing`/`radius` tokens, never hardcoded values.
- **Tests:** matchers not raw asserts; `blocTest` for blocs; `mocktail` for mocks; locate widgets by type/key/icon, NOT by UI strings; `initHydratedStorage()` in HydratedBloc tests; run with `--test-randomize-ordering-seed random`.
- **`MealComponent`** (from Phase 1) = `{required String name, Nutrition nutrition = const Nutrition(), double quantity = 1, String? usualFoodId}` with `Nutrition get scaledNutrition => nutrition * quantity`. `List<MealComponent>.componentsTotal` sums `scaledNutrition`.

---

## File Structure

- Modify: `lib/app/feature/today/bloc/daily_log_event.dart` + `daily_log_bloc.dart` — `MealLogged` gains `components`.
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart` (+ `user_settings_event.dart`) — `usualMealAdded` and `saveAsUsualMeal` gain `components`.
- Modify: `lib/app/widgets/inputs/food_entry_form.dart` — the `FoodEntryResult` typedef (+`components`), the toggle, the by-foods builder, the `results` getter.
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart` (+ `meal_entry_state.dart`, `meal_entry_event.dart`) — `mealName` state + `mealNameChanged` event + by-foods estimate assembly.
- Modify: `lib/app/core/networking/repository/meal_ai_repository.dart` — base-unit normalization wording for itemized mode.
- Modify: `lib/app/widgets/inputs/food_entry_sheet.dart` — confirm wiring stays correct for composed results.
- Modify: `lib/app/feature/today/widgets/meal_log_section.dart` — pass `components` when logging/saving.
- New widget (private, in `food_entry_form.dart` or a sibling file if the file exceeds ~250 lines): the by-foods composed builder body.
- Tests alongside each.

---

### Task 1: `MealLogged` and usual-meal save events accept `components`

**Files:**

- Modify: `lib/app/feature/today/bloc/daily_log_event.dart` (the `MealLogged` factory)
- Modify: `lib/app/feature/today/bloc/daily_log_bloc.dart` (the `_onMealLogged` handler that builds the `MealLogEntry`)
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart` (`SettingsUsualMealAdded`)
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart` (`usualMealAdded` handler + `saveAsUsualMeal` method)
- Test: `test/app/feature/today/bloc/daily_log_bloc_test.dart`, `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`

**Interfaces:**

- Consumes: `MealComponent`, `List<MealComponent>.componentsTotal` (Phase 1).
- Produces:
  - `DailyLogEvent.mealLogged(... , {List<MealComponent> components = const []})` → the built `MealLogEntry` carries `components`.
  - `UserSettingsEvent.usualMealAdded(MealOfTheDay, String name, {Nutrition nutrition, String? id, List<MealComponent> components})`.
  - `UserSettingsBloc.saveAsUsualMeal(MealOfTheDay, String name, Nutrition nutrition, {List<MealComponent> components = const []}) → String` (the usual meal id).

- [ ] **Step 1: Read the current shapes**

Read `daily_log_event.dart`, the `_onMealLogged` (or equivalent `MealLogged` handler) in `daily_log_bloc.dart`, `user_settings_event.dart` (`SettingsUsualMealAdded`), and `saveAsUsualMeal` + the `usualMealAdded` handler in `user_settings_bloc.dart`. Note the exact current parameter lists so you only ADD an optional `components`.

- [ ] **Step 2: Write the failing tests**

In `daily_log_bloc_test.dart`, add a `blocTest` (inside the existing top-level group) asserting a logged composed meal keeps its components:

```dart
    blocTest<DailyLogBloc, DailyLogState>(
      'mealLogged stores components on the entry',
      build: () => DailyLogBloc(),
      act: (bloc) => bloc.add(
        const DailyLogEvent.mealLogged(
          MealOfTheDay.lunch,
          'Chicken & rice bowl',
          nutrition: Nutrition(calories: 293),
          components: [
            MealComponent(
              name: 'Chicken, 1 oz',
              nutrition: Nutrition(calories: 22, protein: 5),
              quantity: 4,
            ),
          ],
        ),
      ),
      verify: (bloc) {
        expect(bloc.state.mealEntries, hasLength(1));
        expect(bloc.state.mealEntries.single.components, hasLength(1));
        expect(
          bloc.state.mealEntries.single.components.single.name,
          equals('Chicken, 1 oz'),
        );
      },
    );
```

(Match the existing `DailyLogBloc` test's construction — if those tests build the bloc with a constructor or `getIt`, mirror that exactly.)

In `user_settings_bloc_test.dart`, add a `blocTest` that `usualMealAdded` with components stores them, and a plain test that `saveAsUsualMeal` with components returns an id and the stored usual carries the components:

```dart
    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualMealAdded stores components on the usual meal',
      build: () => UserSettingsBloc(),
      act: (bloc) => bloc.add(
        const UserSettingsEvent.usualMealAdded(
          MealOfTheDay.lunch,
          'Chicken & rice bowl',
          nutrition: Nutrition(calories: 293),
          components: [
            MealComponent(name: 'Chicken, 1 oz', quantity: 4),
          ],
        ),
      ),
      verify: (bloc) {
        final usualMeals = bloc.state.usuals[MealOfTheDay.lunch]!;
        expect(usualMeals.single.components, hasLength(1));
      },
    );

    test('saveAsUsualMeal stores components and returns the id', () {
      final bloc = UserSettingsBloc();
      final id = bloc.saveAsUsualMeal(
        MealOfTheDay.lunch,
        'Chicken & rice bowl',
        const Nutrition(calories: 293),
        components: const [MealComponent(name: 'Chicken, 1 oz', quantity: 4)],
      );
      final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!
          .firstWhere((usualMeal) => usualMeal.id == id);
      expect(usualMeal.components, hasLength(1));
    });
```

(Match how the existing `user_settings_bloc_test.dart` builds the bloc, including `initHydratedStorage()` in `setUp` if it uses HydratedBloc storage.)

- [ ] **Step 3: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`
Expected: FAIL — `No named parameter with the name 'components'`.

- [ ] **Step 4: Add `components` to the event + handler (DailyLog)**

In `daily_log_event.dart`, add to the `MealLogged` factory (after the existing optional params, matching its style):

```dart
    @Default(<MealComponent>[]) List<MealComponent> components,
```

In `daily_log_bloc.dart`, in the handler that constructs the `MealLogEntry` from a `MealLogged` event, pass the components through:

```dart
      components: event.components,
```

(Add it to the `MealLogEntry(...)` construction; leave every other field as-is.)

- [ ] **Step 5: Add `components` to the usual-meal save paths (UserSettings)**

In `user_settings_event.dart`, add to `SettingsUsualMealAdded`:

```dart
    @Default(<MealComponent>[]) List<MealComponent> components,
```

In `user_settings_bloc.dart`:

- In the `usualMealAdded` handler, pass `components: event.components` into the `UsualMeal(...)` it builds.
- In `saveAsUsualMeal`, add `{List<MealComponent> components = const <MealComponent>[]}` to the signature and pass it into the `UsualMeal(...)` created for a new usual. (When it finds an EXISTING usual by name, keep today's behavior — return that id unchanged; do not mutate its components in this task.)

- [ ] **Step 6: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`
Expected: PASS, including all pre-existing tests.

- [ ] **Step 7: Leave changes in the working tree (no commit)**

---

### Task 2: `FoodEntryResult` carries `components`

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_form.dart` (the `FoodEntryResult` typedef + the `results` getter + the `initialFoods` → `FoodDraft` seeding)
- Test: `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**

- Produces: `FoodEntryResult = ({String name, Nutrition nutrition, double quantity, bool addToUsualMeals, List<MealComponent> components})`. Whole-meal mode yields results with `components: const <MealComponent>[]`.

- [ ] **Step 1: Write/extend the failing test**

In `food_entry_form_test.dart`, extend the existing "reads entered rows as results" style test (or add one) to assert whole-meal results carry empty `components`:

```dart
    expect(formKey.currentState!.results.first.components, isEmpty);
```

Any existing test or helper that CONSTRUCTS a `FoodEntryResult` literal (e.g. in `initialFoods:`) will now need the `components` field — update those constructions to include `components: const []`. Find them by compiling.

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: FAIL — record literal missing `components`, or the new assertion failing.

- [ ] **Step 3: Add `components` to the typedef and the results getter**

In `food_entry_form.dart`, extend the typedef:

```dart
typedef FoodEntryResult = ({
  String name,
  Nutrition nutrition,
  double quantity,
  bool addToUsualMeals,
  List<MealComponent> components,
});
```

In the `results` getter, add `components: const <MealComponent>[]` to each built record (whole-meal rows have no components). Update the `initialFoods` → `FoodDraft` seeding only if it reads `food.components` (it does not need to; `FoodDraft` has no components — leave seeding as-is).

Update any other `FoodEntryResult` construction in `lib/` flagged by the compiler to pass `components: const []`.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 3: `mealName` state + event for the by-foods builder

**Files:**

- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_state.dart` (add `mealName`)
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_event.dart` (add `mealNameChanged`)
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart` (handle it; seed it in `_onStarted`)
- Test: `test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart` (create if absent; otherwise extend)

**Interfaces:**

- Produces: `MealEntryState.mealName` (`String`, default `''`); `MealEntryEvent.mealNameChanged(String mealName)` → `MealEntryMealNameChanged`. Used only by the by-foods builder; whole-meal ignores it.

- [ ] **Step 1: Write the failing bloc test**

In a `meal_entry_bloc_test.dart` (mirror an existing bloc test's harness — `FoodEntryBloc` is `@injectable`, constructed with a mock `MealAiRepository` and a `UserSettingsBloc`; check how other tests build it, likely via `getIt` after DI setup or direct construction with mocks):

```dart
    blocTest<FoodEntryBloc, MealEntryState>(
      'mealNameChanged updates the meal name',
      build: buildBloc, // your harness helper
      act: (bloc) => bloc.add(const MealEntryEvent.mealNameChanged('Bowl')),
      expect: () => [isA<MealEntryState>().having((s) => s.mealName, 'mealName', 'Bowl')],
    );
```

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: FAIL — `mealName`/`mealNameChanged` undefined.

- [ ] **Step 3: Add the field, event, and handler**

In `meal_entry_state.dart`, add to the factory:

```dart
    @Default('') String mealName,
```

In `meal_entry_event.dart`, add:

```dart
  const factory MealEntryEvent.mealNameChanged(String mealName) =
      MealEntryMealNameChanged;
```

In `meal_entry_bloc.dart`, add the case to the exhaustive switch:

```dart
        MealEntryMealNameChanged() => emit(
          state.copyWith(mealName: event.mealName),
        ),
```

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 4: AI itemize normalizes to base-unit foods (prompt + schema wording)

**Files:**

- Modify: `lib/app/core/networking/repository/meal_ai_repository.dart` (the `_itemizedGrouping` and item-name/quantity wording)
- Test: there is no live-AI test; assert the prompt/rule text the repository sends. Add/extend `test/app/core/networking/repository/meal_ai_repository_test.dart` if a seam exists; otherwise assert via a `MealAiClient` mock capturing the `prompt` argument.

**Interfaces:**

- Consumes/produces: no signature change. `suggestFromDescription`/`suggestFromPhoto` still return `List<AiMealSuggestion>`; itemized mode's prompt now instructs base-unit normalization.

- [ ] **Step 1: Write the failing test**

If `MealAiClient` is injected and mockable, add a test that captures the prompt for itemized mode and asserts it instructs single-unit base foods. Example (mock `MealAiClient`, capture `generateStructured`'s `prompt`):

```dart
    test('itemized description prompt asks for single-unit base foods', () async {
      final client = MockMealAiClient();
      when(() => client.isConfigured).thenReturn(true);
      when(() => client.generateStructured(
            prompt: any(named: 'prompt'),
            outputSchema: any(named: 'outputSchema'),
            images: any(named: 'images'),
          )).thenAnswer((_) async => <AiMealSuggestion>[]);
      final repository = MealAiRepository(client);

      await repository.suggestFromDescription('4 oz chicken, rice',
          mode: MealEntryMode.itemized);

      final captured = verify(() => client.generateStructured(
            prompt: captureAny(named: 'prompt'),
            outputSchema: any(named: 'outputSchema'),
            images: any(named: 'images'),
          )).captured.single as String;
      expect(captured.toLowerCase(), contains('single unit'));
      expect(captured.toLowerCase(), contains('quantity'));
    });
```

(If `MealAiClient` is hard to mock — e.g. concrete `@singleton` with no interface — register a mock via the existing test DI pattern other repository tests use, or skip the seam and instead assert the static rule string is referenced. Prefer the mock-capture approach.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/core/networking/repository/meal_ai_repository_test.dart`
Expected: FAIL — current `_itemizedGrouping` doesn't say "single unit"/normalize portions.

- [ ] **Step 3: Reword `_itemizedGrouping` for base-unit normalization**

Replace `_itemizedGrouping` so the AI returns one base-unit food per distinct food and moves portion magnitude into quantity:

```dart
  static const String _itemizedGrouping =
      'Break the meal into its individual foods and return one item per '
      'distinct food. For each food, return the nutrition of ONE BASE UNIT and '
      'set quantity to how many of that unit there are, so a portion is '
      'expressed as a base unit times a count. Normalise an amount into a base '
      'unit named with that unit: "4 oz chicken" becomes the food "Chicken, '
      '1 oz" with quantity 4; "200g rice" becomes "Rice, 50 g" with quantity 4 '
      'or "Rice, 1 g" with quantity 200, preferring a natural serving size for '
      'the base unit. A countable food keeps its count: "5 strips of bacon" is '
      'the food "Bacon, 1 strip" with quantity 5.';
```

Keep `_wholeMealGrouping`, `_shortNameRule`, `_photoPortionInName`, and `_valueRules` unchanged.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/core/networking/repository/meal_ai_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 5: By-foods estimate assembly in `FoodEntryBloc`

**Files:**

- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart` (the itemized branch of `_onEstimateRequested`/`_runPhotoEstimate`)
- Test: `test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`

**Interfaces:**

- Consumes: `MealAiRepository.suggestFromDescription/suggestFromPhoto`, `MealEntryMode`.
- Produces: in `itemized` (By foods) mode, an estimate fills the component rows (`state.foods` become the components) AND sets `state.mealName` from the user's typed description when present; in `wholeMeal` mode behavior is unchanged.

- [ ] **Step 1: Write the failing bloc test**

With a mock `MealAiRepository` returning two suggestions for an itemized description, assert the rows become those two foods and `mealName` is the typed description:

```dart
    blocTest<FoodEntryBloc, MealEntryState>(
      'itemized estimate fills component rows and keeps the meal name',
      build: () {
        when(() => mealAiRepository.isConfigured).thenReturn(true);
        when(() => mealAiRepository.suggestFromDescription(any(), mode: MealEntryMode.itemized))
            .thenAnswer((_) async => const [
                  AiMealSuggestion(name: 'Chicken, 1 oz', quantity: 4,
                      nutrition: Nutrition(calories: 22, protein: 5)),
                  AiMealSuggestion(name: 'Rice, cup', quantity: 1,
                      nutrition: Nutrition(calories: 205, carbs: 45)),
                ]);
        return buildBloc();
      },
      seed: () => const MealEntryState(
        mealEntryMode: MealEntryMode.itemized,
        mealName: 'Chicken & rice bowl',
        foods: [FoodDraft(id: 'seed', name: 'chicken and rice')],
      ),
      act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
      expect: () => [
        isA<MealEntryState>().having((s) => s.isGenerating, 'generating', isTrue),
        isA<MealEntryState>()
            .having((s) => s.foods.length, 'rows', 2)
            .having((s) => s.mealName, 'mealName', 'Chicken & rice bowl'),
      ],
    );
```

(Use the file's existing harness names for `mealAiRepository`/`buildBloc`; if a `mealName` isn't seeded, the bloc should set it from the single typed row's text — verify whichever path your harness exercises.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: FAIL — itemized estimate currently replaces rows but doesn't set `mealName`, and (pre-Task) the multi-row path estimates each row independently rather than treating the itemized result as the meal's components.

- [ ] **Step 3: Implement by-foods assembly**

In `_onEstimateRequested`, when `state.mealEntryMode == MealEntryMode.itemized`, treat the typed text (single named row, or the existing `mealName`) as the meal description, call `suggestFromDescription(..., mode: itemized)`, set `state.foods` to one `FoodDraft` per returned suggestion (name/quantity/nutrition), and set `state.mealName` to the typed description when `mealName` is empty. Keep the `wholeMeal` path exactly as today (single row split; multi-row estimate-each-in-place). For photos in itemized mode, do the same assembly in `_runPhotoEstimate` using `suggestFromPhoto(..., mode: itemized)`.

Reuse the existing `_foodsFromSuggestions` helper to build the rows (it already maps suggestions → `FoodDraft`s); add the `mealName` assignment in the emit.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS, all pre-existing bloc tests included.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 6: The "Whole meal / By foods" toggle replaces the itemize checkbox

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_form.dart` (the AI assist row)
- Test: `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**

- Consumes: `MealEntryMode`, `MealEntryEvent.entryModeToggled`.
- Produces: a `SegmentedButton<MealEntryMode>` with "Whole meal" (`wholeMeal`) and "By foods" (`itemized`) segments, dispatching `entryModeToggled`. The old `Checkbox`+`Text('Itemize')`+`Tooltip` are removed.

- [ ] **Step 1: Write the failing widget test**

Assert the segmented toggle exists and tapping "By foods" dispatches the mode change (find by `SegmentedButton<MealEntryMode>` type, not text where possible; the segment labels come from `MealEntryMode.label`, so update those labels in Task — see note). A robust finder:

```dart
    expect(find.byType(SegmentedButton<MealEntryMode>), findsOneWidget);
```

And assert the old itemize `Checkbox` paired with the info tooltip is gone (e.g. no `Icons.info_outline` in the AI row, or no `SegmentedButton` previously → now present). Keep assertions structural.

Also update `MealEntryMode.wholeMeal.label`/`itemized.label` if you want the segment text to read "Whole meal"/"By foods" — the enum currently has `'One meal'`/`'Itemize'`. Update those two `label` strings to `'Whole meal'` and `'By foods'` in `meal_entry_mode.dart` (the `summary`/`detail` may stay; they're no longer shown if the tooltip is removed — leave them, they're harmless, or trim in Task 9 cleanup).

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: FAIL — no `SegmentedButton<MealEntryMode>`.

- [ ] **Step 3: Replace the checkbox with the segmented toggle**

In `food_entry_form.dart`, replace the `Checkbox`/`Text('Itemize')`/`Tooltip` cluster in the AI assist row with:

```dart
SegmentedButton<MealEntryMode>(
  showSelectedIcon: false,
  segments: [
    for (final mealEntryMode in MealEntryMode.values)
      ButtonSegment(value: mealEntryMode, label: Text(mealEntryMode.label)),
  ],
  selected: {state.mealEntryMode},
  onSelectionChanged: isGenerating
      ? null
      : (selection) =>
          _bloc.add(MealEntryEvent.entryModeToggled(selection.first)),
),
```

Place it so it reads well above the Estimate/Photo buttons or beside them; if the AI row gets crowded, move the toggle to its own line above the buttons. Update `meal_entry_mode.dart` labels to `'Whole meal'` / `'By foods'`.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 7: The by-foods composed builder body + composed `results`

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_form.dart` — render the by-foods body when `mealEntryMode == itemized`, and produce a single composed `FoodEntryResult` from `results` in that mode. If the file exceeds ~250 lines after this, extract the by-foods body into `lib/app/widgets/inputs/composed_meal_fields.dart` (a private-to-feature widget) and export via the widgets barrel.
- Test: `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**

- Consumes: `MealEntryState.mealName`/`foods`, `MealComponent`, `List<MealComponent>.componentsTotal`, `QuantityStepper`, `NutritionFields`, `NutritionSummary`.
- Produces: in `itemized` mode, `FoodEntryFormState.results` returns a single-element list: one `FoodEntryResult` with `name` = `mealName` (fallback to a sensible default if empty), `nutrition` = `components.componentsTotal`, `quantity` = 1, `addToUsualMeals` = the form's save-as-usual choice, `components` = a `MealComponent` per named row (`name`, `nutrition`, `quantity`; `usualFoodId: null` in 2a). In `wholeMeal` mode, `results` is unchanged (one per named row, empty components).

- [ ] **Step 1: Write the failing widget test**

Drive the form in by-foods mode: switch the toggle to "By foods", enter a meal name, ensure two component rows with names/macros, then read `results`:

```dart
    // after switching to By foods, entering a meal name, and two component rows
    final results = formKey.currentState!.results;
    expect(results, hasLength(1));
    expect(results.single.name, equals('Chicken & rice bowl'));
    expect(results.single.components, hasLength(2));
    expect(results.single.nutrition, equals(results.single.components.componentsTotal));
```

Also assert the builder renders a meal-name field and a per-row `QuantityStepper` (by type), and a total readout (a `NutritionSummary` of the components total).

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: FAIL — by-foods body/`results` branch not implemented.

- [ ] **Step 3: Implement the by-foods body and `results` branch**

When `state.mealEntryMode == MealEntryMode.itemized`, render (instead of the flat whole-meal rows):

1. A meal-name `TheUsualTextField` bound to `mealName` (dispatch `mealNameChanged`).
2. A `FOODS` section: one compact row per `FoodDraft` — name field, a `QuantityStepper` (dispatch `foodQuantityChanged`), and a per-row `NutritionFields` revealed on tap (reuse `ExpandableNutrition` or an inline expander; for 2a an always-visible dense `NutritionFields` under each row is acceptable if expand-on-tap is more work — keep it dense). A remove control when `foods.length > 1`. An "Add a food" button (`foodAdded`).
3. A read-only meal-total line: `DefaultTextStyle.merge(... NutritionSummary(components.componentsTotal))`, where `components` is built from the current `foods`.

Add a private helper on the state/widget to build `List<MealComponent>` from `state.foods` (named rows only): `name`, `nutrition`, `quantity`, `usualFoodId: null`.

In `results`, branch on `_bloc.state.mealEntryMode`:

- `wholeMeal`: today's behavior (unchanged).
- `itemized`: return `[(name: mealName-or-fallback, nutrition: components.componentsTotal, quantity: 1, addToUsualMeals: <form save-as-usual>, components: components)]` when there is at least one named component; otherwise `[]`.

Choose the meal-name fallback when `mealName` is blank but components exist: use the first component's name (so an unnamed composed meal still logs something sensible). Document this in a one-line comment.

If `food_entry_form.dart` now exceeds ~250 lines, extract the by-foods body widget into `composed_meal_fields.dart` and export from the inputs barrel; keep `results` in `FoodEntryFormState`.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 8: Today "Something New" logs the composed meal

**Files:**

- Modify: `lib/app/feature/today/widgets/meal_log_section.dart` (the `FoodEntrySheet` result handler at ~line 235, and `_logOntoTargetDays`)
- Test: `test/app/feature/today/widgets/meal_log_section_test.dart`

**Interfaces:**

- Consumes: `FoodEntryResult.components`, `DailyLogEvent.mealLogged(..., components:)`, `UserSettingsBloc.saveAsUsualMeal(..., components:)`.
- Produces: a composed `FoodEntryResult` logs as ONE `MealLogEntry` with its components; when `addToUsualMeals`, the created usual carries the same components.

- [ ] **Step 1: Write the failing widget/bloc test**

In `meal_log_section_test.dart`, simulate confirming a `FoodEntrySheet` that returns one composed result (or test `_logOntoTargetDays` indirectly): assert `DailyLogBloc` receives a `mealLogged` with non-empty `components`. Mock the blocs (`mocktail`) and verify the dispatched event:

```dart
    verify(() => dailyLogBloc.add(
      any(that: isA<MealLogged>()
          .having((e) => e.components, 'components', hasLength(2))),
    )).called(1);
```

(Match the existing `meal_log_section_test.dart` harness — how it mocks `DailyLogBloc`/`UserSettingsBloc` via `getIt` and how it triggers the sheet. If driving the real sheet is heavy, test the result-handling logic by extracting nothing new — drive the sheet and pop a composed result via the form, or assert through the existing sheet-confirm path the file already uses.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart`
Expected: FAIL — components not threaded through.

- [ ] **Step 3: Thread components through the result handler**

In `meal_log_section.dart`, in the `for (final foodResult in result.foods)` block (~line 235): pass `components: foodResult.components` into both `saveAsUsualMeal(...)` (when `addToUsualMeals`) and the `mealLogged` event. Add a `List<MealComponent> components = const []` parameter to `_logOntoTargetDays` and forward it to every `DailyLogEvent.mealLogged(...)` it builds (both the single-day and multi-day branches).

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 9: Full-suite green + analyzer + dangling-mode cleanup

**Files:** none beyond fixing fallout; optionally trim `MealEntryMode.summary`/`detail` if now unused.

- [ ] **Step 1: Search for now-unused `MealEntryMode` members**

Run: `fvm flutter analyze lib test` and grep for `.summary`/`.detail` usages of `MealEntryMode`. If the tooltip removal in Task 6 left `MealEntryMode.detail`/`summary` with no readers, either leave them (harmless) or remove them and their references — do NOT remove if any test or widget still reads them.

- [ ] **Step 2: Run the affected suites with a random seed**

Run:

```bash
fvm flutter test test/app/widgets test/app/feature/today test/app/feature/user_settings test/app/feature/meal_entry test/app/core/networking --test-randomize-ordering-seed random
```

Expected: PASS. Fix any fallout from the `FoodEntryResult` shape change (record literals missing `components`) and the toggle change (tests asserting the old `Itemize` checkbox). Note: a pre-existing unrelated failure in `usual_meal_list_test.dart` (developer's ConfirmDialog WIP) may persist — confirm it is the same failure and unrelated, do not fix it here.

- [ ] **Step 3: Analyzer clean on touched dirs**

Run: `fvm flutter analyze lib/app/widgets/inputs lib/app/feature/today lib/app/feature/user_settings lib/app/feature/meal_entry lib/app/core/networking`
Expected: No errors (fix errors only, not info/warnings).

- [ ] **Step 4: Leave changes in the working tree (no commit)**

---

## Self-Review

**Spec coverage (Phase 2a slice):**

- "Whole meal / By foods" toggle replacing the itemize control → Task 6. ✓
- By-foods composed builder (meal name + component rows + steppers + per-row macros + computed total) → Task 7. ✓
- `MealComponent`-carrying result + logging one composed entry → Tasks 2, 8. ✓
- Composed meal saved as a usual meal → Tasks 1, 8. ✓
- AI itemize → base-unit composed components → Tasks 4, 5. ✓
- Whole-meal multi-row behavior preserved (Jacob's call), only the itemize UI removed → Tasks 6, 7 (whole-meal `results` branch untouched). ✓
- Deferred by design (NOT 2a gaps): per-food "Save as a usual food" + food picker (Phase 4 library), composed display/expand in the Today log (Phase 3), and the other 5 entry call sites (Phase 2b). Stated in Key Decisions.

**Placeholder scan:** Tasks 1–8 carry concrete code or exact edits. Tasks 5 and 7 describe widget/handler structure with the exact interfaces, state fields, and result shapes rather than line-final widget code, because they build on patterns the implementer reads in-file (`_foodsFromSuggestions`, `ExpandableNutrition`, `NutritionFields`); the test cases pin the observable behavior. If an implementer wants the exact widget tree, the mockup `design/mockups/usual_foods_entry_sheet.html` is the visual reference.

**Type consistency:** `components: List<MealComponent>` is the field name everywhere (`MealLogged`, `SettingsUsualMealAdded`, `saveAsUsualMeal`, `FoodEntryResult`, `MealComponent` list); `mealName: String` and `MealEntryEvent.mealNameChanged`; `MealEntryMode.{wholeMeal,itemized}` reused as the toggle. `componentsTotal` (Phase 1) is the total getter used in Task 7.
