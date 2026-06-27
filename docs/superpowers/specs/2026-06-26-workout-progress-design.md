# Workout Progress — Design

Date: 2026-06-26
Status: Approved, pending implementation plan

## Summary

Replace the workout History screen with a **Progress** screen that organizes
workout history around exercises rather than days. The centerpiece is a
per-exercise strength chart that plots estimated one-rep-max (e1RM) over time,
so the user can see strength climbing across months. A combined "Overall
strength" index fuses every strength exercise into one general trend. The
existing day-by-day journal survives as a second lens on the same screen.

The volume chart is removed entirely — it was judged not useful.

## Motivation

The user wants to see strength increasing over time for specific exercises. The
existing workout charts are single-month and volume-based, which can't show a
multi-month, per-exercise strength arc. "Weight lifted over time" needs a metric
that folds in both weight and reps without being raw volume.

## Strength metric: estimated 1RM (e1RM)

Each session of an exercise is reduced to one number: the highest estimated
one-rep-max across that session's sets, using the **Epley** formula:

```
e1RM = weight × (1 + reps / 30)
```

- Reps are capped at 12 for the estimate. For a set with more than 12 reps the
  estimate becomes unreliable, so that set falls back to its raw `weight` as its
  e1RM contribution.
- The session's plotted point is the maximum e1RM across its sets (not the
  max-weight set — a lighter, higher-rep set can yield a higher e1RM).
- Each point is anchored to the real top set behind it (e.g. `100×8`), shown on
  the point's label and when the point is tapped, so the chart never feels like
  abstract math.

Rationale: e1RM is the standard "am I getting stronger" metric (Strong, Hevy).
It rises when weight goes up *or* when reps go up at the same weight, so it
captures progress that raw top-set weight would miss. In the user's typical
6–10 rep range it tracks bar weight closely, matching intuition, while still
catching rep progress. A single formula applied consistently makes the trend
honest even if the absolute number is a few percent off; per-exercise formulas
don't meaningfully exist and aren't needed.

### Eligibility

- Only **strength**-type entries with at least one set carrying both `weight`
  and `reps` produce e1RM points.
- Cardio is excluded — current cardio entries carry only a `duration`, which has
  no honest progress story. Cardio progress charts are deferred until the data
  model captures distance/pace.
- A bodyweight strength set works as long as it has a resolved (estimated)
  weight and reps.

## Exercise identity

Exercises are grouped by **lowercased `name`**, merging entries that share a
`usualWorkoutId`. So "Bench Press" and "bench press" are one exercise, and a
renamed usual still tracks as the same line. The display name uses the most
recent entry's `name`.

## Progress screen

Reached from the existing chart icon in the Workouts app bar
(`Routes.workoutHistory`). It **replaces** `WorkoutHistoryView`. The screen has a
segmented control at the top toggling two lenses on the same history:

### Exercises lens (default)

- **Overall strength** card at the top — the combined index line (see below).
- A list of the user's strength exercises, each row showing: exercise name, a
  small sparkline of its e1RM trend, and its latest estimated max. Ordered by
  most recently trained.
- Tapping a row opens the **exercise detail**:
  - The full e1RM line over all logged sessions, all-time, as one continuous
    line. Styled exactly like the existing weight chart: dark card
    (`colorScheme.primary`), net-change header (e.g. `▲ 15 lb` from first to
    latest session), endpoint labels, a dot on the latest point, and tap-a-point
    to reveal that session's real top set.
  - Below the chart, a read-only reverse-chronological list of that exercise's
    sessions (date + sets summary + that session's e1RM).

### Days lens

The existing day-by-day journal, preserved from `WorkoutHistoryView`, with the
volume chart removed:

- Reverse-chronological list of logged days (date + total-volume summary subtitle
  as today), each expandable to that day's entries grouped by training group.
- Month chips kept for navigating across months.
- Entries remain inline-editable and removable here, as today.

Day-level browsing and editing therefore exist in two places — this Days lens and
the Workouts tab date pill — which is intentional; neither is the sole path.

## Overall strength (combined index)

A single line answering "is my overall strength trending up." Raw e1RMs can't be
summed — big compound lifts would dominate and the number would lurch as
exercises rotate. Instead, a normalized index:

- For each strength exercise, its **baseline** is its first-ever session e1RM
  (= 100%).
- For each calendar month the user trained at least one strength exercise, each
  exercise trained that month contributes `currentMonthBestE1RM / baseline` as a
  percentage.
- The month's plotted value is the **average** of those percentages across the
  exercises trained that month.
- The line is plotted monthly and reads e.g. "Overall strength +15%".

This survives swapping exercises in and out and isn't dominated by any single
lift. It is an explicit **v1 heuristic** — the exact bucketing (monthly) and
carry-forward behavior are open to refinement, and the implementation plan should
treat the aggregation as an isolated, independently testable unit.

## Components & data flow

- **e1RM computation** lives on the model as pure, testable getters/extensions
  (e.g. a `WorkoutSet.estimatedOneRepMax` getter and a list extension for the
  best e1RM across a session's sets). No bloc changes needed for the raw metric.
- **Per-exercise rollup** — a derivation over `WorkoutLogState.workoutEntries`
  that groups eligible entries by exercise identity and produces, per exercise,
  an ordered list of `(session date, e1RM, top set)` points. Modeled as a typed
  record/extension alongside the existing `historyByMonth`, following its style.
- **Combined index** — a separate derivation over the per-exercise rollups
  producing the monthly index series. Isolated so it can be tested on its own.
- **Charts** — hand-rolled `CustomPaint` widgets in the workout feature's
  `widgets/` folder, matching the existing `_WeightLinePainter` style (line,
  endpoint labels, dot, tap hit-testing). No charting library is introduced.
- **Progress screen** — a new view in the workout feature replacing
  `WorkoutHistoryView`, wired to the same `Routes.workoutHistory`. The Days lens
  reuses the existing day-card / `LoggedWorkoutRow` widgets.

## Removals

- `WorkoutVolumeChart` and `volume_bar.dart` (the volume chart and its bar
  widget).
- The volume chart usage in the history view.
- `WorkoutHistoryView`'s role as the standalone history screen — its day-list UI
  is carried into the Days lens; the month-paged volume header is dropped.

The `historyByMonth` rollup on `WorkoutLogState` is retained (the Days lens uses
it), minus any volume-chart-only fields if they become unused. Persisted state
shape is unchanged — no migration needed.

## Phasing

Mirrors how the workout feature was built (one plan per phase, written
just-in-time):

- **Phase 1** — e1RM computation on the model; per-exercise rollup; the Progress
  screen with the Exercises/Days segmented control; the exercise list; the
  per-exercise detail e1RM chart; the Days lens. Remove the volume chart and
  retire `WorkoutHistoryView`.
- **Phase 2** — the Overall strength combined-index card and its derivation.

## Testing

- e1RM getter: known weight×reps → expected estimate; rep cap at 12; raw-weight
  fallback above 12; null weight/reps handling.
- Per-exercise rollup: grouping by name and `usualWorkoutId`; eligibility
  filtering (strength-only, sets with weight+reps); ordering; best-set selection.
- Combined index: baseline = first session; per-month averaging; behavior as
  exercises enter and leave; single-exercise and empty cases.
- Widget tests locate charts/rows by type, key, or icon (not by UI string),
  following the project's testing rules.

## Open questions / deferred

- Cardio progress charts — deferred pending distance/pace in the data model.
- Combined-index bucketing and carry-forward — v1 is monthly average of
  current/baseline; refine after seeing real data.
