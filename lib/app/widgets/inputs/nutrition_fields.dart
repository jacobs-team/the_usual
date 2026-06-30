import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template nutrition_fields}
/// Entry for a full set of [Nutrition] facts: calories plus protein, carbs, and
/// fat in grams, all shown at once. The fields sit on one line when there's
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
    text: widget.initial.calories?.rounded.toString() ?? '',
  );
  late final _proteinController = TextEditingController(
    text: widget.initial.protein?.rounded.toString() ?? '',
  );
  late final _carbsController = TextEditingController(
    text: widget.initial.carbs?.rounded.toString() ?? '',
  );
  late final _fatController = TextEditingController(
    text: widget.initial.fat?.rounded.toString() ?? '',
  );

  @override
  void didUpdateWidget(NutritionFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The fields own what the user types; the controllers are not rebuilt from
    // the bloc on every keystroke. Only pull a new [initial] in when it differs
    // from what's shown, so an external change (e.g. an AI estimate) populates
    // the fields without clobbering an in-progress edit echoing back.
    if (widget.initial == oldWidget.initial) return;
    _syncField(_caloriesController, widget.initial.calories);
    _syncField(_proteinController, widget.initial.protein);
    _syncField(_carbsController, widget.initial.carbs);
    _syncField(_fatController, widget.initial.fat);
  }

  /// Sets [controller] to [value] rounded to a whole number, unless the field
  /// already shows that — so the echo of the user's own edit doesn't reset the
  /// field or its cursor, and a precise per-unit estimate (e.g. 2.8) seeds the
  /// field as the whole number shown elsewhere while the bloc keeps the precise
  /// value the user hasn't touched.
  void _syncField(TextEditingController controller, double? value) {
    final shown = value?.rounded.toString() ?? '';
    if (controller.text == shown) return;
    controller.text = shown;
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(
      Nutrition(
        calories: double.tryParse(_caloriesController.text),
        protein: double.tryParse(_proteinController.text),
        carbs: double.tryParse(_carbsController.text),
        fat: double.tryParse(_fatController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDesign.spacing.sm,
      runSpacing: AppDesign.spacing.sm,
      children: [
        _LabeledMacroField(
          label: 'CALORIES',
          unit: 'cal',
          maxDigits: 4,
          width: widget.dense ? 76 : 88,
          dense: widget.dense,
          controller: _caloriesController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'PROTEIN',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 56 : 64,
          dense: widget.dense,
          controller: _proteinController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'CARBS',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 56 : 64,
          dense: widget.dense,
          controller: _carbsController,
          onChanged: (_) => _emit(),
        ),
        _LabeledMacroField(
          label: 'FAT',
          unit: 'g',
          maxDigits: 3,
          width: widget.dense ? 56 : 64,
          dense: widget.dense,
          controller: _fatController,
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
