import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_composer}
/// Inline name + optional calories entry, shown as the last row of a usual
/// meals list. Submitting adds the meal and refocuses the name field for the
/// next one.
/// {@endtemplate}
class UsualMealComposer extends StatefulWidget {
  /// {@macro usual_meal_composer}
  const UsualMealComposer({required this.onAdd, super.key});

  /// Called with the entered name and optional calories.
  final void Function(String name, int? calories) onAdd;

  @override
  State<UsualMealComposer> createState() => _UsualMealComposerState();
}

class _UsualMealComposerState extends State<UsualMealComposer> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _nameFocus = FocusNode();
  final _caloriesFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _nameFocus.dispose();
    _caloriesFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(name, int.tryParse(_caloriesController.text));
    _nameController.clear();
    _caloriesController.clear();
    _nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TheUsualTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            hintText: 'Meal description',
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _caloriesFocus.requestFocus(),
          ),
        ),
        SizedBox(width: AppDesign.spacing.sm),
        CalorieField(
          controller: _caloriesController,
          focusNode: _caloriesFocus,
          autoSize: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        SizedBox(width: AppDesign.spacing.xs),
        IconButton.filled(icon: const Icon(Icons.add), onPressed: _submit),
      ],
    );
  }
}
