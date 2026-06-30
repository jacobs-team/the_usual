import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template save_usual_icon_button}
/// A compact save action for a food inside a meal that isn't saved to the usual
/// foods library yet. Uses the deep-orange goal accent and the same icon and
/// size as the update-usual button, so the "save to usuals" affordance reads
/// the same everywhere.
/// {@endtemplate}
class SaveUsualIconButton extends StatelessWidget {
  /// {@macro save_usual_icon_button}
  const SaveUsualIconButton({
    required this.onPressed,
    this.tooltip = 'Save food as usual',
    super.key,
  });

  /// Called when the user taps to save the food to their usuals.
  final VoidCallback onPressed;

  /// The button's tooltip.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(),
      iconSize: 16,
      color: AppPalette.goalLine,
      icon: const Icon(Icons.save_outlined),
    );
  }
}
