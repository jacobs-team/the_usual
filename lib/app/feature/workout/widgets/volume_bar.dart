import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template volume_bar}
/// A compact summary of the day's total workout volume, styled to match the
/// app's summary bar containers.
/// {@endtemplate}
class VolumeBar extends StatelessWidget {
  /// {@macro volume_bar}
  const VolumeBar({
    required this.volume,
    required this.weightUnit,
    super.key,
  });

  /// The day's total volume.
  final double volume;

  /// The unit to display beside the volume.
  final WeightUnit weightUnit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDesign.spacing.md,
        vertical: AppDesign.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDesign.radius.sm),
      ),
      child: Text(
        '${volume.trimmedDecimal} ${weightUnit.name} · volume',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
