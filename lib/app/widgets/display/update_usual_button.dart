import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template update_usual_button}
/// A right-aligned action shown below a logged entry's fields that saves the
/// logged values to a usual — updating the linked usual to match, or creating a
/// new one when the entry isn't saved as a usual yet. Coloured the deep-orange
/// goal accent so it stands out against the entry's muted text.
/// {@endtemplate}
class UpdateUsualButton extends StatelessWidget {
  /// {@macro update_usual_button}
  const UpdateUsualButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// The button's text, e.g. 'Update usual to match' or 'Save as usual'.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.goalLine,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        icon: const Icon(Icons.save_outlined, size: 16),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
