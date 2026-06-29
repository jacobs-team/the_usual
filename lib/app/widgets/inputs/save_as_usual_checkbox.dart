import 'package:flutter/material.dart';

/// {@template save_as_usual_checkbox}
/// A compact checkbox with a tappable label for opting a food or meal into the
/// user's usuals. Tapping the label toggles the value just like the box, so the
/// whole control is one hit target. Shared by the meal-entry surfaces so the
/// per-food and meal-level "save as usual" controls read identically.
/// {@endtemplate}
class SaveAsUsualCheckbox extends StatelessWidget {
  /// {@macro save_as_usual_checkbox}
  const SaveAsUsualCheckbox({
    required this.value,
    required this.onChanged,
    this.label = 'Save as usual',
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: value,
          onChanged: (value) => onChanged(value ?? false),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!value),
          child: Text(label),
        ),
      ],
    );
  }
}
