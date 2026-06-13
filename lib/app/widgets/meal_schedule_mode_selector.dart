import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_schedule_mode_selector}
/// Segmented control for choosing between per-meal check-ins and a single
/// end-of-day check-in.
/// {@endtemplate}
class MealScheduleModeSelector extends StatelessWidget {
  /// {@macro meal_schedule_mode_selector}
  const MealScheduleModeSelector({
    required this.mealCheckinScheduleMode,
    required this.onChanged,
    super.key,
  });

  /// The currently selected mode.
  final MealCheckinScheduleMode mealCheckinScheduleMode;

  /// Called with the newly selected mode.
  final ValueChanged<MealCheckinScheduleMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<MealCheckinScheduleMode>(
      segments: [
        for (final option in MealCheckinScheduleMode.values)
          ButtonSegment(value: option, label: Text(option.label)),
      ],
      selected: {mealCheckinScheduleMode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
