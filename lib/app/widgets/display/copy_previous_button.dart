import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template copy_previous_button}
/// A one-tap shortcut shown in an empty group's header that re-logs the entries
/// from its most recent earlier session, with a tooltip naming what it will add
/// so the bulk action isn't a surprise.
/// {@endtemplate}
class CopyPreviousButton extends StatelessWidget {
  /// {@macro copy_previous_button}
  const CopyPreviousButton({
    required this.itemNames,
    required this.onPressed,
    super.key,
  });

  /// The names of the entries this button re-logs, listed in the tooltip.
  final List<String> itemNames;

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Logs ${itemNames.join(', ')}',
      child: FilledButton.tonalIcon(
        style: pillButtonStyle(context),
        onPressed: onPressed,
        icon: const Icon(Icons.restore),
        label: const Text('Copy previous'),
      ),
    );
  }
}
