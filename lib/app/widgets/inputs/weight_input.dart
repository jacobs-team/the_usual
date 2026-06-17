import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template weight_input}
/// Weight entry field with unit choice chips as its suffix. The caller owns
/// the [controller] so the text survives rebuilds.
/// {@endtemplate}
class WeightInput extends StatelessWidget {
  /// {@macro weight_input}
  const WeightInput({
    required this.controller,
    required this.weightUnit,
    required this.onWeightChanged,
    required this.onUnitSelected,
    super.key,
  });

  /// Controller for the weight text.
  final TextEditingController controller;

  /// The currently selected unit.
  final WeightUnit weightUnit;

  /// Called with the parsed weight, or null when the text isn't a number.
  final ValueChanged<double?> onWeightChanged;

  /// Called with the newly selected unit.
  final ValueChanged<WeightUnit> onUnitSelected;

  @override
  Widget build(BuildContext context) {
    return TheUsualTextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}\.?\d{0,1}')),
      ],
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: AppDesign.spacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in WeightUnit.values)
              Padding(
                padding: EdgeInsets.only(left: AppDesign.spacing.xs),
                child: ChoiceChip(
                  label: Text(option.name),
                  selected: option == weightUnit,
                  onSelected: (_) => onUnitSelected(option),
                ),
              ),
          ],
        ),
      ),
      onChanged: (value) => onWeightChanged(double.tryParse(value)),
    );
  }
}
