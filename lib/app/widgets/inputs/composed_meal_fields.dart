import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template composed_meal_fields}
/// The by-foods entry body: a meal-name field, one compact row per [FoodDraft]
/// with its own [QuantityStepper] and [NutritionFields], and a read-only
/// [NutritionSummary] of the scaled component totals.
///
/// Rendered by [FoodEntryForm] when [MealEntryMode.itemized] is active.
/// {@endtemplate}
class ComposedMealFields extends StatelessWidget {
  /// {@macro composed_meal_fields}
  const ComposedMealFields({
    required this.state,
    required this.onDescriptionChanged,
    required this.onMealNameChanged,
    required this.onFoodNameChanged,
    required this.onFoodNutritionChanged,
    required this.onFoodQuantityChanged,
    required this.onFoodRemoved,
    required this.onFoodAdded,
    required this.onFoodSaveToLibrary,
    super.key,
  });

  final MealEntryState state;

  /// Called as the user edits the "describe a meal" field, whose text the
  /// Estimate action itemizes into component foods.
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onMealNameChanged;
  final void Function(String id, String name) onFoodNameChanged;
  final void Function(String id, Nutrition nutrition) onFoodNutritionChanged;
  final void Function(String id, double quantity) onFoodQuantityChanged;
  final void Function(String id) onFoodRemoved;
  final VoidCallback onFoodAdded;

  /// Called when the user taps "Save to library" on a food row. The id
  /// identifies which [FoodDraft] to save.
  final void Function(String id) onFoodSaveToLibrary;

  List<MealComponent> get _components => [
    for (final foodDraft in state.foods)
      if (foodDraft.name.trim().isNotEmpty)
        MealComponent(
          name: foodDraft.name.trim(),
          nutrition: foodDraft.nutrition,
          quantity: foodDraft.quantity,
          usualFoodId: foodDraft.usualFoodId,
        ),
  ];

  @override
  Widget build(BuildContext context) {
    final components = _components;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SyncedTextField(
          key: const ValueKey('describe_field'),
          value: state.description,
          hintText:
              'Describe a meal and press estimate, '
              'add units or quantities to increase accuracy',
          onChanged: onDescriptionChanged,
        ),
        SizedBox(height: AppDesign.spacing.md),
        _SyncedTextField(
          key: const ValueKey('meal_name_field'),
          value: state.mealName,
          hintText: 'Meal name (e.g. Chicken & rice bowl)',
          onChanged: onMealNameChanged,
        ),
        SizedBox(height: AppDesign.spacing.md),
        for (var index = 0; index < state.foods.length; index++) ...[
          if (index > 0) SizedBox(height: AppDesign.spacing.sm),
          _ComposedFoodRow(
            key: ValueKey(state.foods[index].id),
            foodDraft: state.foods[index],
            canRemove: state.foods.length > 1,
            onNameChanged: (name) =>
                onFoodNameChanged(state.foods[index].id, name),
            onNutritionChanged: (nutrition) =>
                onFoodNutritionChanged(state.foods[index].id, nutrition),
            onQuantityChanged: (quantity) =>
                onFoodQuantityChanged(state.foods[index].id, quantity),
            onRemove: () => onFoodRemoved(state.foods[index].id),
            onSaveToLibrary: () => onFoodSaveToLibrary(state.foods[index].id),
          ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onFoodAdded,
            icon: const Icon(Icons.add),
            label: const Text('Add a food'),
          ),
        ),
        SizedBox(height: AppDesign.spacing.sm),
        DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodySmall,
          child: NutritionSummary(components.componentsTotal),
        ),
      ],
    );
  }
}

/// A text field whose contents are driven by [value] and re-synced when [value]
/// changes externally — e.g. an AI estimate filling in the meal name — without
/// disturbing the cursor while the user is typing. Used for the by-foods
/// describe and meal-name fields, both of which the AI can populate.
class _SyncedTextField extends StatefulWidget {
  const _SyncedTextField({
    required this.value,
    required this.onChanged,
    required this.hintText,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  State<_SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<_SyncedTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(_SyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The controller already matches the user's own edits, so a difference here
    // is a true external change (an AI fill) — reflect it without clobbering an
    // in-progress edit.
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TheUsualTextField(
      controller: _controller,
      hintText: widget.hintText,
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget.onChanged,
    );
  }
}

/// One compact food row inside the by-foods body: name field, quantity stepper,
/// dense nutrition fields, and an optional remove button.
class _ComposedFoodRow extends StatefulWidget {
  const _ComposedFoodRow({
    required this.foodDraft,
    required this.canRemove,
    required this.onNameChanged,
    required this.onNutritionChanged,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onSaveToLibrary,
    super.key,
  });

  final FoodDraft foodDraft;
  final bool canRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Nutrition> onNutritionChanged;
  final ValueChanged<double> onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback onSaveToLibrary;

  @override
  State<_ComposedFoodRow> createState() => _ComposedFoodRowState();
}

class _ComposedFoodRowState extends State<_ComposedFoodRow> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodDraft.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDesign.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TheUsualTextField(
                    controller: _nameController,
                    hintText: 'Food name',
                    onChanged: widget.onNameChanged,
                  ),
                ),
                if (widget.foodDraft.usualFoodId != null)
                  const Icon(Icons.bookmark, semanticLabel: 'In library')
                else
                  IconButton(
                    onPressed: widget.onSaveToLibrary,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    tooltip: 'Save to library',
                  ),
                if (widget.canRemove)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.close),
                    tooltip: 'Remove',
                  ),
              ],
            ),
            SizedBox(height: AppDesign.spacing.sm),
            NutritionFields(
              dense: true,
              initial: widget.foodDraft.nutrition,
              onChanged: widget.onNutritionChanged,
            ),
            SizedBox(height: AppDesign.spacing.sm),
            QuantityStepper(
              dense: true,
              quantity: widget.foodDraft.quantity,
              onChanged: widget.onQuantityChanged,
            ),
          ],
        ),
      ),
    );
  }
}
