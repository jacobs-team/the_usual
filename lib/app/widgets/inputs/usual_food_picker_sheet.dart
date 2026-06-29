import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// The result of showing a [UsualFoodPickerSheet].
///
/// [UsualFoodPickerResult.newFood] when the user taps "New food".
/// [UsualFoodPickerResult.picked] when the user picks a [UsualFood].
/// null when the user dismisses the sheet without making a choice.
sealed class UsualFoodPickerResult {
  const UsualFoodPickerResult();

  /// The user chose to add a blank new food row.
  const factory UsualFoodPickerResult.newFood() = NewFoodPickerResult;

  /// The user picked an existing food from the library.
  const factory UsualFoodPickerResult.picked(UsualFood usualFood) =
      PickedFoodPickerResult;
}

/// The user chose to add a blank new food row.
class NewFoodPickerResult extends UsualFoodPickerResult {
  const NewFoodPickerResult();
}

/// The user picked an existing food from the library.
class PickedFoodPickerResult extends UsualFoodPickerResult {
  const PickedFoodPickerResult(this.usualFood);
  final UsualFood usualFood;
}

/// {@template usual_food_picker_sheet}
/// A bottom sheet that lists the user's usual foods library so they can pick
/// one to add to a composed meal. A leading "New food" option adds a blank row
/// instead. Pops with a [UsualFoodPickerResult], or null when dismissed.
/// {@endtemplate}
class UsualFoodPickerSheet extends StatelessWidget {
  /// {@macro usual_food_picker_sheet}
  const UsualFoodPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final usualFoods = getIt<UserSettingsBloc>().state.usualFoods;
    return TheUsualBottomSheet(
      title: 'Add a food',
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            key: const Key('pickerNewFood'),
            leading: const Icon(Icons.add),
            title: const Text('New food'),
            onTap: () => Navigator.of(context).pop(
              const UsualFoodPickerResult.newFood(),
            ),
          ),
          for (final usualFood in usualFoods)
            ListTile(
              key: ValueKey(usualFood.id),
              title: Text(usualFood.name),
              subtitle: DefaultTextStyle.merge(
                style: Theme.of(context).textTheme.bodySmall,
                child: NutritionSummary(usualFood.nutrition),
              ),
              onTap: () => Navigator.of(context).pop(
                UsualFoodPickerResult.picked(usualFood),
              ),
            ),
        ],
      ),
    );
  }
}
