# History Edit & Delete — Design

## Goal

Let the user edit and delete logged entries on the History view. Meal entries
become inline-editable (nutrition) and deletable, matching the Today screen.
Weigh-ins become editable and deletable on any past day, not just today.

## Background

The History view (`lib/app/feature/history/view/history_view.dart`) currently
renders each logged day as an `ExpansionTile` whose meals show through a
read-only `_HistoryEntryRow` (name + nutrition summary). The day's weigh-in
appears only as a read-only subtitle glance.

Two relevant facts about `DailyLogBloc`:

- **Meal edit/delete is already day-agnostic.** `mealEntryRemoved(id)` and
  `mealEntryNutritionChanged(id, nutrition)` operate on any entry by `id`,
  regardless of which day it was logged on. Today already drives them through
  `LoggedEntryRow` → `ExpandableNutrition` (inline nutrition fields + a delete
  button).
- **Weigh-in edit/delete is today-only.** `todayWeightChanged(weight, unit)` is
  hard-coded to `DateTime.now()` (`weightOn(now)`, `isSameDay(..., now)`), so it
  cannot touch a past day's weigh-in.

## Design

### Bloc — generalize the weight event to any day

Rename `DailyLogEvent.todayWeightChanged(double? weight, WeightUnit weightUnit)`
to `DailyLogEvent.weightOnDayChanged(DateTime day, double? weight, WeightUnit
weightUnit)`. The handler is the existing `_onTodayWeightChanged` logic with
`now` replaced by the event's `day`:

- Keep all weigh-ins not on `day`.
- `weight == null` → remove the day's weigh-in (emit the remaining entries).
- Otherwise update the existing weigh-in on `day` if there is one, or add a new
  `WeightEntry` with `loggedAt: day`.

Today's call site passes `DateTime.now()`, preserving current behavior exactly.
History passes the day card's date. This is one behavior parameterized by day,
not a second code path.

Meal entries need **no** new events — `mealEntryRemoved` and
`mealEntryNutritionChanged` already cover History.

### Shared widget — `WeightEntryField`

Extract Today's inline weight number field into a shared widget so both Today
and History drive the same control. It now has two callers, which is the bar
for pulling it into the app-wide `widgets/` folder.

`WeightEntryField` takes the `DateTime day` it edits. It renders the
`TheUsualTextField` (prefilled with that day's weigh-in, last-weight hint, unit
suffix, decimal formatter) and dispatches
`DailyLogEvent.weightOnDayChanged(day, double.tryParse(value), weightUnit)` on
change. Today's `_WeightTracker` keeps its `Card`/`ListTile` chrome and
delegates the field to `WeightEntryField(day: DateTime.now())`.

### History view

1. **Meals:** Replace `_HistoryEntryRow` with
   `LoggedEntryRow(mealLogEntry: ..., expandedByDefault: false)` and delete the
   `_HistoryEntryRow` class. This brings inline nutrition editing, the delete
   button, and the usual-meal-sync footer, consistent with Today. History
   defaults to collapsed.
2. **Weigh-in:** Add a `SectionLabel('WEIGHT')` plus
   `WeightEntryField(day: historyDay.day)` inside each day card's expanded
   children. The collapsed subtitle keeps its read-only ` · {label}` glance.
3. Give each meal row a `ValueKey(mealLogEntry.id)` so its expansion/edit state
   stays attached to the correct entry after a delete shifts sibling positions.

### Edge cases

- **Day/month emptying.** Deleting a day's last meal and weigh-in drops the day
  from `historyByMonth`; emptying the viewed month drops that month's page.
  Clamp `_selectedMonth` and the `PageController`'s page to the available range
  when history shrinks, and fall back to the existing empty-state message when
  history becomes empty. This is handled in `_HistoryViewState` reacting to the
  rebuilt `historyByMonth`.

## Out of scope

- Editing a meal's name, meal-of-day, or logged date.
- Moving entries between days or meals.
- Any change to how entries are created.

## Testing

Per project rules, tests are written only when requested. None planned in this
change unless asked.
