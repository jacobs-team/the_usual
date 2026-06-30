import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template month_trends_chart}
/// A month's trends on a dark card: a line of its weigh-ins with the net weight
/// change and the goal weight marked, and a bar per logged day of calories with
/// the month's average.
///
/// Goals are dated: each weigh-in and each day is marked against the goal that
/// was active on its date, so a goal changed mid-history shows as staggered
/// reference lines rather than one line redrawn at the latest value.
///
/// Each section appears only when it has enough data — the weight line needs at
/// least two weigh-ins, the calorie bars at least two days with calories — and
/// the whole card is hidden when neither does.
/// {@endtemplate}
class MonthTrendsChart extends StatelessWidget {
  /// {@macro month_trends_chart}
  const MonthTrendsChart({
    required this.monthHistory,
    required this.weightGoalHistory,
    required this.calorieGoalHistory,
    required this.onDayTapped,
    super.key,
  });

  /// The month whose trends are drawn.
  final HistoryMonth monthHistory;

  /// The dated history of the user's target weight, oldest first.
  final List<WeightGoalEntry> weightGoalHistory;

  /// The dated history of the user's daily calorie target, oldest first.
  final List<CalorieGoalEntry> calorieGoalHistory;

  /// Called with a day when its calorie bar is tapped, so the caller can open
  /// that day's detail sheet.
  final ValueChanged<HistoryDay> onDayTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final weightEntries = monthHistory.weightEntries;
    final showWeight = weightEntries.length >= 2;

    final orderedDays = monthHistory.days.reversed.toList();
    final showCalories =
        orderedDays
            .where((historyDay) => (historyDay.nutrition.calories ?? 0) > 0)
            .length >=
        2;

    if (!showWeight && !showCalories) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppDesign.spacing.lg),
      child: Container(
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(AppDesign.radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showWeight)
              _WeightTrend(
                weightEntries: weightEntries,
                weightGoalHistory: weightGoalHistory,
              ),
            if (showWeight && showCalories)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDesign.spacing.md),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.onPrimary.withValues(alpha: 0.15),
                ),
              ),
            if (showCalories)
              _CalorieBars(
                days: orderedDays,
                averageCalories: monthHistory.averageNutrition.calories ?? 0.0,
                calorieGoalHistory: calorieGoalHistory,
                onDayTapped: onDayTapped,
              ),
          ],
        ),
      ),
    );
  }
}

/// The plotted height each section's chart is given, so the weight line and the
/// calorie bars take equal portions of the card.
const double _chartHeight = 84;

/// Width of the gap between calorie bars, shared by the painter and the tap
/// hit-test so a tap resolves to the same bar the painter drew.
const double _barGap = 3;

/// The card's section label style: a small, spaced, muted uppercase caption.
TextStyle? _sectionLabelStyle(BuildContext context) {
  final theme = Theme.of(context);
  return theme.textTheme.labelSmall?.copyWith(
    color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

/// The weigh-in line for a month, with the net change from first to last and
/// the first and last weights below it. Expects at least two weigh-ins.
class _WeightTrend extends StatelessWidget {
  const _WeightTrend({
    required this.weightEntries,
    required this.weightGoalHistory,
  });

  /// The month's weigh-ins, oldest first.
  final List<WeightEntry> weightEntries;

  /// The dated history of the user's target weight, oldest first.
  final List<WeightGoalEntry> weightGoalHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);
    final firstWeightEntry = weightEntries.first;
    final lastWeightEntry = weightEntries.last;

    // Mark each weigh-in against the goal active on its date, in that
    // weigh-in's unit. A goal in a different unit is dropped for that point,
    // since it would plot at the wrong height against the trend.
    final goalWeights = <double?>[];
    for (final weightEntry in weightEntries) {
      final activeGoal = weightGoalHistory.goalOn(weightEntry.loggedAt);
      final matchesUnit = activeGoal?.weightUnit == weightEntry.weightUnit;
      goalWeights.add(matchesUnit ? activeGoal!.weight : null);
    }

    // The legend names the goal active at the latest weigh-in, the value the
    // user is currently working toward.
    final latestGoal = goalWeights.lastWhere(
      (goal) => goal != null,
      orElse: () => null,
    );
    final goalLabel = latestGoal == null
        ? null
        : 'Goal ${latestGoal.trimmedDecimal} '
              '${lastWeightEntry.weightUnit.name}';
    const goalColor = AppPalette.goalLine;

    // Weigh-ins are entered to a single decimal, so round the difference to
    // match and drop the floating-point error subtraction introduces.
    final rawChange = lastWeightEntry.weight - firstWeightEntry.weight;
    final change = (rawChange * 10).round() / 10;
    final unit = lastWeightEntry.weightUnit.name;
    final String netChange;
    if (change == 0) {
      netChange = 'No change';
    } else {
      final arrow = change < 0 ? '▼' : '▲';
      netChange = '$arrow ${change.abs().trimmedDecimal} $unit';
    }

    // Annotate the line's endpoints: the start weight unadorned, the current
    // weight emphasized and carrying the unit, since it's the number the user
    // checks first.
    final startLabel = firstWeightEntry.weight.trimmedDecimal;
    final endLabel = lastWeightEntry.label;
    final startLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: mutedForeground,
    );
    final endLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onPrimary,
      fontWeight: FontWeight.w600,
    );
    final goalLabelStyle = theme.textTheme.labelMedium?.copyWith(
      color: goalColor,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('WEIGHT', style: _sectionLabelStyle(context)),
            Text(
              netChange,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDesign.spacing.md),
        SizedBox(
          height: _chartHeight,
          child: CustomPaint(
            painter: _WeightLinePainter(
              weights: [
                for (final weightEntry in weightEntries) weightEntry.weight,
              ],
              goalWeights: goalWeights,
              startLabel: startLabel,
              endLabel: endLabel,
              startLabelStyle: startLabelStyle,
              endLabelStyle: endLabelStyle,
              goalLabel: goalLabel,
              goalLabelStyle: goalLabelStyle,
              lineColor: colorScheme.inversePrimary,
              dotColor: colorScheme.onPrimary,
              goalColor: goalColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// A bar per logged day: its height the day's calories, its fill split into
/// protein, carbs, and fat segments sized by gram share in the same macro
/// colors as the today view. The goal active on each day and the month's
/// average are each drawn as a reference line in its own color. Tapping a bar
/// reports its day.
class _CalorieBars extends StatelessWidget {
  const _CalorieBars({
    required this.days,
    required this.averageCalories,
    required this.calorieGoalHistory,
    required this.onDayTapped,
  });

  /// Each logged day, oldest first. Days without calories hold their place on
  /// the time axis with no bar drawn.
  final List<HistoryDay> days;

  /// The month's average daily calories, drawn as the average reference line.
  final double averageCalories;

  /// The dated history of the user's daily calorie target, oldest first.
  final List<CalorieGoalEntry> calorieGoalHistory;

  /// Called with the day whose bar (or column) was tapped.
  final ValueChanged<HistoryDay> onDayTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // The goal is the warm accent against the blue bars; the average is the
    // plain onPrimary so the two reference lines never read as the same line.
    const goalLineColor = AppPalette.goalLine;
    final averageLineColor = colorScheme.onPrimary;

    // The goal active on each day, so a goal changed mid-month staggers across
    // the bars rather than redrawing at the latest value.
    final goalCalories = [
      for (final historyDay in days) calorieGoalHistory.goalOn(historyDay.day),
    ];
    final latestGoal = goalCalories.lastWhere(
      (goal) => goal != null,
      orElse: () => null,
    );

    const proteinColor = AppPalette.proteinMacro;
    const carbsColor = AppPalette.carbsMacro;
    const fatColor = AppPalette.fatMacro;

    // The goal and average are named in the header legend in their line's color
    // so the bars stay clear; the macros are keyed by a P/C/F swatch legend
    // since the bars are too thin to label each segment inline.
    final legendStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    final macroLegend = [
      (letter: 'P', color: proteinColor),
      (letter: 'C', color: carbsColor),
      (letter: 'F', color: fatColor),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CALORIES', style: _sectionLabelStyle(context)),
                Row(
                  children: [
                    for (final macro in macroLegend)
                      Padding(
                        padding: EdgeInsets.only(right: AppDesign.spacing.xs),
                        child: Text(
                          macro.letter,
                          style: legendStyle?.copyWith(color: macro.color),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (latestGoal != null) ...[
                  Text(
                    'Goal $latestGoal',
                    style: legendStyle?.copyWith(color: goalLineColor),
                  ),
                  SizedBox(width: AppDesign.spacing.md),
                ],
                Text(
                  'Avg ${averageCalories.rounded}',
                  style: legendStyle?.copyWith(color: averageLineColor),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppDesign.spacing.md),
        SizedBox(
          height: _chartHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final totalGap = _barGap * (days.length - 1);
                  final slotWidth =
                      (constraints.maxWidth - totalGap) / days.length + _barGap;
                  final tappedIndex = (details.localPosition.dx / slotWidth)
                      .floor()
                      .clamp(0, days.length - 1);
                  onDayTapped(days[tappedIndex]);
                },
                child: CustomPaint(
                  painter: _CalorieBarsPainter(
                    nutritions: [
                      for (final historyDay in days) historyDay.nutrition,
                    ],
                    averageCalories: averageCalories,
                    goalCalories: goalCalories,
                    proteinColor: proteinColor,
                    carbsColor: carbsColor,
                    fatColor: fatColor,
                    fallbackBarColor: colorScheme.inversePrimary,
                    averageLineColor: averageLineColor,
                    goalLineColor: goalLineColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Draws a dashed horizontal line across [xStart]..[xEnd] at [y].
void _drawDashedHorizontal(
  Canvas canvas,
  Paint paint,
  double xStart,
  double xEnd,
  double y,
) {
  const dashWidth = 4.0;
  const dashGap = 3.0;
  var x = xStart;
  while (x < xEnd) {
    canvas.drawLine(Offset(x, y), Offset(min(x + dashWidth, xEnd), y), paint);
    x += dashWidth + dashGap;
  }
}

/// Draws the dated goal as a stepped dashed line over a chart whose points sit
/// at [slotCenters]: a horizontal run for each stretch of days sharing a goal,
/// joined by a vertical connector wherever the goal changes. [goalYs] holds the
/// y of each point's goal, null where no goal applies. Runs span from the
/// midpoint before their first point to the midpoint after their last, with the
/// outermost runs reaching the chart edges.
void _paintSteppedGoal(
  Canvas canvas,
  Paint paint,
  List<double?> goalYs,
  List<double> slotCenters,
  double width,
) {
  double runLeft(int index) =>
      index == 0 ? 0 : (slotCenters[index - 1] + slotCenters[index]) / 2;
  double runRight(int index) => index == slotCenters.length - 1
      ? width
      : (slotCenters[index] + slotCenters[index + 1]) / 2;

  var index = 0;
  double? previousY;
  double? previousRight;
  while (index < goalYs.length) {
    final y = goalYs[index];
    if (y == null) {
      previousY = null;
      previousRight = null;
      index++;
      continue;
    }
    var end = index;
    while (end + 1 < goalYs.length && goalYs[end + 1] == y) {
      end++;
    }
    final left = runLeft(index);
    _drawDashedHorizontal(canvas, paint, left, runRight(end), y);
    // Connect to the previous run when they're adjacent (no gap of missing
    // goal between them), so a goal change reads as a single stepped line.
    if (previousY != null &&
        previousRight != null &&
        (left - previousRight).abs() < 0.5) {
      canvas.drawLine(Offset(left, previousY), Offset(left, y), paint);
    }
    previousY = y;
    previousRight = runRight(end);
    index = end + 1;
  }
}

/// Paints a month's weigh-ins as a single line, evenly spaced across the width
/// and scaled to the range of weights, with a dot on the latest point. The
/// start and current weights are labelled at the line's endpoints. The dated
/// goal is drawn as a stepped dashed line — one horizontal run per stretch of
/// weigh-ins sharing a goal — with the latest goal labelled, the label placed
/// on the side of its line away from the trend so the two don't overlap.
class _WeightLinePainter extends CustomPainter {
  const _WeightLinePainter({
    required this.weights,
    required this.goalWeights,
    required this.startLabel,
    required this.endLabel,
    required this.startLabelStyle,
    required this.endLabelStyle,
    required this.goalLabel,
    required this.goalLabelStyle,
    required this.lineColor,
    required this.dotColor,
    required this.goalColor,
  });

  /// The weigh-in values, oldest first.
  final List<double> weights;

  /// The goal active at each weigh-in, aligned to [weights], in that weigh-in's
  /// unit. Null where no goal applies or it was set in a different unit.
  final List<double?> goalWeights;

  /// Label drawn at the first weigh-in, e.g. '166.7'.
  final String startLabel;

  /// Label drawn at the latest weigh-in, e.g. '164 lb'.
  final String endLabel;
  final TextStyle? startLabelStyle;
  final TextStyle? endLabelStyle;

  /// The text drawn at the latest goal line, e.g. 'Goal 165 lb', or null when
  /// no goal applies to any weigh-in.
  final String? goalLabel;
  final TextStyle? goalLabelStyle;
  final Color lineColor;
  final Color dotColor;
  final Color goalColor;

  static const double _verticalInset = 6;

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    final dataMin = weights.reduce(min);
    final dataMax = weights.reduce(max);
    final goalValues = [for (final goalWeight in goalWeights) ?goalWeight];
    final hasGoal = goalValues.isNotEmpty;

    // Lay the labels out first so their heights can reserve room in the plot.
    final goalLabel = this.goalLabel;
    final labelPainter = hasGoal && goalLabel != null
        ? (TextPainter(
            text: TextSpan(text: goalLabel, style: goalLabelStyle),
            textDirection: TextDirection.ltr,
          )..layout())
        : null;
    final startLabelPainter = TextPainter(
      text: TextSpan(text: startLabel, style: startLabelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    final endLabelPainter = TextPainter(
      text: TextSpan(text: endLabel, style: endLabelStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    // The axis spans both the weigh-ins and every goal so each goal line sits
    // at its true height relative to the trend.
    final axisMin = hasGoal ? min(dataMin, goalValues.reduce(min)) : dataMin;
    final axisMax = hasGoal ? max(dataMax, goalValues.reduce(max)) : dataMax;
    final axisRange = axisMax - axisMin;

    // Reserve a band at the top for the endpoint labels, which sit above their
    // points, and the goal label on the side of its line away from the trend —
    // below when the goal is under the trend, above when over it — so nothing
    // overlaps or clips the edge.
    final meanWeight = weights.reduce((a, b) => a + b) / weights.length;
    final latestGoal = goalValues.isEmpty ? null : goalValues.last;
    final labelBelowLine = latestGoal == null || latestGoal < meanWeight;
    final goalBand = labelPainter == null ? 0.0 : labelPainter.height + 2;
    final endpointBand =
        max(startLabelPainter.height, endLabelPainter.height) + 2;
    final plotTop =
        _verticalInset + endpointBand + (labelBelowLine ? 0.0 : goalBand);
    final plotBottom =
        size.height - _verticalInset - (labelBelowLine ? goalBand : 0.0);
    final plotHeight = plotBottom - plotTop;

    double yFor(double weight) {
      if (axisRange == 0) return (plotTop + plotBottom) / 2;
      final normalized = (weight - axisMin) / axisRange;
      // A higher weight sits higher on screen, so invert the normalized value.
      return plotTop + (1 - normalized) * plotHeight;
    }

    final horizontalStep = size.width / (weights.length - 1);
    final points = [
      for (var index = 0; index < weights.length; index++)
        Offset(index * horizontalStep, yFor(weights[index])),
    ];

    if (hasGoal) {
      final goalPaint = Paint()
        ..color = goalColor
        ..strokeWidth = 1;
      final goalYs = [
        for (final goalWeight in goalWeights)
          goalWeight == null ? null : yFor(goalWeight),
      ];
      _paintSteppedGoal(
        canvas,
        goalPaint,
        goalYs,
        [for (final point in points) point.dx],
        size.width,
      );
      if (labelPainter != null && latestGoal != null) {
        final goalY = yFor(latestGoal);
        // ignore: prefer_int_literals
        final labelX = max(0.0, size.width - labelPainter.width);
        final labelY = labelBelowLine
            ? goalY + 2
            : goalY - labelPainter.height - 2;
        labelPainter.paint(canvas, Offset(labelX, labelY));
      }
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(linePath, linePaint)
      ..drawCircle(points.last, 3, Paint()..color = dotColor);

    // The endpoint labels sit above their points, anchored to the chart edges.
    final startLabelY = max(
      _verticalInset,
      points.first.dy - 2 - startLabelPainter.height,
    );
    startLabelPainter.paint(canvas, Offset(points.first.dx, startLabelY));
    final endLabelY = max(
      _verticalInset,
      points.last.dy - 2 - endLabelPainter.height,
    );
    endLabelPainter.paint(
      canvas,
      Offset(points.last.dx - endLabelPainter.width, endLabelY),
    );
  }

  // The widget rebuilds this painter with freshly built lists every time, so
  // the leading identity comparison is always true and the rest of the chain
  // can't be reached from a test (the painter is private, so it can't be driven
  // directly either).
  // coverage:ignore-start
  @override
  bool shouldRepaint(_WeightLinePainter oldDelegate) =>
      oldDelegate.weights != weights ||
      oldDelegate.goalWeights != goalWeights ||
      oldDelegate.startLabel != startLabel ||
      oldDelegate.endLabel != endLabel ||
      oldDelegate.startLabelStyle != startLabelStyle ||
      oldDelegate.endLabelStyle != endLabelStyle ||
      oldDelegate.goalLabel != goalLabel ||
      oldDelegate.goalLabelStyle != goalLabelStyle ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor ||
      oldDelegate.goalColor != goalColor;
  // coverage:ignore-end
}

/// Paints one bar per day: its height the day's calories, its fill split into
/// protein, carbs, and fat segments sized by each macro's gram share. A day
/// with calories but no logged macros fills as one solid bar in
/// [fallbackBarColor]. The dated goal is drawn as a stepped dashed line — one
/// horizontal run per stretch of days sharing a goal — and the average as a
/// solid line, each named in the header legend rather than on the lines so the
/// bars stay clear. The axis tops out at the tallest of the bars and the lines
/// so none is clipped.
class _CalorieBarsPainter extends CustomPainter {
  const _CalorieBarsPainter({
    required this.nutritions,
    required this.averageCalories,
    required this.goalCalories,
    required this.proteinColor,
    required this.carbsColor,
    required this.fatColor,
    required this.fallbackBarColor,
    required this.averageLineColor,
    required this.goalLineColor,
  });

  /// Each day's nutrition total, oldest first.
  final List<Nutrition> nutritions;
  final double averageCalories;

  /// The goal active on each day, aligned to [nutritions]. Null where no goal
  /// applies that day.
  final List<int?> goalCalories;
  final Color proteinColor;
  final Color carbsColor;
  final Color fatColor;

  /// Fill for a day that has calories but no macro breakdown to split.
  final Color fallbackBarColor;
  final Color averageLineColor;
  final Color goalLineColor;

  /// Headroom above the tallest bar so the topmost line isn't flush to the top.
  static const double _topInset = 6;

  @override
  void paint(Canvas canvas, Size size) {
    if (nutritions.isEmpty) return;
    final dailyCalories = [
      for (final nutrition in nutritions) nutrition.calories ?? 0,
    ];
    final maxCalories = dailyCalories.reduce(max);
    if (maxCalories == 0) return;

    final goalValues = [for (final goal in goalCalories) ?goal];

    // The axis tops out at the tallest of the bars and the reference lines so
    // no line is clipped when the goal or average exceeds every day.
    var axisMax = max(maxCalories, averageCalories);
    for (final goal in goalValues) {
      axisMax = max(axisMax, goal.toDouble());
    }

    final plotBottom = size.height;
    final plotHeight = plotBottom - _topInset;

    double yFor(double value) => plotBottom - (value / axisMax) * plotHeight;

    final totalGap = _barGap * (nutritions.length - 1);
    final barWidth = (size.width - totalGap) / nutritions.length;
    final barCenters = [
      for (var index = 0; index < nutritions.length; index++)
        index * (barWidth + _barGap) + barWidth / 2,
    ];
    for (var index = 0; index < nutritions.length; index++) {
      final nutrition = nutritions[index];
      final calories = nutrition.calories ?? 0;
      if (calories == 0) continue;

      final barTop = yFor(calories);
      final left = index * (barWidth + _barGap);
      final barHeight = plotBottom - barTop;
      final bar = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, barTop, barWidth, barHeight),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      );

      final macroSegments = [
        (grams: nutrition.protein ?? 0, color: proteinColor),
        (grams: nutrition.carbs ?? 0, color: carbsColor),
        (grams: nutrition.fat ?? 0, color: fatColor),
      ];
      final totalGrams = macroSegments.fold<double>(
        0,
        (sum, macroSegment) => sum + macroSegment.grams,
      );

      // No macros to split: fill the whole bar so the day still shows.
      if (totalGrams == 0) {
        canvas.drawRRect(bar, Paint()..color = fallbackBarColor);
        continue;
      }

      // Clip to the rounded bar so the stacked segments share its top corners,
      // then fill from the bottom up: protein, carbs, fat.
      canvas
        ..save()
        ..clipRRect(bar);
      var segmentBottom = plotBottom;
      for (final macroSegment in macroSegments) {
        if (macroSegment.grams == 0) continue;
        final segmentHeight = barHeight * macroSegment.grams / totalGrams;
        final segmentTop = segmentBottom - segmentHeight;
        canvas.drawRect(
          Rect.fromLTRB(left, segmentTop, left + barWidth, segmentBottom),
          Paint()..color = macroSegment.color,
        );
        segmentBottom = segmentTop;
      }
      canvas.restore();
    }

    if (goalValues.isNotEmpty) {
      final goalPaint = Paint()
        ..color = goalLineColor
        ..strokeWidth = 1;
      final goalYs = [
        for (final goal in goalCalories)
          goal == null ? null : yFor(goal.toDouble()),
      ];
      _paintSteppedGoal(canvas, goalPaint, goalYs, barCenters, size.width);
    }

    final averageY = yFor(averageCalories);
    canvas.drawLine(
      Offset(0, averageY),
      Offset(size.width, averageY),
      Paint()
        ..color = averageLineColor
        ..strokeWidth = 1.5,
    );
  }

  // As with the weight painter, the freshly built lists make the leading
  // comparison always true, so the rest of the chain is unreachable from a test
  // and the painter is private.
  // coverage:ignore-start
  @override
  bool shouldRepaint(_CalorieBarsPainter oldDelegate) =>
      oldDelegate.nutritions != nutritions ||
      oldDelegate.averageCalories != averageCalories ||
      oldDelegate.goalCalories != goalCalories ||
      oldDelegate.proteinColor != proteinColor ||
      oldDelegate.carbsColor != carbsColor ||
      oldDelegate.fatColor != fatColor ||
      oldDelegate.fallbackBarColor != fallbackBarColor ||
      oldDelegate.averageLineColor != averageLineColor ||
      oldDelegate.goalLineColor != goalLineColor;
  // coverage:ignore-end
}
