# Cross-Meal Logging via a Picker Sheet

## Goal

Remove the cross-timing quick-pick chips that cluttered each Today meal section, returning the chips to that meal's own usuals, and provide a dedicated "From another meal" picker sheet for the occasional cross-post.

## Background

A prior change made each meal section's quick-pick chips include every usual across all timings, so a section could show 25+ chips. That was too noisy. This change keeps the recency-then-frequency ordering and the three-row horizontal-scroll layout for a meal's own usuals, and moves cross-posting into an explicit picker.

## Scope

- **In scope:** Today view (`meal_log_section.dart`, `today_view.dart`), the `orderedQuickPicks` helper, a new `usualsFromOtherMeals` helper, and a new picker sheet widget.
- **Out of scope:** Onboarding, settings, the "I ate Something New" `FoodEntrySheet` flow (unchanged).

## Behavior

### Chips: this meal only

`orderedQuickPicks` drops its third tier (usuals from other timings). For a section with timing `M`, the chips are now only the usuals whose home timing is `M`, filtered to drop those already logged today for `M` (by name or `usualMealId`), ordered:

1. The single most-recently-logged usual for `M`.
2. Remaining `M` usuals by log count at `M` descending, then recency at `M`, then library order.

The three-row column-fill horizontal-scroll layout is unchanged.

### "From another meal" picker

A new `usualsFromOtherMeals` helper returns the user's usuals from meals other than `M`, grouped by meal in `MealOfTheDay` order, in library order within each meal. Usuals already logged today for `M` (by name or `usualMealId`) are dropped, and meals with no remaining usuals are omitted.

`MealLogSection` renders a "From another meal" button between the quick-pick chips and the existing "I ate Something New" button, shown only when `usualsFromOtherMeals` is non-empty. Tapping it opens a bottom sheet, `OtherMealUsualsSheet`, titled "Log to {meal label}". The sheet lists each non-empty meal group (its label as a header) with its usuals as tappable rows. Tapping a row logs that usual into the current section via `DailyLogEvent.mealLogged` with `M` as the `mealOfTheDay`, then closes the sheet (log-and-close; reopen to add another).

## Architecture

### Extensions (`meal_log_entry_list_extensions.dart`)

A shared private helper computes the set of names and ids logged today for a meal, used by both public methods:

```dart
({Set<String> names, Set<String> ids}) _loggedTodayKeys(
  List<MealLogEntry> entries,
  MealOfTheDay mealOfTheDay,
  DateTime day,
)
```

- `orderedQuickPicks({mealOfTheDay, usuals, day})` — trimmed to this-timing only. Returns `List<UsualMeal>`: the most-recent-at-`M` usual, then remaining `M` usuals by frequency at `M`. The other-timings tier, and the `countOverall`/`lastLoggedOverall` stats that fed it, are removed.
- `usualsFromOtherMeals({mealOfTheDay, usuals, day})` — returns `Map<MealOfTheDay, List<UsualMeal>>`: for each `MealOfTheDay` other than `M`, that meal's usuals in library order, dropping any logged today for `M`, omitting meals whose remaining list is empty.

### View (`today_view.dart`)

Inside the existing `BlocSelector` builders (where `mealEntries`, the `usuals` map, and `today` are in scope), compute both `orderedQuickPicks` and `usualsFromOtherMeals` per timing and pass them into `MealLogSection`.

### Section (`meal_log_section.dart`)

Add `required Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals`. Render a "From another meal" `TextButton.icon` when `otherMealUsuals.isNotEmpty`, between the chips and "I ate Something New". Its `onPressed` opens `OtherMealUsualsSheet` via `showModalBottomSheet`.

### Picker sheet (`cross_meal_picker_sheet.dart`, new)

`OtherMealUsualsSheet` is a feature widget in `lib/app/feature/today/widgets/`, exported from that folder's barrel. It takes the target `MealOfTheDay` and the grouped `Map<MealOfTheDay, List<UsualMeal>>`. It builds a scrollable column of meal-group headers and tappable usual rows. Each row's tap dispatches `getIt<DailyLogBloc>().add(DailyLogEvent.mealLogged(...))` with the target meal and the usual's name, nutrition, id, and photo, then pops the sheet.

## Testing

- `orderedQuickPicks` no longer includes other-timing usuals (the existing "includes other-timing usuals" test is replaced by one asserting only this-timing usuals are returned).
- `usualsFromOtherMeals`: groups other meals, excludes the current meal, drops usuals already logged today for the current meal, omits empty meals, preserves library order within a meal.
