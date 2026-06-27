import 'dart:math';

import 'package:flutter/material.dart';

/// {@template exercise_sparkline}
/// A compact, label-free line of values for an exercise-list row. Renders
/// nothing for fewer than two values.
/// {@endtemplate}
class ExerciseSparkline extends StatelessWidget {
  /// {@macro exercise_sparkline}
  const ExerciseSparkline({required this.values, this.color, super.key});

  /// The values to plot, oldest first.
  final List<double> values;

  /// The line color; defaults to the theme's primary.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return const SizedBox.shrink();
    return CustomPaint(
      painter: _SparklinePainter(
        values: values,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final range = maxValue - minValue;
    const inset = 2.0;
    final usableHeight = size.height - inset * 2;

    double yFor(double value) {
      if (range == 0) return size.height / 2;
      return inset + (1 - (value - minValue) / range) * usableHeight;
    }

    final step = size.width / (values.length - 1);
    final path = Path()..moveTo(0, yFor(values.first));
    for (var index = 1; index < values.length; index++) {
      path.lineTo(index * step, yFor(values[index]));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
  // coverage:ignore-end
}
