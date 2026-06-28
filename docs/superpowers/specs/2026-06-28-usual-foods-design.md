# Usual Foods — composing meals from foods

**Date:** 2026-06-28
**Status:** Design approved, pending spec review

## Summary

Today a usual meal is an atomic blob: a name and one `Nutrition` total. You can't
adjust a part of it without re-estimating the whole thing. This change introduces
**usual foods** — a first-class library of base nutritional items — and lets a usual
meal be **composed** of those foods, each with its own quantity. Editing one
component ("chicken ×4 → ×3") recalculates the meal total automatically.

The app stays meal-centric. The day view never becomes a flat ingredient list: a
composed meal shows as one line you tap to log, and expands to reveal and tweak its
foods. A meal can still be **standalone** (its own nutrition, no foods) exactly as
today. Composition is an additive second mode, not a replacement.

## Goals

- A usual meal can be a list of `{usualFood, quantity}` components, or a standalone
  blob as today.
- Adjusting a component's quantity recalculates the meal total live, with no
  AI re-estimate.
- Usual foods are a reusable library, parallel to usual meals.
- "Tap usual meal → done" is preserved. Collapsed, a composed meal is one line.
- Editing a logged food, or a usual food, offers to update the saved usual — the
  same pattern logged meals already use ("Update usual meal to match").
- Existing usual meals and logged meals migrate with zero data loss.

## Non-goals

- No live references between meals and library foods. Meals own snapshots of their
  foods (see "Shared-edit semantics").
- No structured units/measures (g, oz, ml) as a typed field. Portion lives in the
  food's name ("Chicken, 1 oz") and scaling is the existing plain quantity
  multiplier.
- No nutrition database or barcode lookup. Foods are user- or AI-supplied, as now.

## Core concepts

**UsualFood** — one base nutritional item in the library, e.g. "Chicken, 1 oz" with
per-unit nutrition. The atomic, reusable unit. Parallel to `UsualMeal`.

**MealComponent** — a usual food *inside* a meal: a snapshot of the food's name and
per-unit nutrition, a `quantity`, and a lightweight `usualFoodId` link back to the
library entry it came from (for the "update the foods using this" propagate prompt).
The component owns its nutrition copy; the link is only an identity hint.

**UsualMeal** — gains an optional list of components.
- *Standalone* (no components): its own `nutrition` blob, edited directly. Today's
  behavior, unchanged.
- *Composed* (has components): its `nutrition` is the read-only sum of its scaled
  components, kept in sync whenever a component changes.

**MealLogEntry** — gains the same optional component list, so a logged composed meal
carries its foods and can be expanded and tweaked in the day view. Logged history is
always a snapshot and never ripples from later library edits.

## Data model changes

New model `UsualFood` (`lib/app/model/usual_food.dart`):

```dart
@freezed
abstract class UsualFood with _$UsualFood {
  @JsonSerializable(explicitToJson: true)
  const factory UsualFood({
    required String id,
    required String name,                 // base-unit name, e.g. "Chicken, 1 oz"
    @Default(Nutrition()) Nutrition nutrition,  // per single unit
  }) = _UsualFood;

  factory UsualFood.fromJson(Map<String, dynamic> json) =>
      _$UsualFoodFromJson(json);
}
```

New model `MealComponent` (`lib/app/model/meal_component.dart`):

```dart
@freezed
abstract class MealComponent with _$MealComponent {
  @JsonSerializable(explicitToJson: true)
  const factory MealComponent({
    required String name,                 // snapshot of the food's name
    @Default(Nutrition()) Nutrition nutrition,  // per-unit snapshot
    @Default(1) double quantity,
    String? usualFoodId,                  // link for the propagate prompt; nullable
  }) = _MealComponent;

  const MealComponent._();

  factory MealComponent.fromJson(Map<String, dynamic> json) =>
      _$MealComponentFromJson(json);

  /// This component's contribution to the meal total.
  Nutrition get scaledNutrition => nutrition * quantity;
}
```

`UsualMeal` gains `components`:

```dart
const factory UsualMeal({
  required String id,
  required String name,
  String? photoPath,
  @Default(Nutrition()) Nutrition nutrition,        // total; for composed meals = sum
  @Default(<MealComponent>[]) List<MealComponent> components,
}) = _UsualMeal;
```

`MealLogEntry` gains `components`:

```dart
const factory MealLogEntry({
  required String id,
  required DateTime loggedAt,
  required MealOfTheDay mealOfTheDay,
  required String name,
  @Default(Nutrition()) Nutrition nutrition,        // total when composed
  @Default(1) double quantity,
  String? usualMealId,
  String? photoPath,
  @Default(<MealComponent>[]) List<MealComponent> components,
}) = _MealLogEntry;
```

Derived totals. A small helper on the component list (extension or static) sums
`scaledNutrition` across components. When `components` is non-empty, the meal's /
entry's stored `nutrition` is set to that sum on every mutating event — so stored
`nutrition` always represents **one serving** of the meal, and the existing
quick-log and summary paths keep reading a single `nutrition` value with no change.
When `components` is empty the model is standalone and behaves exactly as today.

Quantity semantics — two independent levels, both kept:

- **Component quantity** defines one serving of the meal: "Chicken, 1 oz" ×3 is the
  chicken in one quesadilla.
- **Meal-level `quantity`** says how many servings were eaten: ×1 or ×2 quesadillas.

These do not conflict because stored `nutrition` is one serving (the summed
components) and the existing `scaledNutrition => nutrition * quantity` getter applies
the meal quantity on top. So a ×2 composed quesadilla is `(3 oz chicken + tortilla +
cheese) * 2` with no new math. Standalone meals are the same as today (`nutrition *
quantity`, e.g. "×3 protein bar").

Both quantities stay `double`, and the existing `QuantityStepper` (with its `.1`
step-size toggle, 0.1 minimum) is reused at both levels — so fractional servings like
1.5 quesadillas keep working.

## Shared-edit semantics: snapshot + propagate

Meals and logs store **copies** of their foods, not references. This keeps every
total computable with no lookups, makes deleting a library food safe (no dangling
references), keeps sync simple, and makes migration near-free.

The "fix once" benefit is available on demand:

- Editing a usual food's base nutrition (from the library, or via "Save as usual
  food" / "Update usual food" while editing a meal) prompts: *"Also update the N
  usual meals that use this food?"* Affected meals are found by matching
  `MealComponent.usualFoodId`. Accepting rewrites those components' snapshots;
  declining leaves them.
- This never touches `MealLogEntry` history. Past logs are immutable snapshots.

This mirrors the existing logged-meal behavior, where editing a logged entry offers
"Update usual meal to match" — the template updates for next time, history does not.

## UI design

### Entry sheet — Whole meal / By foods toggle

The existing `FoodEntrySheet` / `FoodEntryForm` gains one segmented control:
**Whole meal** vs **By foods**. It is seeded from the existing `mealEntryMode` user
default and switchable per entry.

- **Whole meal** (today's behavior, kept): a name field and one `NutritionFields`
  block. No food list. This is how standalone meals — a shake, a banana — are
  entered. Nothing is removed.
- **By foods**: the nutrition block becomes a food list. Each food is a compact row
  with its name, a per-row summary, and an inline `+/−` quantity stepper. Tapping a
  food's name expands its per-unit `NutritionFields` plus a "Save as a usual food"
  checkbox. An "Add a food" action appends a row (with a picker of existing usual
  foods — see Phasing). A read-only **Meal total** bar at the bottom shows the
  computed sum. A "Save meal as a usual" checkbox persists the composed meal.

An itemized AI estimate lands directly in "By foods" mode: the meal name plus its
component foods, each at the right quantity (see AI changes).

### Today log — Direction B (inline food list)

A logged composed meal renders collapsed as one line (name + summary), preserving
tap-to-log. Expanding it reveals its component foods as a flat, compact list, each
with an inline `+/−` stepper. Nudging a quantity recalculates the meal total above
in place — no drilling, no re-estimate. A food's per-unit macro fields hide behind a
tap on its name, since changing quantity is the common action and editing macros is
rare. A `USUAL FOOD` hint marks components linked to the library.

Standalone logged meals render exactly as today (one editable nutrition block).

This reuses the visual language of `ExpandableNutrition`, `NutritionFields`,
`QuantityStepper`, `NutritionSummary`, and `UpdateUsualButton`; the new piece is the
inline component list inside the expanded meal.

### Usual foods management

A way to browse and edit the usual foods library, parallel to the usual meals tabs.
Scoped as a later phase (see Phasing) so the core composition flow ships first.
Foods are created implicitly via "Save as usual food" until then.

## AI changes

The AI mode is no longer a separate "itemize" control — it is **the same Whole meal
/ By foods toggle**. The old standalone `mealEntryMode` checkbox/setting is removed;
the persisted preference is kept but surfaced only through that toggle.

- **Whole meal** → the AI lumps everything into one blob suggestion → a standalone
  meal. Unchanged from today.
- **By foods** → the AI itemizes into base-unit foods. The prompt normalizes
  portions to a base unit and moves the count to quantity: "4 oz chicken" → a food
  named "Chicken, 1 oz" with per-unit nutrition at quantity 4. This is already
  expressible by `AiMealSuggestion` (`name`, `quantity`, per-unit `nutrition`); the
  change is prompt wording plus how the app assembles the result.
- The app maps a By-foods result to **one** `UsualMeal` / `MealLogEntry` whose
  `components` are the suggestions, instead of the N separate flat entries today's
  itemized mode produces.

## Persistence & migration

All new fields are additive with `@Default(...)`, so old stored JSON that lacks them
decodes to the empty/standalone shape — existing meals and logs read straight
through as standalone. Following the project's versioning rule:

- **DailyLogState**: bump `_currentVersion` 1 → 2. No transform needed (additive);
  add the version case so the bump is explicit and future-proof.
- **UserSettingsState**: bump `_currentVersion` 3 → 4. Add `usualFoods` (the new
  flat library) and rely on additive defaults for `UsualMeal.components`. The
  library is flat (a `List<UsualFood>`), not keyed by `MealOfTheDay`, because a food
  like "Chicken, 1 oz" is reused across meal timings.
- **SyncRepository**: the new fields ride along in the existing per-bloc state
  documents; bump the sync `schemaVersion`. Older clients reading newer docs ignore
  unknown keys and fall back to defaults (the existing best-effort downgrade path).

`Nutrition.migrateLegacyJson` is unaffected and still runs for `UsualMeal` and
`MealLogEntry`.

## Phasing

Each phase is independently shippable and gets its own implementation plan.

1. **Model + composition core.** `UsualFood`, `MealComponent`, the `components`
   fields on `UsualMeal` and `MealLogEntry`, derived-total syncing, the new
   `usualFoods` library on settings, events to mutate components, and the migrations
   above. No new screens yet.
2. **Entry sheet "By foods" mode.** The toggle, food list with steppers, per-food
   editor, computed total, "Save as usual food", and the itemized-AI → composed-meal
   assembly.
3. **Today log composition.** Direction B inline food list in the expanded meal, the
   live recalc, and the "update usual food / also update N meals" propagate prompt.
4. **Usual foods library management.** A browse/edit surface for the library and a
   food picker when adding a food to a meal (reuse existing foods).

## Testing

- Model unit tests: composed-meal total = sum of scaled components; standalone
  unchanged; `MealComponent.scaledNutrition`; quantity edits recompute totals.
- Migration tests: pre-v2 `DailyLogState` and pre-v4 `UserSettingsState` JSON
  (including legacy top-level calories) decode to standalone meals/logs with empty
  components and no data loss; a newer-version doc still reads as best effort.
- Bloc tests (`blocTest`): adding/removing/editing components on a usual meal and a
  log entry; the propagate prompt updating matched meals by `usualFoodId`; AI
  itemize producing one composed meal.
- Widget tests: locate by type/key/icon (steppers, expand tiles), not UI strings.
  Toggle switches the sheet between whole-meal and by-foods; expanding a logged meal
  shows its component rows; a stepper tap updates the displayed total.
