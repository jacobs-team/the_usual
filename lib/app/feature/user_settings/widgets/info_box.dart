import 'package:flutter/material.dart';

/// {@template info_box}
/// Dashed-border box with a short explanatory message, used when a section
/// is turned off or empty.
/// {@endtemplate}
class InfoBox extends StatelessWidget {
  /// {@macro info_box}
  const InfoBox(this.message, {super.key});

  /// The message to display.
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      painter: _DashedBorderPainter(color: theme.colorScheme.outlineVariant),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Text(message, style: theme.textTheme.bodySmall),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  static const _radius = 12.0;
  static const _dashLength = 5.0;
  static const _gapLength = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final border = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(_radius),
        ),
      );

    for (final metric in border.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + _dashLength),
          paint,
        );
        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
