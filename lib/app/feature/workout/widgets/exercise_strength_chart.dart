import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercise_strength_chart}
/// One exercise's estimated one-rep max over time, drawn as a line on a dark
/// card with the net change from the first session to the latest. Tapping the
/// chart selects the nearest session and reports it. Renders nothing with fewer
/// than two sessions, since a line needs at least two points.
/// {@endtemplate}
class ExerciseStrengthChart extends StatelessWidget {
  /// {@macro exercise_strength_chart}
  const ExerciseStrengthChart({
    required this.points,
    required this.weightUnit,
    required this.onPointSelected,
    super.key,
  });

  /// The exercise's session points, oldest first.
  final List<ExerciseStrengthPoint> points;

  /// The unit shown in the header net-change label.
  final WeightUnit weightUnit;

  /// Called with the session nearest a tap.
  final ValueChanged<ExerciseStrengthPoint> onPointSelected;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);

    final estimates = [
      for (final point in points) point.estimatedOneRepMax,
    ];
    final rawChange = estimates.last - estimates.first;
    final change = (rawChange * 10).round() / 10;
    final String netChange;
    if (change == 0) {
      netChange = 'No change';
    } else {
      final arrow = change < 0 ? '▼' : '▲';
      netChange = '$arrow ${change.abs().trimmedDecimal} ${weightUnit.name}';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'STRENGTH',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedForeground,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
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
              height: 84,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final step = points.length == 1
                          ? constraints.maxWidth
                          : constraints.maxWidth / (points.length - 1);
                      final index = (details.localPosition.dx / step)
                          .round()
                          .clamp(0, points.length - 1);
                      onPointSelected(points[index]);
                    },
                    child: CustomPaint(
                      painter: _StrengthLinePainter(
                        estimates: estimates,
                        lineColor: colorScheme.inversePrimary,
                        dotColor: colorScheme.onPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppDesign.spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  estimates.first.trimmedDecimal,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: mutedForeground,
                  ),
                ),
                Text(
                  '${estimates.last.trimmedDecimal} ${weightUnit.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
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

/// Paints the e1RM values as a single line, evenly spaced across the width and
/// scaled to their range, with a dot on the latest point.
class _StrengthLinePainter extends CustomPainter {
  const _StrengthLinePainter({
    required this.estimates,
    required this.lineColor,
    required this.dotColor,
  });

  final List<double> estimates;
  final Color lineColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (estimates.length < 2) return;

    final minEstimate = estimates.reduce(min);
    final maxEstimate = estimates.reduce(max);
    final range = maxEstimate - minEstimate;
    const verticalInset = 6.0;
    final usableHeight = size.height - verticalInset * 2;

    double yFor(double estimate) {
      if (range == 0) return size.height / 2;
      final normalized = (estimate - minEstimate) / range;
      return verticalInset + (1 - normalized) * usableHeight;
    }

    final horizontalStep = size.width / (estimates.length - 1);
    final dataPoints = [
      for (var index = 0; index < estimates.length; index++)
        Offset(index * horizontalStep, yFor(estimates[index])),
    ];

    final linePath = Path()..moveTo(dataPoints.first.dx, dataPoints.first.dy);
    for (final point in dataPoints.skip(1)) {
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
      ..drawCircle(dataPoints.last, 3, Paint()..color = dotColor);
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(_StrengthLinePainter oldDelegate) =>
      oldDelegate.estimates != estimates ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor;
  // coverage:ignore-end
}
