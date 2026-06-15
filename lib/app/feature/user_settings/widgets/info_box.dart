import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

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
    return DashedBorder(
      color: theme.colorScheme.outlineVariant,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        child: Text(message, style: theme.textTheme.bodySmall),
      ),
    );
  }
}
