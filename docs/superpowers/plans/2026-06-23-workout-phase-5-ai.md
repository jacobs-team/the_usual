# Workout Feature — Phase 5: AI (Machine Photo + Bodyweight Estimation) Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Checkbox (`- [ ]`) steps.

**Goal:** Two AI features in the New-workout sheet, both gated and degrading gracefully: (a) snap a gym machine → Claude returns candidate exercise names, tap one to fill the name; (b) a "Bodyweight" checkbox (unlocked only once a body weight is on record) that, on log, resolves each auto set's weight via Claude so bodyweight exercises contribute volume.

**Architecture:** A new `WorkoutAiRepository` mirrors `MealAiRepository`, reusing the existing `MealAiClient` (Genkit/Claude) and `pickMealPhotos`/`MealPhoto`. The `WorkoutEntrySheet` (Phase 3, a StatefulWidget) gains local async state for photo-name suggestions and bodyweight estimation — no new bloc (single-use sheet). `SetFields` gains a bodyweight mode. Body weight is resolved (latest weight log → settings starting weight) and converted to the workout weight unit in the section before opening the sheet.

**Tech Stack:** Flutter, Genkit/Anthropic via `MealAiClient`, `schemantic` (SchemanticType), get_it.

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, section 6 and Resolved decision C.
- **Reuse, don't duplicate:** use the existing `MealAiClient`, `MealPhoto`, and `pickMealPhotos` (all generic despite the "meal" names — do NOT rename them; that's out-of-scope churn). Mirror `MealAiRepository`'s structure (prompt → `SchemanticType.from(jsonSchema:, parse:)` → `generateStructured`).
- **Gating & graceful degrade:** the camera button shows only when `getIt<WorkoutAiRepository>().isConfigured`. The Bodyweight checkbox is enabled only when a resolved body weight exists (independent of AI). When checked but AI is unconfigured, auto sets stay `weight: null` (0 volume) — no crash, no error. Estimation runs at log time only.
- **Bodyweight estimate is a snapshot:** the resolved per-rep weight is written into `WorkoutSet.weight` with `weightAutoEstimated: true` at confirm; volume/rendering never call AI. A user-typed weight overrides (stays `weightAutoEstimated: false`).
- **Disabled-checkbox message** (exact copy): `'Add your body weight to estimate bodyweight sets. Log it on the Today view or set a starting weight in Settings.'`
- Naming: full model-type variable names. Widgets get blocs/repos via `getIt<T>()`. Inline single-caller `BuildContext` closures.
- Never run the app. `fvm flutter`/`fvm dart` only. One-shot build permitted if the watcher lags (this run only). Do NOT commit (controller commits). Full TDD; tests locate by type/key/icon, mock `WorkoutAiRepository`, run with `--test-randomize-ordering-seed random`.

---

### Task 1: WeightUnit conversion helper

**Files:**
- Modify: `lib/app/model/weight_unit.dart`
- Create: `test/app/model/weight_unit_conversion_test.dart`

**Interface produced:**
```dart
extension WeightUnitConversion on WeightUnit {
  /// Converts [value], expressed in [from], into this unit. A no-op when units match.
  double convertFrom(double value, WeightUnit from);
}
```

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('WeightUnitConversion', () {
    test('is a no-op when units match', () {
      expect(WeightUnit.lb.convertFrom(150, WeightUnit.lb), equals(150));
      expect(WeightUnit.kg.convertFrom(70, WeightUnit.kg), equals(70));
    });

    test('converts lb to kg and back within tolerance', () {
      expect(WeightUnit.kg.convertFrom(220.462, WeightUnit.lb), closeTo(100, 0.01));
      expect(WeightUnit.lb.convertFrom(100, WeightUnit.kg), closeTo(220.462, 0.01));
    });
  });
}
```

- [ ] **Step 2:** Run `fvm flutter test test/app/model/weight_unit_conversion_test.dart` — expect FAIL.
- [ ] **Step 3:** Implement in `lib/app/model/weight_unit.dart` (append below the enum):

```dart
/// Converting a weight value between [WeightUnit]s.
extension WeightUnitConversion on WeightUnit {
  /// Converts [value], expressed in [from], into this unit. A no-op when the
  /// units already match.
  double convertFrom(double value, WeightUnit from) {
    if (from == this) return value;
    const poundsPerKilogram = 2.20462;
    return this == WeightUnit.kg
        ? value / poundsPerKilogram
        : value * poundsPerKilogram;
  }
}
```

- [ ] **Step 4:** Run the test with random seed — expect PASS.
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): add WeightUnit conversion helper`.

---

### Task 2: WorkoutAiRepository

Mirror `lib/app/core/networking/repository/meal_ai_repository.dart`. Read it first for the `SchemanticType.from` + `generateStructured` pattern and imports.

**Files:**
- Create: `lib/app/core/networking/repository/workout_ai_repository.dart`
- Modify: `lib/app/core/networking/repository/repository.dart` (barrel)
- Modify: `test/helpers/mocks.dart` (add `MockWorkoutAiRepository`)
- Modify: `test/helpers/pump_app.dart` (register a `MockWorkoutAiRepository` with `isConfigured => false` by default)
- Create: `test/app/core/networking/repository/workout_ai_repository_test.dart`

**Interface produced:**
```dart
@singleton
class WorkoutAiRepository {
  WorkoutAiRepository(this._client);   // MealAiClient
  bool get isConfigured;
  Future<List<String>> suggestNamesFromPhoto(List<MealPhoto> photos);
  Future<double?> estimateBodyweightLoad({
    required String exerciseName,
    required double bodyWeight,
    required WeightUnit unit,
  });
}
```

**Behavior:**
- `isConfigured => _client.isConfigured`.
- `suggestNamesFromPhoto`: prompt ≈ "This photo shows a piece of gym equipment or a weight machine. List the exercises commonly performed on it. Use the shortest clear, conventional exercise names (for example 'Lat Pulldown', 'Leg Press'). Return at most 6." Schema: object with `names: {type: array, items: {type: string}}`, required `['names']`; parse → `List<String>` (cast). Call `_client.generateStructured(prompt:..., outputSchema: _namesSchema, images: photos)`.
- `estimateBodyweightLoad`: prompt ≈ "Estimate the effective weight lifted in one rep of \"$exerciseName\" by a person who weighs ${bodyWeight.round()} ${unit.name}. This is the share of body weight the movement actually loads (for example a push-up loads roughly 65% of body weight). Return a single number in ${unit.name}, or null if it cannot be estimated." Schema: object with `weight: {type: ['number','null']}`, required `['weight']`; parse → `double?` (read `weight`, coerce num→double, may be null). Call `generateStructured(prompt:..., outputSchema: _weightSchema)` (no images).
- Build the two `SchemanticType` schemas as `static final` like the meal repo.

**Tests** (mirror `meal_ai_repository_test.dart`): mock `MealAiClient`; drive the real schema's `parse` closure with raw JSON (use the same `thenAnswer` that reads `invocation.namedArguments[#outputSchema]` and calls `.parse(rawJson)`). Register fallback values for the schema fakes and `<MealPhoto>[]`. Cover: (1) `suggestNamesFromPhoto` returns the parsed name list; (2) `estimateBodyweightLoad` returns the parsed number; (3) `estimateBodyweightLoad` returns null when the model returns `{'weight': null}`; (4) `isConfigured` delegates to the client.

- [ ] **Step 1-5:** TDD cycle. Register `WorkoutAiRepository` `@singleton` (codegen updates `dependencies.config.dart` — one-shot build if the watcher lags). Add `MockWorkoutAiRepository` to mocks.dart and register it in pump_app.dart (`isConfigured => false`). Suggested commit: `feat(workout): add WorkoutAiRepository (machine-photo names, bodyweight load)`.

---

### Task 3: Bodyweight mode for SetFields

**Files:**
- Modify: `lib/app/widgets/inputs/set_fields.dart`
- Modify: `test/app/widgets/set_fields_test.dart`

**Interface change:** add `this.bodyweight = false,` to `SetFields`.

**Behavior:**
- When `bodyweight` is true: each row's weight field shows `hintText: 'auto'` (the greyed placeholder), and a row with an empty weight emits `WorkoutSet(weight: null, reps: <parsed>, weightAutoEstimated: true)`. A row where the user typed a weight emits `weight: <typed>, weightAutoEstimated: false`.
- When `bodyweight` is false: unchanged from Phase 3 (`weightAutoEstimated` always false).
- Everything else (rows, add/remove, reps) unchanged.

**Tests** (add): (1) with `bodyweight: true` and an empty weight, the emitted set has `weight == null` and `weightAutoEstimated == true`; (2) with `bodyweight: true` and a typed weight, the emitted set has the typed weight and `weightAutoEstimated == false`; (3) with `bodyweight: false`, emitted sets always have `weightAutoEstimated == false`.

- [ ] **Step 1-5:** TDD cycle. Suggested commit: `feat(workout): add bodyweight (auto) mode to SetFields`.

---

### Task 4: AI in WorkoutEntrySheet (machine photo + bodyweight)

Modify the Phase 3 `WorkoutEntrySheet`. For the photo/generating UI styling, read `lib/app/widgets/inputs/food_entry_form.dart` (the Estimate/Photo button row + "Estimating…" spinner) and match it.

**Files:**
- Modify: `lib/app/widgets/inputs/workout_entry_sheet.dart`
- Modify: `test/app/widgets/workout_entry_sheet_test.dart`

**Interface change:** add `this.bodyWeight,` (a `double?` already expressed in `weightUnit`; null means none on record).

**Behavior:**
- **Machine photo (gated on `getIt<WorkoutAiRepository>().isConfigured`):** a camera `IconButton`/`FilledButton.tonalIcon(Icons.photo_camera_outlined)` near the name field. On tap: `final photos = await pickMealPhotos(context); if (photos.isEmpty) return;` then set a local `_suggesting = true`, `await getIt<WorkoutAiRepository>().suggestNamesFromPhoto(photos)`, set `_suggestions` and `_suggesting = false` (guard with `mounted`). Render `_suggestions` as tappable chips (reuse the app's chip style); tapping a chip sets the name field text and clears suggestions. Show a small "Finding exercises…" spinner while `_suggesting` (mirror FoodEntryForm). On error, `_suggesting = false` and a `SnackBar('Could not read the photo. Try again.')`.
- **Bodyweight checkbox:** a `Checkbox` + label "Bodyweight". Enabled only when `widget.bodyWeight != null`. When disabled, wrap so a tap still fires and shows the exact disabled message `SnackBar` (use a `GestureDetector`/`InkWell` around a visually-disabled checkbox, or an always-enabled checkbox whose `onChanged`, when `bodyWeight == null`, only shows the SnackBar and does not check). When checked, pass `bodyweight: true` to the embedded `SetFields`.
- **Confirm-time estimation:** `_confirm` becomes async. If the bodyweight box is checked and `bodyWeight != null` and `getIt<WorkoutAiRepository>().isConfigured`: compute the per-rep load once via `estimateBodyweightLoad(exerciseName: name, bodyWeight: bodyWeight!, unit: weightUnit)`; then for each set with `weightAutoEstimated == true && weight == null`, set `weight: estimate, weightAutoEstimated: true` (leave user-typed sets untouched). If estimation returns null or AI is unconfigured, leave auto sets as-is (`weight: null`). Then `Navigator.pop` the `WorkoutEntryResult` (name, resolved sets, addToUsuals). Disable the confirm button while estimating.

**Tests** (mirror `food_entry_sheet_test.dart` harness; mock `WorkoutAiRepository` via `deps:`):
1. camera button absent when `isConfigured` is false, present when true.
2. with a mocked `suggestNamesFromPhoto` returning `['Lat Pulldown','Cable Row']`, after triggering the photo flow the suggestion chips render and tapping one sets the name field. (Photo picking itself opens a platform dialog — to keep the test deterministic, factor the "apply suggestions" path so the test can drive it: e.g., expose suggestion rendering from a `_suggestions` state your test can reach by stubbing the picker, OR test the chip→name behavior by seeding `_suggestions` through a visible-for-testing entry point. Prefer: extract the photo-picking call behind a small injectable indirection only if needed; otherwise test the repository call + chip rendering by triggering the handler. Keep the test focused on: chips appear for returned names, tapping fills the name.)
3. Bodyweight checkbox disabled (no tick) and shows the exact message SnackBar when `bodyWeight == null` and tapped.
4. With `bodyWeight: 200` and a mocked `estimateBodyweightLoad` returning `140`, checking Bodyweight, entering reps, and confirming pops a result whose auto set has `weight == 140` and `weightAutoEstimated == true`.

(If the platform photo picker makes case 2 hard to drive in a widget test, narrow it to: the camera button is gated correctly (case 1), and a unit-level test that given suggestions the chips fill the name — implement the suggestion application as a testable method. Report whatever seam you chose.)

- [ ] **Step 1-5:** TDD cycle. Run the targeted sheet test then the full suite; fix fallout. Suggested commit: `feat(workout): machine-photo name suggestions and bodyweight estimation in the entry sheet`.

---

### Task 5: Resolve body weight in WorkoutLogSection and pass it to the sheet

**Files:**
- Modify: `lib/app/feature/workout/widgets/workout_log_section.dart`
- Modify: `test/app/feature/workout/widgets/workout_log_section_test.dart`

**Behavior:** in the "New workout" handler (before opening `WorkoutEntrySheet`), compute the resolved body weight in `weightUnit` and pass it as `bodyWeight:`. Inline (no `BuildContext` helper):
```dart
final latestWeight = getIt<DailyLogBloc>().state.latestWeight;
final userSettings = getIt<UserSettingsBloc>().state;
double? bodyWeight;
if (latestWeight != null) {
  bodyWeight = weightUnit.convertFrom(latestWeight.weight, latestWeight.weightUnit);
} else if (userSettings.startingWeight != null) {
  bodyWeight = weightUnit.convertFrom(userSettings.startingWeight!, userSettings.weightUnit);
}
// ... WorkoutEntrySheet(..., bodyWeight: bodyWeight)
```

**Tests:** add a `MockDailyLogBloc` to the section test (it already mocks `WorkoutLogBloc`/`UserSettingsBloc`; add `DailyLogBloc`) and verify the New-workout flow still logs (the existing tests must keep passing). A focused assertion that `bodyWeight` threads correctly is best covered at the sheet level (Task 4); here just ensure the section compiles and its existing tests pass with the added `DailyLogBloc` dependency.

- [ ] **Step 1-5:** TDD cycle. Run the section test then the FULL suite; fix fallout. Suggested commit: `feat(workout): resolve body weight for the entry sheet from log or settings`.

---

## Self-Review

**Spec coverage (section 6, decision C):** machine-photo names (Tasks 2, 4); bodyweight estimation opt-in via a body-weight-gated checkbox (Tasks 1, 2, 3, 4, 5); estimate snapshot in `weight` with `weightAutoEstimated` (Task 4); graceful degrade when AI unconfigured (Tasks 4); resolved body weight from log then settings with unit conversion (Tasks 1, 5). ✓

**Placeholder scan:** Tasks 1-3 carry complete code; Tasks 4-5 specify exact behavior, gating, copy, and tests with a named seam for the picker. No "TBD".

**Type consistency:** `bodyWeight` is `double?` in `weightUnit` everywhere (section → sheet → estimate call). `suggestNamesFromPhoto` returns `List<String>`; `estimateBodyweightLoad` returns `double?`. `SetFields.bodyweight` drives `WorkoutSet.weightAutoEstimated`. `convertFrom(value, from)` converts into the receiver unit.

**Deviation noted:** the spec mentioned a `WorkoutEntryBloc`; this plan uses local async state in the single-use sheet instead (YAGNI), with the repository mocked for tests. If review finds the async state unwieldy, revisit a bloc.
