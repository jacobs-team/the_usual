import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template usual_meal_composer}
/// Inline name + nutrition entry, shown as the last row of a usual meals list.
/// Submitting adds the meal and refocuses the name field for the next one.
/// {@endtemplate}
class UsualMealComposer extends StatefulWidget {
  /// {@macro usual_meal_composer}
  const UsualMealComposer({required this.onAdd, super.key});

  /// Called with the entered name and nutrition.
  final void Function(String name, Nutrition nutrition) onAdd;

  @override
  State<UsualMealComposer> createState() => _UsualMealComposerState();
}

class _UsualMealComposerState extends State<UsualMealComposer> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  /// The latest nutrition the fields reported, committed on submit.
  Nutrition _nutrition = const Nutrition();

  /// Bumped on submit to give [NutritionFields] a fresh key so it clears.
  int _fieldsGeneration = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onAdd(name, _nutrition);
    _nameController.clear();
    setState(() {
      _nutrition = const Nutrition();
      _fieldsGeneration++;
    });
    _nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TheUsualTextField(
          controller: _nameController,
          focusNode: _nameFocus,
          hintText: 'New Meal description',
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppDesign.spacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: NutritionFields(
                key: ValueKey(_fieldsGeneration),
                dense: true,
                onChanged: (nutrition) => _nutrition = nutrition,
              ),
            ),
            SizedBox(width: AppDesign.spacing.sm),
            IconButton.filled(icon: const Icon(Icons.add), onPressed: _submit),
          ],
        ),
      ],
    );
  }
}
