import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template weight_time_of_day_chips}
/// Choice chips for when in the day the weigh-in reminder fires.
/// {@endtemplate}
class WeightTimeOfDayChips extends StatelessWidget {
  /// {@macro weight_time_of_day_chips}
  const WeightTimeOfDayChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The currently selected time of day.
  final WeightTimeOfDay selected;

  /// Called with the newly selected time of day.
  final ValueChanged<WeightTimeOfDay> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDesign.spacing.sm,
      children: [
        for (final option in WeightTimeOfDay.values)
          ChoiceChip(
            label: Text(option.label),
            selected: option == selected,
            onSelected: (_) => onSelected(option),
          ),
      ],
    );
  }
}
