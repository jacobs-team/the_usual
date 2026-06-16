import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template nutrition_fields}
/// Entry for a full set of [Nutrition] facts: calories plus protein, fat, and
/// carbs in grams, all shown at once. The fields sit on one line when there's
/// room and wrap when there isn't. Reports the parsed [Nutrition] on each edit.
/// {@endtemplate}
class NutritionFields extends StatefulWidget {
  /// {@macro nutrition_fields}
  const NutritionFields({
    required this.onChanged,
    this.initial = const Nutrition(),
    this.dense = false,
    super.key,
  });

  /// The values to seed the fields with.
  final Nutrition initial;

  /// Called with the parsed nutrition whenever any field changes.
  final ValueChanged<Nutrition> onChanged;

  /// Compact inline styling, for use inside list rows.
  final bool dense;

  @override
  State<NutritionFields> createState() => _NutritionFieldsState();
}

class _NutritionFieldsState extends State<NutritionFields> {
  late final _caloriesController = TextEditingController(
    text: widget.initial.calories?.toString() ?? '',
  );
  late final _proteinController = TextEditingController(
    text: widget.initial.protein?.toString() ?? '',
  );
  late final _fatController = TextEditingController(
    text: widget.initial.fat?.toString() ?? '',
  );
  late final _carbsController = TextEditingController(
    text: widget.initial.carbs?.toString() ?? '',
  );

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(
      Nutrition(
        calories: int.tryParse(_caloriesController.text),
        protein: int.tryParse(_proteinController.text),
        fat: int.tryParse(_fatController.text),
        carbs: int.tryParse(_carbsController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDesign.spacing.md,
      runSpacing: AppDesign.spacing.sm,
      children: [
        _LabeledMacroField(
          label: 'CALORIES',
          unit: 'cal',
          maxDigits: 4,
          width: widget.dense ? 96 : 104,
          dense: widget.dense,
          controller: _caloriesController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'PROTEIN',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 72 : 80,
          dense: widget.dense,
          controller: _proteinController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'FAT',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 72 : 80,
          dense: widget.dense,
          controller: _fatController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'CARBS',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 72 : 80,
          dense: widget.dense,
          controller: _carbsController,
          onChanged: (_) => _emit(),
        ),
      ],
    );
  }
}

class _LabeledMacroField extends StatelessWidget {
  const _LabeledMacroField({
    required this.label,
    required this.unit,
    required this.maxDigits,
    required this.width,
    required this.dense,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String unit;
  final int maxDigits;
  final double width;
  final bool dense;
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        SizedBox(height: AppDesign.spacing.xs),
        SizedBox(
          width: width,
          child: MacroField(
            unit: unit,
            maxDigits: maxDigits,
            dense: dense,
            textAlign: TextAlign.right,
            controller: controller,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
