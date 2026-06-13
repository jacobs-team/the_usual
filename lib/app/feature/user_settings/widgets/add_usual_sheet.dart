import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';

/// {@template add_usual_sheet}
/// Bottom sheet for adding a usual meal: name plus optional calories.
/// Pops with a ([String], [int]?) record of name and calories, or null when
/// cancelled.
/// {@endtemplate}
class AddUsualSheet extends StatefulWidget {
  /// {@macro add_usual_sheet}
  const AddUsualSheet({required this.meal, super.key});

  /// The meal the usual will be added to, used for the sheet title.
  final MealOfTheDay meal;

  @override
  State<AddUsualSheet> createState() => _AddUsualSheetState();
}

class _AddUsualSheetState extends State<AddUsualSheet> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(
      (_nameController.text, int.tryParse(_caloriesController.text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mealLabel = widget.meal == MealOfTheDay.snacks
        ? 'snack'
        : widget.meal.name;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add a $mealLabel usual meal', style: textTheme.titleMedium),
          const SizedBox(height: 14),
          const SectionLabel('NAME'),
          const SizedBox(height: 6),
          TheUsualTextField(
            controller: _nameController,
            autofocus: true,
            hintText: 'e.g. Chicken salad',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          const SectionLabel('CALORIES · OPTIONAL'),
          const SizedBox(height: 6),
          TheUsualTextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            hintText: "Leave blank and we'll estimate it",
            suffixText: ' cal',
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _nameController.text.trim().isEmpty
                      ? null
                      : _submit,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
