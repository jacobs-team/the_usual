import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template food_entry_sheet}
/// Bottom sheet capturing a food name plus optional calories, used both for
/// adding a usual meal and logging a one-off. Pops with a
/// ([String], [int]?, [bool]) record of name, calories, and whether to add it
/// to the usual meals, or null when cancelled.
/// {@endtemplate}
class FoodEntrySheet extends StatefulWidget {
  /// {@macro food_entry_sheet}
  const FoodEntrySheet({
    required this.title,
    required this.confirmLabel,
    this.showAddToUsualMeals = false,
    super.key,
  });

  /// Heading shown at the top of the sheet.
  final String title;

  /// Label for the confirm button.
  final String confirmLabel;

  /// Whether to show the "Add to usual meals" checkbox, checked by default.
  final bool showAddToUsualMeals;

  @override
  State<FoodEntrySheet> createState() => _FoodEntrySheetState();
}

class _FoodEntrySheetState extends State<FoodEntrySheet> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  bool _addToUsualMeals = true;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Lift the sheet above the keyboard, then keep the content clear of the
    // home indicator with SafeArea.
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: textTheme.titleMedium),
              SizedBox(height: AppDesign.spacing.md),
              const SectionLabel('NAME'),
              SizedBox(height: AppDesign.spacing.sm),
              TheUsualTextField(
                controller: _nameController,
                autofocus: true,
                hintText: 'e.g. Chicken caesar salad',
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppDesign.spacing.md),
              const SectionLabel('CALORIES · OPTIONAL'),
              SizedBox(height: AppDesign.spacing.sm),
              CalorieField(
                controller: _caloriesController,
              ),
              if (widget.showAddToUsualMeals)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Add to usual meals'),
                  value: _addToUsualMeals,
                  onChanged: (value) =>
                      setState(() => _addToUsualMeals = value ?? false),
                ),
              SizedBox(height: AppDesign.spacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: AppDesign.spacing.sm),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _nameController.text.trim().isEmpty
                          ? null
                          : () => Navigator.of(context).pop((
                              _nameController.text,
                              int.tryParse(_caloriesController.text),
                              _addToUsualMeals,
                            )),
                      child: Text(widget.confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
