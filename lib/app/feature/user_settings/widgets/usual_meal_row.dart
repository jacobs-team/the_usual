import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_meal_row}
/// A card row for one usual meal: name, inline-editable calories, and a
/// remove button.
/// {@endtemplate}
class UsualMealRow extends StatelessWidget {
  /// {@macro usual_meal_row}
  const UsualMealRow({required this.meal, required this.item, super.key});

  /// The meal group the item belongs to.
  final MealOfTheDay meal;

  /// The usual being displayed.
  final UsualMeal item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.name, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TheUsualTextField(
              autoSize: true,
              dense: true,
              initialValue: item.calories?.toString() ?? '',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              hintText: 'auto',
              suffixText: ' cal',
              onChanged: (value) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.usualCaloriesChanged(
                  meal,
                  item.id,
                  int.tryParse(value),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.usualRemoved(meal, item.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
