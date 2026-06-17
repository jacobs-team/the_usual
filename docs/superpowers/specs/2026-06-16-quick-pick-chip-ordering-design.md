# Quick-Pick Chip Ordering & Layout

## Goal

On the Today view, reorganize the meal-logging quick-pick chips so the most
relevant meals surface first, allow cross-posting a usual from one meal timing
to another, and cap the chips at three rows that scroll horizontally once full.

## Scope

- **In scope:** Today view quick-pick chips only (`meal_log_section.dart`,
  fed by `today_view.dart`).
- **Out of scope:** Onboarding first-log (keeps its multi-select card grid),
  settings usuals management, and onboarding build-usuals (both use editable
  rows, not loggable chips).

## Behavior

### Ordering

For a meal section with timing `M` (breakfast/lunch/dinner/snacks), the chip
list is built from **all** usuals across every timing, then filtered and
ordered.

**Filter** (current behavior, kept, per section): drop any usual already logged
today in section `M`. Match by name (case-insensitive) or by `usualMealId`, so a
renamed usual still resolves to its logged entry.

**Order into three tiers:**

1. **Most recent (this timing):** the single home-`M` usual whose most recent
   log entry at timing `M` is newest. One chip. If the most-recent usual has
   been filtered out (already logged today), the tier falls through to the next
   visible candidate — i.e. tier 1 is the most-recent among *visible* home-`M`
   usuals.
2. **Most eaten (this timing):** remaining home-`M` usuals, sorted by log count
   at timing `M` descending, then by recency at `M`, then by library order.
3. **Other timings (cross-post):** usuals whose home timing is not `M`, sorted
   by overall log count descending, then by overall recency, then by library
   order.

Frequency and recency are derived from `DailyLogBloc.state.mealEntries` (full
history), attributing entries to usuals via `usualMealId`. Entries without a
`usualMealId` (manually typed) contribute to no usual's stats.

### Cross-posting

Tapping any chip logs the meal under the section it sits in. A dinner usual
shown as a cross-post chip inside the Lunch section logs as lunch when tapped.
The log event is unchanged (`DailyLogEvent.mealLogged`) — it already takes the
section's `mealOfTheDay` and the tapped usual's `name`, `nutrition`,
`usualMealId`, and `photoPath`.

### Hide-after-log

Unchanged from today and applied per section: once a usual is logged in section
`M`, it disappears from `M`'s chips for the rest of the day. The same usual may
still appear as a cross-post chip in other sections where it has not been
logged.

## Layout

Replace the current `Wrap` (left-to-right flow, grows downward) with a
column-fill layout that fills three rows top-to-bottom, then adds columns to the
right with horizontal scrolling.

- Chunk the ordered chip list into groups of 3.
- Render each group as a vertical `Column` of `_QuickPickChip` widgets.
- Lay the columns left-to-right in a `Row` inside a horizontal
  `SingleChildScrollView`.
- Each chip sizes to its label; each column is as wide as its widest chip.
- Fewer than four chips = a single column, no horizontal scroll.

## Architecture

Add one pure helper as an extension on `List<MealLogEntry>` in the meal-log-entry
list extension file:

```dart
List<UsualMeal> orderedQuickPicks({
  required MealOfTheDay mealOfTheDay,
  required Map<MealOfTheDay, List<UsualMeal>> usuals,
  required DateTime day,
})
```

It computes today's logged set for `mealOfTheDay` (from entries on `day`),
computes per-usual stats from the full entry history, applies the filter, and
returns the ordered `List<UsualMeal>`.

- `today_view.dart` calls the helper once per timing, inside the existing
  `BlocSelector` builders where both `usuals` (UserSettingsBloc) and
  `mealEntries` (DailyLogBloc) are already selected, and passes the ordered list
  into `MealLogSection`.
- `MealLogSection` drops its internal filtering/ordering. Its `usualMeals`
  parameter is replaced by an already-ordered `quickPicks` (`List<UsualMeal>`).
  It keeps `mealLogEntries` for the logged-entries display and nutrition
  breakdown. The chip section swaps `Wrap` for the column-fill layout.

Recompute happens only when `mealEntries` or `usuals` change (the helper runs
inside `BlocSelector` builders), satisfying the existing TODO without adding a
third bloc solely to join two — consistent with the project's no-premature-
abstraction rule.

## Files touched

- `lib/app/model/extensions/meal_log_entry_list_extensions.dart` — add
  `orderedQuickPicks`.
- `lib/app/feature/today/view/today_view.dart` — compute ordered picks per
  timing, pass down.
- `lib/app/feature/today/widgets/meal_log_section.dart` — take `quickPicks`,
  drop internal filter/order, swap `Wrap` for column-fill horizontal scroll.

## Testing

- Unit-test `orderedQuickPicks` with matchers: tier ordering (recent → frequent
  → other timings), the already-logged-today filter (by name and by id), rename
  resolution by id, and cross-timing inclusion.
