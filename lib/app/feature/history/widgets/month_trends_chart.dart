import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template month_trends_chart}
/// A month's trends on a dark card: a line of its weigh-ins with the net weight
/// change and the goal weight marked, and a bar per logged day of calories with
/// the month's average.
///
/// Each section appears only when it has enough data — the weight line needs at
/// least two weigh-ins, the calorie bars at least two days with calories — and
/// the whole card is hidden when neither does.
/// {@endtemplate}
class MonthTrendsChart extends StatelessWidget {
  /// {@macro month_trends_chart}
  const MonthTrendsChart({
    required this.monthHistory,
    required this.weightGoal,
    required this.weightGoalUnit,
    required this.calorieGoal,
    super.key,
  });

  /// The month whose trends are drawn.
  final HistoryMonth monthHistory;

  /// The user's target weight in [weightGoalUnit], or null when unset.
  final double? weightGoal;

  /// The unit [weightGoal] is expressed in. The goal line is only drawn when it
  /// matches the month's weigh-in unit.
  final WeightUnit weightGoalUnit;

  /// The user's daily calorie target, or null when unset.
  final int? calorieGoal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final weightEntries = monthHistory.weightEntries;
    final showWeight = weightEntries.length >= 2;

    final dailyCalories = [
      for (final historyDay in monthHistory.days.reversed)
        historyDay.nutrition.calories ?? 0,
    ];
    final showCalories =
        dailyCalories.where((calories) => calories > 0).length >= 2;

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
                weightGoal: weightGoal,
                weightGoalUnit: weightGoalUnit,
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
                dailyCalories: dailyCalories,
                averageCalories: monthHistory.averageNutrition.calories ?? 0,
                goalCalories: calorieGoal,
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
    required this.weightGoal,
    required this.weightGoalUnit,
  });

  /// The month's weigh-ins, oldest first.
  final List<WeightEntry> weightEntries;

  /// The user's target weight in [weightGoalUnit], or null when unset.
  final double? weightGoal;

  /// The unit [weightGoal] is expressed in.
  final WeightUnit weightGoalUnit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);
    final firstWeightEntry = weightEntries.first;
    final lastWeightEntry = weightEntries.last;

    // The goal is plotted raw against the weigh-ins, so only draw it when both
    // share a unit — a goal logged in a different unit would land at the wrong
    // height.
    final weightGoal = this.weightGoal;
    final goalWeight =
        weightGoal != null && weightGoalUnit == lastWeightEntry.weightUnit
        ? weightGoal
        : null;
    final goalLabel = goalWeight == null
        ? null
        : 'Goal ${goalWeight.trimmedDecimal} ${weightGoalUnit.name}';
    const goalColor = AppPalette.goalLine;
    final goalLabelStyle = theme.textTheme.labelMedium?.copyWith(
      color: goalColor,
      fontWeight: FontWeight.w600,
    );

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
              startLabel: startLabel,
              endLabel: endLabel,
              startLabelStyle: startLabelStyle,
              endLabelStyle: endLabelStyle,
              goalWeight: goalWeight,
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

/// A bar per logged day of the month's calories, with the goal and the average
/// each drawn as a labelled reference line in its own color.
class _CalorieBars extends StatelessWidget {
  const _CalorieBars({
    required this.dailyCalories,
    required this.averageCalories,
    required this.goalCalories,
  });

  /// Each logged day's calorie total, oldest first. Days without calories are
  /// zero so they hold their place on the time axis.
  final List<int> dailyCalories;

  /// The month's average daily calories, drawn as the average reference line.
  final int averageCalories;

  /// The user's daily calorie target, drawn as the goal reference line, or null
  /// when unset.
  final int? goalCalories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // The goal is the warm accent against the blue bars; the average is the
    // plain onPrimary so the two reference lines never read as the same line.
    const goalLineColor = AppPalette.goalLine;
    final averageLineColor = colorScheme.onPrimary;
    final goalCalories = this.goalCalories;

    // Each value is named in the header legend in its line's color, so the bars
    // are left clear and the two labels can't collide or overlap a tall bar.
    final legendStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CALORIES', style: _sectionLabelStyle(context)),
            Row(
              children: [
                if (goalCalories != null) ...[
                  Text(
                    'Goal $goalCalories',
                    style: legendStyle?.copyWith(color: goalLineColor),
                  ),
                  SizedBox(width: AppDesign.spacing.md),
                ],
                Text(
                  'avg $averageCalories',
                  style: legendStyle?.copyWith(color: averageLineColor),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppDesign.spacing.md),
        SizedBox(
          height: _chartHeight,
          child: CustomPaint(
            painter: _CalorieBarsPainter(
              calories: dailyCalories,
              averageCalories: averageCalories,
              goalCalories: goalCalories,
              barColor: colorScheme.inversePrimary,
              averageLineColor: averageLineColor,
              goalLineColor: goalLineColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints a month's weigh-ins as a single line, evenly spaced across the width
/// and scaled to the range of weights, with a dot on the latest point. The
/// start and current weights are labelled at the line's endpoints. When a goal
/// weight is given the axis grows to include it and it is marked with a
/// labelled dashed line, the label placed on the side of the line away from the
/// trend so the two don't overlap.
class _WeightLinePainter extends CustomPainter {
  const _WeightLinePainter({
    required this.weights,
    required this.startLabel,
    required this.endLabel,
    required this.startLabelStyle,
    required this.endLabelStyle,
    required this.goalWeight,
    required this.goalLabel,
    required this.goalLabelStyle,
    required this.lineColor,
    required this.dotColor,
    required this.goalColor,
  });

  /// The weigh-in values, oldest first.
  final List<double> weights;

  /// Label drawn at the first weigh-in, e.g. '166.7'.
  final String startLabel;

  /// Label drawn at the latest weigh-in, e.g. '164 lb'.
  final String endLabel;
  final TextStyle? startLabelStyle;
  final TextStyle? endLabelStyle;

  /// The target weight to mark, or null when unset or in a different unit than
  /// the weigh-ins.
  final double? goalWeight;

  /// The text drawn at the goal line, e.g. 'Goal 165 lb'.
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
    final goalWeight = this.goalWeight;

    // Lay the labels out first so their heights can reserve room in the plot.
    final goalLabel = this.goalLabel;
    final labelPainter = goalWeight != null && goalLabel != null
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

    // The axis spans both the weigh-ins and the goal so the goal line sits at
    // its true height relative to the trend.
    final axisMin = goalWeight == null ? dataMin : min(dataMin, goalWeight);
    final axisMax = goalWeight == null ? dataMax : max(dataMax, goalWeight);
    final axisRange = axisMax - axisMin;

    // Reserve a band at the top for the endpoint labels, which sit above their
    // points, and the goal label on the side of its line away from the trend —
    // below when the goal is under the trend, above when over it — so nothing
    // overlaps or clips the edge.
    final meanWeight = weights.reduce((a, b) => a + b) / weights.length;
    final labelBelowLine = goalWeight == null || goalWeight < meanWeight;
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

    if (goalWeight != null) {
      final goalY = yFor(goalWeight);
      final goalPaint = Paint()
        ..color = goalColor
        ..strokeWidth = 1;
      const dashWidth = 4.0;
      const dashGap = 3.0;
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, goalY),
          Offset(min(x + dashWidth, size.width), goalY),
          goalPaint,
        );
        x += dashWidth + dashGap;
      }
      if (labelPainter != null) {
        // ignore: prefer_int_literals
        final labelX = max(0.0, size.width - labelPainter.width);
        final labelY = labelBelowLine
            ? goalY + 2
            : goalY - labelPainter.height - 2;
        labelPainter.paint(canvas, Offset(labelX, labelY));
      }
    }

    final horizontalStep = size.width / (weights.length - 1);
    final points = [
      for (var index = 0; index < weights.length; index++)
        Offset(index * horizontalStep, yFor(weights[index])),
    ];

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

  // The widget rebuilds this painter with a freshly built [weights] list every
  // time, so the leading identity comparison is always true and the rest of the
  // chain can't be reached from a test (the painter is private, so it can't be
  // driven directly either).
  // coverage:ignore-start
  @override
  bool shouldRepaint(_WeightLinePainter oldDelegate) =>
      oldDelegate.weights != weights ||
      oldDelegate.startLabel != startLabel ||
      oldDelegate.endLabel != endLabel ||
      oldDelegate.startLabelStyle != startLabelStyle ||
      oldDelegate.endLabelStyle != endLabelStyle ||
      oldDelegate.goalWeight != goalWeight ||
      oldDelegate.goalLabel != goalLabel ||
      oldDelegate.goalLabelStyle != goalLabelStyle ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor ||
      oldDelegate.goalColor != goalColor;
  // coverage:ignore-end
}

/// Paints one bar per day of calories, with the goal and the average each drawn
/// as a solid horizontal line in its own color. The values are named in the
/// header legend rather than on the lines, so the bars stay clear. The axis
/// tops out at the tallest of the bars and the two lines so neither is clipped.
class _CalorieBarsPainter extends CustomPainter {
  const _CalorieBarsPainter({
    required this.calories,
    required this.averageCalories,
    required this.goalCalories,
    required this.barColor,
    required this.averageLineColor,
    required this.goalLineColor,
  });

  /// Each day's calorie total, oldest first.
  final List<int> calories;
  final int averageCalories;

  /// The user's daily calorie target, or null when unset.
  final int? goalCalories;
  final Color barColor;
  final Color averageLineColor;
  final Color goalLineColor;

  /// Headroom above the tallest bar so the topmost line isn't flush to the top.
  static const double _topInset = 6;

  @override
  void paint(Canvas canvas, Size size) {
    if (calories.isEmpty) return;
    final maxCalories = calories.reduce(max);
    if (maxCalories == 0) return;

    final goalCalories = this.goalCalories;

    // The axis tops out at the tallest of the bars and the two reference lines
    // so neither line is clipped when the goal or average exceeds every day.
    var axisMax = max(maxCalories, averageCalories).toDouble();
    if (goalCalories != null) {
      axisMax = max(axisMax, goalCalories.toDouble());
    }

    final plotBottom = size.height;
    final plotHeight = plotBottom - _topInset;

    double yFor(double value) => plotBottom - (value / axisMax) * plotHeight;

    const gap = 3.0;
    final totalGap = gap * (calories.length - 1);
    final barWidth = (size.width - totalGap) / calories.length;
    final barPaint = Paint()..color = barColor;
    for (var index = 0; index < calories.length; index++) {
      final barTop = yFor(calories[index].toDouble());
      final left = index * (barWidth + gap);
      final bar = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, barTop, barWidth, plotBottom - barTop),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      );
      canvas.drawRRect(bar, barPaint);
    }

    void drawReferenceLine(double value, Color color, {required bool dashed}) {
      final y = yFor(value);
      final linePaint = Paint()..color = color;
      if (dashed) {
        linePaint.strokeWidth = 1;
        const dashWidth = 4.0;
        const dashGap = 3.0;
        var x = 0.0;
        while (x < size.width) {
          canvas.drawLine(
            Offset(x, y),
            Offset(min(x + dashWidth, size.width), y),
            linePaint,
          );
          x += dashWidth + dashGap;
        }
      } else {
        linePaint.strokeWidth = 1.5;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      }
    }

    if (goalCalories != null) {
      drawReferenceLine(goalCalories.toDouble(), goalLineColor, dashed: true);
    }
    drawReferenceLine(
      averageCalories.toDouble(),
      averageLineColor,
      dashed: false,
    );
  }

  // As with the weight painter, the freshly built [calories] list makes the
  // leading comparison always true, so the rest of the chain is unreachable
  // from a test and the painter is private.
  // coverage:ignore-start
  @override
  bool shouldRepaint(_CalorieBarsPainter oldDelegate) =>
      oldDelegate.calories != calories ||
      oldDelegate.averageCalories != averageCalories ||
      oldDelegate.goalCalories != goalCalories ||
      oldDelegate.barColor != barColor ||
      oldDelegate.averageLineColor != averageLineColor ||
      oldDelegate.goalLineColor != goalLineColor;
  // coverage:ignore-end
}
