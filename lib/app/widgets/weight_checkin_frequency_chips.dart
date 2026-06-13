import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template weight_checkin_frequency_chips}
/// Choice chips for how often the user weighs in.
/// {@endtemplate}
class WeightCheckinFrequencyChips extends StatelessWidget {
  /// {@macro weight_checkin_frequency_chips}
  const WeightCheckinFrequencyChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The currently selected frequency.
  final WeightCheckinFrequency selected;

  /// Called with the newly selected frequency.
  final ValueChanged<WeightCheckinFrequency> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDesign.spacing.sm,
      children: [
        for (final option in WeightCheckinFrequency.values)
          ChoiceChip(
            label: Text(option.label),
            selected: option == selected,
            onSelected: (_) => onSelected(option),
          ),
      ],
    );
  }
}
