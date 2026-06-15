import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template month_weight_chart}
/// A month's weigh-ins drawn as a line on a dark card, with the net change in
/// weight from the first weigh-in to the last. Renders nothing when the month
/// has fewer than two weigh-ins, since a line needs at least two points.
/// {@endtemplate}
class MonthWeightChart extends StatelessWidget {
  /// {@macro month_weight_chart}
  const MonthWeightChart({required this.weightEntries, super.key});

  /// The month's weigh-ins, oldest first.
  final List<WeightEntry> weightEntries;

  @override
  Widget build(BuildContext context) {
    if (weightEntries.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);
    final firstWeightEntry = weightEntries.first;
    final lastWeightEntry = weightEntries.last;

    Widget header() {
      // Weigh-ins are entered to a single decimal, so round the difference to
      // match and drop the floating-point error subtraction introduces.
      final change =
          ((lastWeightEntry.weight - firstWeightEntry.weight) * 10).round() /
          10;
      final unit = lastWeightEntry.weightUnit.name;
      final String trailing;
      if (change == 0) {
        trailing = 'No change';
      } else {
        final arrow = change < 0 ? '▼' : '▲';
        trailing = '$arrow ${change.abs().trimmedDecimal} $unit';
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'WEIGHT',
            style: theme.textTheme.labelSmall?.copyWith(
              color: mutedForeground,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            trailing,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      );
    }

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
            header(),
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
        ),
      ),
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
