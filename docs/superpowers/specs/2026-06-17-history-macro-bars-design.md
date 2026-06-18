# History macro-segmented calorie bars + tap-to-open day sheet

## Goal

On the History view's month trends card, show each day's protein / carbs / fat
inside its calorie bar (the way the today-view `NutritionBar` does), and let the
user tap a bar to open that day's meals in a bottom sheet using the same day
card shown in the month's list below.

## Current state

- `MonthTrendsChart` (`lib/app/feature/history/widgets/month_trends_chart.dart`)
  renders a private `_CalorieBars` widget, which paints solid bars via
  `_CalorieBarsPainter`. The painter receives `List<int>` daily calories plus the
  average and goal, and draws each bar in `colorScheme.inversePrimary` with a
  rounded top, overlaying a solid average line and a dashed goal line.
- The today-view `NutritionBar` (`lib/app/feature/today/widgets/nutrition_bar.dart`)
  splits a colored region into protein/carbs/fat segments sized by gram share,
  colored with `AppPalette.proteinMacro/carbsMacro/fatMacro`.
- `_HistoryDayCard` (private to `lib/app/feature/history/view/history_view.dart`)
  is an `ExpansionTile` in a `Card`, collapsed by default, that expands to the
  day's weigh-in field and meals grouped by meal time.
- `HistoryDay` is a record typedef: `{ DateTime day, Nutrition nutrition,
  WeightEntry? weightEntry, List<MealLogEntry> mealEntries }`.

## Design

### Macro segments in each bar

`_CalorieBars` takes the month's `List<HistoryDay>` (reversed to oldest-first, as
the calorie list is today) instead of a `List<int>`. The `showCalories` gate and
axis math are unchanged: a bar's height represents that day's calories against an
axis topping out at the max of the bars, the average, and the goal; the average
and goal reference lines are unchanged.

`_CalorieBarsPainter` receives per-day macro grams (e.g. a small list of
`({int calories, int protein, int carbs, int fat})` or the `List<Nutrition>`)
plus the three macro colors and the existing fallback bar color. For each bar:

- Split the bar's height into protein (bottom), carbs (middle), fat (top)
  segments sized by each macro's gram share of that day's total macro grams.
- Preserve the rounded top corners on whichever segment is topmost; lower
  segments are square. The bar is clipped to its rounded-top `RRect`, then the
  segment rects are painted inside.
- Fallback: when a day has calories but zero total macro grams, paint the whole
  bar as one solid rect in the current `inversePrimary` color so the day still
  shows.

### P/C/F legend

Add a small legend of `P  C  F` letters in the three macro colors next to the
`CALORIES` header label on the left. The existing `Goal X / avg Y` calorie legend
stays on the right, unchanged.

### Tap a bar to open the day sheet

`MonthTrendsChart` gains `required ValueChanged<HistoryDay> onDayTapped`, passed
down to `_CalorieBars`. `_CalorieBars` wraps the paint area in a `LayoutBuilder` +
`GestureDetector` (`onTapUp`), maps the tap's local x to a bar index using the
same `barWidth`/`gap` layout the painter uses, and calls `onDayTapped` with the
corresponding `HistoryDay`.

In `history_view.dart`, the `MonthTrendsChart` call site supplies `onDayTapped`,
which opens a `showModalBottomSheet` matching the existing `HistoryMealSheet`
presentation (`isScrollControlled: true`, `useSafeArea: true`,
`showDragHandle: true`) whose body is the same `_HistoryDayCard` for that day,
pre-expanded.

`_HistoryDayCard` gains an `initiallyExpanded` bool (default `false`) forwarded to
its `ExpansionTile`. The month list passes nothing (collapsed as today); the sheet
passes `true` so the meals show immediately.

## Files touched

- `lib/app/feature/history/widgets/month_trends_chart.dart` — `_CalorieBars`
  input, `_CalorieBarsPainter` macro segments, P/C/F legend, `onDayTapped`
  callback and tap hit-testing.
- `lib/app/feature/history/view/history_view.dart` — pass `onDayTapped` to
  `MonthTrendsChart` and open the sheet; add `initiallyExpanded` to
  `_HistoryDayCard`.

## Risks / verify

- `carbsMacro` is blue and the card background is `colorScheme.primary` (also
  bluish); carb segments may have low contrast. Verify visually; add a thin
  segment divider only if needed.
- Tapping a zero-calorie placeholder day (a day with only a weigh-in) opens that
  day's sheet, which is acceptable.