import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template month_trends_chart}
/// A month's trends on a dark card: a line of its weigh-ins with the net weight
/// change, and a bar per logged day of calories with the month's average.
///
/// Each section appears only when it has enough data — the weight line needs at
/// least two weigh-ins, the calorie bars at least two days with calories — and
/// the whole card is hidden when neither does.
/// {@endtemplate}
class MonthTrendsChart extends StatelessWidget {
  /// {@macro month_trends_chart}
  const MonthTrendsChart({required this.monthHistory, super.key});

  /// The month whose trends are drawn.
  final HistoryMonth monthHistory;

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
            if (showWeight) _WeightTrend(weightEntries: weightEntries),
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
              ),
          ],
        ),
      ),
    );
  }
}

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
  const _WeightTrend({required this.weightEntries});

  /// The month's weigh-ins, oldest first.
  final List<WeightEntry> weightEntries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);
    final firstWeightEntry = weightEntries.first;
    final lastWeightEntry = weightEntries.last;

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
          height: 56,
          child: CustomPaint(
            painter: _WeightLinePainter(
              weights: [
                for (final weightEntry in weightEntries) weightEntry.weight,
              ],
              lineColor: colorScheme.inversePrimary,
              dotColor: colorScheme.onPrimary,
            ),
          ),
        ),
        SizedBox(height: AppDesign.spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              firstWeightEntry.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: mutedForeground,
              ),
            ),
            Text(
              lastWeightEntry.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: mutedForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A bar per logged day of the month's calories, with the average drawn as a
/// dashed reference line and labelled in the header.
class _CalorieBars extends StatelessWidget {
  const _CalorieBars({
    required this.dailyCalories,
    required this.averageCalories,
  });

  /// Each logged day's calorie total, oldest first. Days without calories are
  /// zero so they hold their place on the time axis.
  final List<int> dailyCalories;

  /// The month's average daily calories, drawn as the reference line.
  final int averageCalories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('CALORIES', style: _sectionLabelStyle(context)),
            Text(
              'avg $averageCalories',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDesign.spacing.md),
        SizedBox(
          height: 48,
          child: CustomPaint(
            painter: _CalorieBarsPainter(
              calories: dailyCalories,
              averageCalories: averageCalories,
              barColor: colorScheme.inversePrimary,
              averageLineColor: colorScheme.onPrimary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints a month's weigh-ins as a single line, evenly spaced across the width
/// and scaled to the range of weights, with a dot on the latest point.
class _WeightLinePainter extends CustomPainter {
  const _WeightLinePainter({
    required this.weights,
    required this.lineColor,
    required this.dotColor,
  });

  /// The weigh-in values, oldest first.
  final List<double> weights;
  final Color lineColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.length < 2) return;

    final minWeight = weights.reduce(min);
    final maxWeight = weights.reduce(max);
    final range = maxWeight - minWeight;
    const verticalInset = 6.0;
    final usableHeight = size.height - verticalInset * 2;

    double yFor(double weight) {
      if (range == 0) return size.height / 2;
      final normalized = (weight - minWeight) / range;
      // A higher weight sits higher on screen, so invert the normalized value.
      return verticalInset + (1 - normalized) * usableHeight;
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
  }

  @override
  bool shouldRepaint(_WeightLinePainter oldDelegate) =>
      oldDelegate.weights != weights ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor;
}

/// Paints one bar per day of calories, scaled to the highest day, with a dashed
/// horizontal line at the month's average.
class _CalorieBarsPainter extends CustomPainter {
  const _CalorieBarsPainter({
    required this.calories,
    required this.averageCalories,
    required this.barColor,
    required this.averageLineColor,
  });

  /// Each day's calorie total, oldest first.
  final List<int> calories;
  final int averageCalories;
  final Color barColor;
  final Color averageLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (calories.isEmpty) return;
    final maxCalories = calories.reduce(max);
    if (maxCalories == 0) return;

    const gap = 3.0;
    final totalGap = gap * (calories.length - 1);
    final barWidth = (size.width - totalGap) / calories.length;
    final barPaint = Paint()..color = barColor;
    for (var index = 0; index < calories.length; index++) {
      final barHeight = (calories[index] / maxCalories) * size.height;
      final left = index * (barWidth + gap);
      final bar = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      );
      canvas.drawRRect(bar, barPaint);
    }

    final averageFraction = averageCalories / maxCalories;
    final averageY = size.height - averageFraction * size.height;
    final averagePaint = Paint()
      ..color = averageLineColor
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashGap = 3.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, averageY),
        Offset(min(x + dashWidth, size.width), averageY),
        averagePaint,
      );
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(_CalorieBarsPainter oldDelegate) =>
      oldDelegate.calories != calories ||
      oldDelegate.averageCalories != averageCalories ||
      oldDelegate.barColor != barColor ||
      oldDelegate.averageLineColor != averageLineColor;
}
