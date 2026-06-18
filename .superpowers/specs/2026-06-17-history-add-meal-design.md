# History: add meals to a past day

## Problem

The history view lets a user edit and delete logged meals but not add them. If a
user forgets to log a meal (e.g. yesterday's dinner), there's no way to record it
after the fact. The Today view already has a complete "add meal" experience; the
history view should reuse it, scoped to the day being edited.

## Goal

For every day shown in history, show all four meals (Breakfast, Lunch, Dinner,
Snacks) regardless of whether they have entries. Each meal label gets a `+`
button. Tapping it opens the exact Today meal card (`MealLogSection`) in a bottom
sheet, scoped to that historical day, so the user can add from quick-picks,
"Something else" (manual/AI entry), or "From another meal" (the cross picker).

## Constraints discovered

- All add paths fire `DailyLogEvent.mealLogged`, and `_onMealLogged` stamps
  `loggedAt: clock.now()`. Adding to a past day requires the entry to land on
  that day, so logging must become day-aware.
- The app already has this pattern: `WeightOnDayChanged` stamps
  `day.atDayStart(dayStart)` so the entry buckets back to the logical day.
- The quick-pick and cross-picker filtering extensions (`orderedQuickPicks`,
  `usualsFromOtherMeals`) are already parameterized by `day` and `dayStart`, so
  they work for a historical day with no change.
- `MealLogSection` is built as a sliver; hosting it in a bottom sheet needs a
  `CustomScrollView`.

## Design

### 1. Day-aware logging (core change)

- Extend `DailyLogEvent.mealLogged` with optional `DateTime? day` and
  `TimeOfDay? dayStart`.
- In `_onMealLogged`, stamp
  `loggedAt: day != null ? day.atDayStart(dayStart!) : clock.now()`.
- Today passes neither and keeps logging to now. All entries added to a past day
  are stamped at that day's logical start; this is acceptable (ties are broken by
  existing insertion order and quick-pick tie-breakers).

### 2. Thread the target day through the add UI

- `MealLogSection` gains `DateTime? day` and `TimeOfDay? dayStart` params. Each of
  its three log paths (quick-pick chip, "Something else" results,
  `OtherMealUsualsSheet`) forwards them into `mealLogged`.
- `OtherMealUsualsSheet` / `_UsualMealCard` gain `DateTime? day` and
  `TimeOfDay? dayStart` and forward them into `mealLogged`.
- On Today these are null (logs to now). In the history sheet they are the day
  being edited.

### 3. History day card

- In `_HistoryDayCard`, render every `MealOfTheDay` in order, always. Replace the
  "only meals with entries" guard so empty meals still appear.
- Each meal is a row: `SectionLabel(mealOfTheDay.label.toUpperCase())` on the
  left, a `+` `IconButton` on the right.
- The meal's logged entries continue to render beneath via `LoggedEntryRow`,
  keeping the existing edit/delete behavior. Empty meals show only the label and
  `+`.
- Tapping `+` opens a bottom sheet (`showModalBottomSheet`, `isScrollControlled`,
  `useSafeArea`, `showDragHandle`) hosting `MealLogSection` for that meal on
  `historyDay.day`, inside a `CustomScrollView`. Pass `isCurrent: false` and the
  user's `expandNutritionByDefault`.

### 4. Wiring the sheet's data

The history sheet needs, computed against `historyDay.day`:

- `quickPicks` via `mealEntries.orderedQuickPicks(...)`
- `otherMealUsuals` via `mealEntries.usualsFromOtherMeals(...)`
- `usuals`, `dayStartTime`, and `expandNutritionByDefault` from
  `UserSettingsBloc` (history already reads `dayStartTime`).

## Out of scope

- No change to how Today logs meals (still logs to now).
- No change to weight logging.

## Persisted state

No migration needed. `MealLogEntry` and `DailyLogState` shapes are unchanged.
Only `DailyLogEvent.mealLogged` gains optional params, and events are not
persisted.

## Follow-up requested by the user

After implementation, explain the logic of the cross meal picker sheet
(`OtherMealUsualsSheet`) and which items it displays.
