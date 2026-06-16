import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template dashed_border}
/// Draws a dashed rounded-rectangle border around [child]. Used to mark a
/// placeholder or not-yet-filled surface, e.g. an empty section notice or an
/// unlogged quick pick.
/// {@endtemplate}
class DashedBorder extends StatelessWidget {
  /// {@macro dashed_border}
  const DashedBorder({
    required this.child,
    required this.color,
    this.radius,
    super.key,
  });

  /// The widget the border is drawn around.
  final Widget child;

  /// The colour of the dashes.
  final Color color;

  /// The corner radius of the border. Defaults to [RadiusTokens.sm].
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: color,
        radius: radius ?? AppDesign.radius.sm,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

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
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
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
      color != oldDelegate.color || radius != oldDelegate.radius;
}
