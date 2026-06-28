import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The value [FoodEntrySheet] pops when the user confirms: the list of foods
/// they entered and the meal slot those foods belong to.
typedef FoodEntrySheetResult = ({
  List<FoodEntryResult> foods,
  MealOfTheDay mealOfTheDay,
});

/// {@template food_entry_sheet}
/// Bottom sheet for capturing what the user ate, by hand or with AI assistance.
/// Wraps a [FoodEntryForm] with a heading and a confirm button; pops with a
/// [FoodEntrySheetResult] containing the foods and target meal slot, or null
/// when cancelled.
/// {@endtemplate}
class FoodEntrySheet extends StatefulWidget {
  /// {@macro food_entry_sheet}
  const FoodEntrySheet({
    required this.title,
    required this.confirmLabel,
    this.showAddToUsualMeals = false,
    this.showQuantity = true,
    this.showMealSelector = false,
    this.initialPhotos,
    this.initialMealOfTheDay,
    super.key,
  });

  /// Heading shown at the top of the sheet.
  final String title;

  /// Label for the confirm button.
  final String confirmLabel;

  /// Whether to show the "Add to usual meals" option, checked by default.
  final bool showAddToUsualMeals;

  /// Whether to show the quantity stepper. When false the quantity is always 1.
  final bool showQuantity;

  /// Whether to show the meal-slot selector above the form (used by the
  /// share-to-log path).
  final bool showMealSelector;

  /// Photos to pre-load into the form (e.g. from the OS share target).
  final List<MealPhoto>? initialPhotos;

  /// The target meal slot to pre-select in the form.
  final MealOfTheDay? initialMealOfTheDay;

  @override
  State<FoodEntrySheet> createState() => _FoodEntrySheetState();
}

class _FoodEntrySheetState extends State<FoodEntrySheet> {
  final _formKey = GlobalKey<FoodEntryFormState>();

  void _confirm() {
    final form = _formKey.currentState;
    if (form == null || form.results.isEmpty) return;
    Navigator.of(context).pop(
      (foods: form.results, mealOfTheDay: form.mealOfTheDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = _formKey.currentState;
    final canConfirm = form != null && !form.isGenerating && form.hasContent;
    return TheUsualBottomSheet(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showMealSelector) ...[
            SegmentedButton<MealOfTheDay>(
              showSelectedIcon: false,
              segments: [
                for (final mealOfTheDay in MealOfTheDay.values)
                  ButtonSegment(
                    value: mealOfTheDay,
                    label: Text(mealOfTheDay.label),
                  ),
              ],
              selected: {
                _formKey.currentState?.mealOfTheDay ?? MealOfTheDay.breakfast,
              },
              onSelectionChanged: (selection) {
                _formKey.currentState?.changeMealOfTheDay(selection.first);
                setState(() {});
              },
            ),
            SizedBox(height: AppDesign.spacing.md),
          ],
          FoodEntryForm(
            key: _formKey,
            showQuantity: widget.showQuantity,
            showAddToUsualMeals: widget.showAddToUsualMeals,
            initialPhotos: widget.initialPhotos,
            initialMealOfTheDay: widget.initialMealOfTheDay,
            onChanged: () => setState(() {}),
          ),
          FilledButton(
            onPressed: canConfirm ? _confirm : null,
            child: Text(widget.confirmLabel),
          ),
        ],
      ),
    );
  }
}
