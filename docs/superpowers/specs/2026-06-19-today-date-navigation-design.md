# Today view: date navigation + multi-day logging

## Goal

Let the user view and edit any day's log from the Today view, not just the
current day. The app-bar "Today" title becomes a tappable pill that opens the
native date picker. Selecting a single day switches the view to that day;
selecting a date range turns logging into a bulk action that writes to every day
in the range at once. Any selected day is fully editable, exactly like today.

## Background (what already exists)

The data layer already supports logging onto an arbitrary day, because the
History "add a forgotten meal" feature needed it:

- `DailyLogEvent.mealLogged(...)` takes optional `day` + `dayStart`. When both
  are null it stamps `loggedAt` at `clock.now()`; when set it stamps at
  `day.atDayStart(dayStart)`.
- `MealLogSection` and `OtherMealUsualsSheet` already accept an optional `day` +
  `dayStart` and thread them into the logging events. The History sheet
  (`HistoryMealSheet`) passes a single past `day`.
- `DailyLogState.mealEntries.breakdownOn(day, dayStart)` filters all entries to
  one logical day. The Today view already calls this with `today`.
- `DailyLogEvent.weightOnDayChanged(day, weight, unit, dayStart)` sets/clears a
  weigh-in for a given logical day. `WeightEntryField` takes a single `day`.

So today the Today view simply doesn't expose day selection — it always computes
`today = now.logicalDay(dayStartTime)` and never passes a day to logging. This
work exposes selection and extends single-day logging to a multi-day range.

## Design

### 1. Selected-day state (local to `TodayView`)

`TodayView` holds `DateTimeRange? _selectedRange` in its `State`.

- `null` => the live "today" view: current behavior. Entries are stamped at
  `clock.now()` (preserving real timestamps and quick-pick recency ordering).
- non-null => a specific single day (`start == end`) or a multi-day range.

When the picker returns a single day equal to the current logical day, store
`null` (not a one-day range) so the view stays live.

Derived each build:

- `displayDay` — the logical day whose breakdown is shown. `null` range =>
  `today`; otherwise `DateUtils.dateOnly(_selectedRange!.start)`.
- `logDays` — the concrete list of days each log writes to. `null` range =>
  `null` (meaning "log live to today via `clock.now()`"); otherwise the
  inclusive list of days from `start` to `end`.
- `isToday` — `_selectedRange == null`. Drives the current-meal highlight.

### 2. The pill (app-bar title)

Replace the static `'Today'` title with a tappable pill: a small calendar icon
plus a label. Label text:

- live today => `"Today"`
- single other day => formatted date, `MaterialLocalizations.formatMediumDate`
  (locale-aware, e.g. "Jun 17, 2026") — keep it compact in the bar.
- range => `"{start} – {end}"` using the same formatter.

Tapping opens `showDateRangePicker` with no `firstDate`/`lastDate` restriction
(any past, present, or future date). The range picker serves both jobs: tapping
one day twice selects a single day; tapping two days selects a range. On a
non-null result, set `_selectedRange` (normalizing single-day-today to `null`).

`TheUsualAppBar` gains an optional title-widget slot so the Today tab can render
the pill while the History tab keeps its plain string title. The existing
required `String title` stays as the fallback/semantic label; when the optional
widget is provided it renders instead of `Text(title)`. History is unchanged.

### 3. The displayed day

The view renders `displayDay`'s breakdown exactly as it renders today's: the
weight tracker, nutrition bar, per-meal sections, and quick picks all read from
`displayDay`. For a range this is the range's start day. After a bulk log, the
start-day entry appears in its section, so the screen reads like normal logging.

Quick-pick ordering / "from another meal" filtering use `displayDay` (the start
day) — consistent with showing the start day.

### 4. Logging writes to every day in the range

- `MealLogSection`: replace `DateTime? day` with `List<DateTime>? logDays`
  (keep `TimeOfDay? dayStart`). Each logging action — quick-pick chip, "Something
  else", and the "From another meal" sheet — dispatches one `mealLogged` per day.
  When `logDays` is `null`, dispatch a single event with `day: null` (live today,
  `clock.now()`). When non-null, dispatch one event per listed day with
  `day: thatDay`.
- `OtherMealUsualsSheet`: same change — `DateTime? day` => `List<DateTime>?
  logDays`; loop the dispatch.
- `WeightEntryField`: replace `DateTime day` with `List<DateTime> days`. Display
  and prefill read from `days.first`; the `onChanged` handler and the "Use last"
  button dispatch `weightOnDayChanged` once per day, writing the same value to
  every day in the range. Single-day callers pass `[day]`.
- `HistoryMealSheet` and the Today `_WeightTracker` pass one-element lists, so
  their behavior is unchanged.

No new BLoC events or state fields. The selected range is ephemeral view state,
not persisted.

### 5. Deliberate scope decisions

- **Editing an existing entry** (change quantity/macros, delete via
  `LoggedEntryRow`) acts on that one entry by id and does NOT fan out across the
  range. "Modifications log to every day in the range" applies to *adding*
  meals and weigh-ins — the purpose of range selection. Entries already logged
  on different days have different ids and are edited individually (switch to
  that single day to edit them).
- **Current-meal highlight** (the primary-colored border on the meal nearest
  the current time) shows only when `isToday` is true. On any other single day
  or a range, no section is highlighted — "the meal happening now" is
  meaningless off today, and this is also the cleanest to implement.
- **Lifecycle / midnight rollover**: the existing resume + refresh-timer logic
  rebuilds against the current time. When `_selectedRange` is `null` (live), the
  view follows the new day automatically. When a specific day/range is selected,
  it stays put; the user returns to today by reopening the picker.

## Files touched

- `lib/app/feature/today/view/today_view.dart` — selected-range state, derived
  `displayDay` / `logDays` / `isToday`, the pill + `showDateRangePicker`, pass
  `logDays` to `MealLogSection` and `_WeightTracker`, gate the highlight on
  `isToday`.
- `lib/app/widgets/display/the_usual_app_bar.dart` — optional title-widget slot.
- `lib/app/feature/today/widgets/meal_log_section.dart` — `day` => `logDays`,
  loop the logging dispatch.
- `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`
  (`OtherMealUsualsSheet`) — `day` => `logDays`, loop the dispatch.
- `lib/app/widgets/inputs/weight_entry_field.dart` — `day` => `days`, read from
  first, write to each.
- `lib/app/feature/history/widgets/history_meal_sheet.dart` — pass `logDays:
  [day]` to `MealLogSection`.
- Any other `WeightEntryField` call sites — pass `[day]`.

## Testing

- Single-day navigation: pick a past day, verify the breakdown, weight, and
  quick picks reflect that day; logging a meal stamps it onto that day; picking
  today returns to the live view.
- Range logging: select a multi-day range, log a quick pick and a "Something
  else"; verify an entry lands on every day in the range. Enter a weight; verify
  it lands on every day.
- Highlight: highlighted meal section appears only in the live-today view.
- History regression: adding a forgotten meal from History still logs onto the
  single past day (one-element `logDays`).
- Follow the repo testing rules: `blocTest` where state is asserted, find
  widgets by type/key/icon (not UI strings), `isA<...>().having` matchers.
