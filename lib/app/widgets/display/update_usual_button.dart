import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template update_usual_button}
/// A left-aligned action shown below a logged entry's fields when it differs
/// from the usual it's linked to, pushing the logged values onto that usual so
/// it matches. Coloured the deep-orange goal accent so it stands out against
/// the entry's muted text.
/// {@endtemplate}
class UpdateUsualButton extends StatelessWidget {
  /// {@macro update_usual_button}
  const UpdateUsualButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// The button's text, e.g. 'Update usual to match'.
  final String label;

  /// Called when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: AppDesign.spacing.sm),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: AppPalette.goalLine,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          icon: const Icon(Icons.sync, size: 16),
          label: Text(label),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
