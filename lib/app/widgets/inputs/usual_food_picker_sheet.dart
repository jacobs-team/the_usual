import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The result of showing a [UsualFoodPickerSheet].
///
/// [UsualFoodPickerResult.created] when the user enters a new food in the
/// entry card.
/// [UsualFoodPickerResult.picked] when the user picks a [UsualFood].
/// null when the user dismisses the sheet without making a choice.
sealed class UsualFoodPickerResult {
  const UsualFoodPickerResult();

  /// The user entered a new food. [saveAsUsual] is true when they also asked
  /// to add it to their usual foods library.
  const factory UsualFoodPickerResult.created({
    required String name,
    required Nutrition nutrition,
    required bool saveAsUsual,
  }) = CreatedFoodPickerResult;

  /// The user picked an existing food from the library.
  const factory UsualFoodPickerResult.picked(UsualFood usualFood) =
      PickedFoodPickerResult;
}

/// The user entered a new food in the entry card.
class CreatedFoodPickerResult extends UsualFoodPickerResult {
  const CreatedFoodPickerResult({
    required this.name,
    required this.nutrition,
    required this.saveAsUsual,
  });

  final String name;
  final Nutrition nutrition;
  final bool saveAsUsual;
}

/// The user picked an existing food from the library.
class PickedFoodPickerResult extends UsualFoodPickerResult {
  const PickedFoodPickerResult(this.usualFood);
  final UsualFood usualFood;
}

/// {@template usual_food_picker_sheet}
/// A bottom sheet for adding a food to a composed meal. A new-food entry card
/// at the top captures a single food's name and nutrition — fillable by an AI
/// estimate from the name and/or a photo — with an optional "Save food as
/// usual". The user's usual foods are listed below, most recently used first,
/// to pick from. Pops with a [UsualFoodPickerResult], or null when dismissed.
/// {@endtemplate}
class UsualFoodPickerSheet extends StatefulWidget {
  /// {@macro usual_food_picker_sheet}
  const UsualFoodPickerSheet({super.key});

  @override
  State<UsualFoodPickerSheet> createState() => _UsualFoodPickerSheetState();
}

class _UsualFoodPickerSheetState extends State<UsualFoodPickerSheet> {
  final _nameController = TextEditingController();
  Nutrition _nutrition = const Nutrition();
  bool _saveAsUsual = getIt<UserSettingsBloc>().state.saveFoodAsUsualDefault;
  bool _canAdd = false;
  List<MealPhoto> _photos = const [];
  bool _estimating = false;

  /// Re-seeds [NutritionFields] when an estimate fills new values: its inputs
  /// keep their own controllers, so a fresh key rebuilds them from the
  /// estimated [_nutrition].
  Key _nutritionFieldsKey = UniqueKey();

  bool get _aiAvailable => getIt<MealAiRepository>().isConfigured;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      final canAdd = _nameController.text.trim().isNotEmpty;
      if (canAdd != _canAdd) setState(() => _canAdd = canAdd);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addPhotos() async {
    final photos = await pickMealPhotos(context);
    if (photos.isEmpty || !mounted) return;
    setState(() => _photos = [..._photos, ...photos]);
  }

  /// Estimates the food's nutrition from its name and/or attached photos. A
  /// name the user typed is kept; when only a photo is given, the AI's name
  /// fills the empty field.
  Future<void> _estimate() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty && _photos.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Add a name or a photo first.')),
      );
      return;
    }

    setState(() => _estimating = true);
    try {
      final suggestion = await getIt<MealAiRepository>().suggestWholeMeal(
        description: name.isEmpty ? null : name,
        photos: _photos,
      );
      if (!mounted) return;
      setState(() {
        if (_nameController.text.trim().isEmpty) {
          _nameController.text = suggestion.name;
        }
        _nutrition = suggestion.nutrition;
        _nutritionFieldsKey = UniqueKey();
        _estimating = false;
      });
    } on Object catch (error, stackTrace) {
      log(
        'Food nutrition estimate failed',
        name: 'UsualFoodPickerSheet',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      setState(() => _estimating = false);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not estimate nutrition. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usualFoods = getIt<DailyLogBloc>().state.mealEntries
        .orderedByRecentUse(getIt<UserSettingsBloc>().state.usualFoods);
    final aiButtonStyle = FilledButton.styleFrom(
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(
        horizontal: AppDesign.spacing.md,
        vertical: AppDesign.spacing.sm,
      ),
    );
    return TheUsualBottomSheet(
      title: 'Add a food',
      child: ListView(
        shrinkWrap: true,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDesign.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TheUsualTextField(
                    key: const Key('newFoodName'),
                    controller: _nameController,
                    hintText: 'e.g. Chicken, 1 oz',
                  ),
                  if (_aiAvailable) ...[
                    SizedBox(height: AppDesign.spacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonalIcon(
                            style: aiButtonStyle,
                            onPressed: _estimating ? null : _estimate,
                            icon: const Icon(
                              Icons.auto_awesome_outlined,
                              size: 18,
                            ),
                            label: const Text('Estimate'),
                          ),
                        ),
                        SizedBox(width: AppDesign.spacing.sm),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            style: aiButtonStyle,
                            onPressed: _estimating ? null : _addPhotos,
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                              size: 18,
                            ),
                            label: const Text('Photo'),
                          ),
                        ),
                      ],
                    ),
                    if (_photos.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.sm),
                      AttachedPhotos(
                        photos: _photos,
                        onRemove: _estimating
                            ? null
                            : (index) => setState(
                                () => _photos = [..._photos]..removeAt(index),
                              ),
                      ),
                    ],
                    if (_estimating) ...[
                      SizedBox(height: AppDesign.spacing.sm),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: AppDesign.spacing.sm),
                          Text(
                            'Estimating…',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                  SizedBox(height: AppDesign.spacing.md),
                  NutritionFields(
                    key: _nutritionFieldsKey,
                    dense: true,
                    initial: _nutrition,
                    onChanged: (nutrition) => _nutrition = nutrition,
                  ),
                  SizedBox(height: AppDesign.spacing.md),
                  Row(
                    children: [
                      SaveAsUsualCheckbox(
                        label: 'Save food as usual',
                        value: _saveAsUsual,
                        onChanged: (value) =>
                            setState(() => _saveAsUsual = value),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _canAdd && !_estimating
                            ? () => Navigator.of(context).pop(
                                UsualFoodPickerResult.created(
                                  name: _nameController.text.trim(),
                                  nutrition: _nutrition,
                                  saveAsUsual: _saveAsUsual,
                                ),
                              )
                            : null,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (usualFoods.isNotEmpty) ...[
            SizedBox(height: AppDesign.spacing.sm),
            for (final usualFood in usualFoods)
              Card(
                margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: ValueKey(usualFood.id),
                  onTap: () => Navigator.of(context).pop(
                    UsualFoodPickerResult.picked(usualFood),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(AppDesign.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usualFood.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: AppDesign.spacing.xs),
                        DefaultTextStyle.merge(
                          style: Theme.of(context).textTheme.bodySmall,
                          child: NutritionSummary(usualFood.nutrition),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
