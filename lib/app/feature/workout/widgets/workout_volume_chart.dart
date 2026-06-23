import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workout_volume_chart}
/// A month's workout volume on a dark card: one bar per logged day sized by
/// that day's total volume, with a solid average reference line. Tapping a bar
/// reports the corresponding day. The card is hidden when fewer than two days
/// have volume.
/// {@endtemplate}
class WorkoutVolumeChart extends StatelessWidget {
  /// {@macro workout_volume_chart}
  const WorkoutVolumeChart({
    required this.monthHistory,
    required this.weightUnit,
    required this.onDayTapped,
    super.key,
  });

  /// The month whose volume is drawn.
  final WorkoutHistoryMonth monthHistory;

  /// The unit used for the axis label.
  final WeightUnit weightUnit;

  /// Called with the day whose bar (or column) was tapped.
  final ValueChanged<WorkoutHistoryDay> onDayTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Days are stored newest-first; reverse to oldest-first for the time axis.
    final orderedDays = monthHistory.days.reversed.toList();
    final daysWithVolume =
        orderedDays.where((d) => d.volume > 0).length;

    if (daysWithVolume < 2) return const SizedBox.shrink();

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
              children: [
                Text(
                  'VOLUME',
                  style: _sectionLabelStyle(context),
                ),
                Text(
                  weightUnit.name,
                  style: _sectionLabelStyle(context),
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
                      final totalGap =
                          _barGap * (orderedDays.length - 1);
                      final slotWidth =
                          (constraints.maxWidth - totalGap) /
                              orderedDays.length +
                          _barGap;
                      final tappedIndex =
                          (details.localPosition.dx / slotWidth)
                              .floor()
                              .clamp(0, orderedDays.length - 1);
                      onDayTapped(orderedDays[tappedIndex]);
                    },
                    child: CustomPaint(
                      painter: _VolumeBarsPainter(
                        volumes: [
                          for (final d in orderedDays) d.volume,
                        ],
                        averageVolume: monthHistory.averageVolume,
                        barColor: colorScheme.inversePrimary,
                        averageLineColor: colorScheme.onPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const double _chartHeight = 84;
const double _barGap = 3;

TextStyle? _sectionLabelStyle(BuildContext context) {
  final theme = Theme.of(context);
  return theme.textTheme.labelSmall?.copyWith(
    color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

/// Paints one bar per day sized by its volume, plus a solid average line.
class _VolumeBarsPainter extends CustomPainter {
  const _VolumeBarsPainter({
    required this.volumes,
    required this.averageVolume,
    required this.barColor,
    required this.averageLineColor,
  });

  /// Each day's total volume, oldest first.
  final List<double> volumes;

  /// The month's average daily volume, drawn as a solid reference line.
  final double averageVolume;

  final Color barColor;
  final Color averageLineColor;

  static const double _topInset = 6;

  @override
  void paint(Canvas canvas, Size size) {
    if (volumes.isEmpty) return;
    final maxVolume = volumes.reduce(max);
    // Axis tops out at the taller of the bars and the average line.
    final axisMax = max(maxVolume, averageVolume);
    if (axisMax == 0) return;

    final plotBottom = size.height;
    final plotHeight = plotBottom - _topInset;

    double yFor(double value) =>
        plotBottom - (value / axisMax) * plotHeight;

    final totalGap = _barGap * (volumes.length - 1);
    final barWidth = (size.width - totalGap) / volumes.length;

    for (var index = 0; index < volumes.length; index++) {
      final volume = volumes[index];
      if (volume == 0) continue;

      final barTop = yFor(volume);
      final left = index * (barWidth + _barGap);
      final barHeight = plotBottom - barTop;
      final bar = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, barTop, barWidth, barHeight),
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      );
      canvas.drawRRect(bar, Paint()..color = barColor);
    }

    final averageY = yFor(averageVolume);
    canvas.drawLine(
      Offset(0, averageY),
      Offset(size.width, averageY),
      Paint()
        ..color = averageLineColor
        ..strokeWidth = 1.5,
    );
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(_VolumeBarsPainter oldDelegate) =>
      oldDelegate.volumes != volumes ||
      oldDelegate.averageVolume != averageVolume ||
      oldDelegate.barColor != barColor ||
      oldDelegate.averageLineColor != averageLineColor;
  // coverage:ignore-end
}
