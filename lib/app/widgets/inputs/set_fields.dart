import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template set_fields}
/// An editor for a list of workout sets: one row per set (weight × reps),
/// an "Add set" button, and a remove icon on each row when more than one
/// remains. Reports the full [List<WorkoutSet>] on every change.
/// {@endtemplate}
class SetFields extends StatefulWidget {
  /// {@macro set_fields}
  const SetFields({
    required this.initial,
    required this.onChanged,
    required this.weightUnit,
    this.dense = false,
    this.bodyweight = false,
    super.key,
  });

  /// The sets to seed the rows with.
  final List<WorkoutSet> initial;

  /// Called with the full list whenever any field changes.
  final ValueChanged<List<WorkoutSet>> onChanged;

  /// The unit shown as a suffix on weight fields.
  final WeightUnit weightUnit;

  /// Compact inline styling.
  final bool dense;

  /// When true the weight field shows an 'auto' hint and an empty weight emits
  /// [WorkoutSet] with [WorkoutSet.weightAutoEstimated] set to true.
  final bool bodyweight;

  @override
  State<SetFields> createState() => _SetFieldsState();
}

class _SetFieldsState extends State<SetFields> {
  late final List<TextEditingController> _weightControllers;
  late final List<TextEditingController> _repsControllers;

  @override
  void initState() {
    super.initState();
    _weightControllers = [
      for (final workoutSet in widget.initial)
        TextEditingController(
          text: workoutSet.weight?.trimmedDecimal ?? '',
        ),
    ];
    _repsControllers = [
      for (final workoutSet in widget.initial)
        TextEditingController(
          text: workoutSet.reps?.toString() ?? '',
        ),
    ];
  }

  @override
  void dispose() {
    for (final controller in _weightControllers) {
      controller.dispose();
    }
    for (final controller in _repsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final sets = [
      for (var i = 0; i < _weightControllers.length; i++)
        _buildSet(i),
    ];
    widget.onChanged(sets);
  }

  WorkoutSet _buildSet(int index) {
    final weight = double.tryParse(_weightControllers[index].text);
    final reps = int.tryParse(_repsControllers[index].text);
    if (widget.bodyweight) {
      return WorkoutSet(
        weight: weight,
        reps: reps,
        weightAutoEstimated: weight == null,
      );
    }
    return WorkoutSet(weight: weight, reps: reps);
  }

  void _addSet() {
    setState(() {
      final previous = _weightControllers.isNotEmpty
          ? WorkoutSet(
              weight: double.tryParse(
                _weightControllers.last.text,
              ),
              reps: int.tryParse(_repsControllers.last.text),
            )
          : null;
      _weightControllers.add(
        TextEditingController(
          text: previous?.weight?.trimmedDecimal ?? '',
        ),
      );
      _repsControllers.add(
        TextEditingController(
          text: previous?.reps?.toString() ?? '',
        ),
      );
    });
    _emit();
  }

  void _removeSet(int index) {
    setState(() {
      _weightControllers[index].dispose();
      _repsControllers[index].dispose();
      _weightControllers.removeAt(index);
      _repsControllers.removeAt(index);
    });
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _weightControllers.length; i++)
          _SetRow(
            key: ValueKey(i),
            weightController: _weightControllers[i],
            repsController: _repsControllers[i],
            index: i,
            count: _weightControllers.length,
            weightUnit: widget.weightUnit,
            bodyweight: widget.bodyweight,
            onChanged: _emit,
            onRemove: () => _removeSet(i),
          ),
        TextButton.icon(
          onPressed: _addSet,
          icon: const Icon(Icons.add),
          label: const Text('Add set'),
        ),
      ],
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.weightController,
    required this.repsController,
    required this.index,
    required this.count,
    required this.weightUnit,
    required this.bodyweight,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final TextEditingController weightController;
  final TextEditingController repsController;
  final int index;
  final int count;
  final WeightUnit weightUnit;
  final bool bodyweight;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: TheUsualTextField(
              key: Key('set-weight-$index'),
              controller: weightController,
              dense: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d{0,4}\.?\d{0,1}'),
                ),
              ],
              hintText: bodyweight ? 'AUTO' : weightUnit.name.toUpperCase(),
              onChanged: (_) => onChanged(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDesign.spacing.sm),
            child: const Text('×'),
          ),
          SizedBox(
            width: 80,
            child: TheUsualTextField(
              key: Key('set-reps-$index'),
              controller: repsController,
              dense: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              hintText: 'REPS',
              onChanged: (_) => onChanged(),
            ),
          ),
          if (count > 1)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
