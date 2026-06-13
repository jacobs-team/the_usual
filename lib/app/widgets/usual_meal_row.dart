import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';

/// {@template usual_meal_row}
/// A card row for one usual meal: name, inline-editable calories, and a
/// remove button. Driven by callbacks so both onboarding and settings can
/// render it against their own bloc.
/// {@endtemplate}
class UsualMealRow extends StatelessWidget {
  /// {@macro usual_meal_row}
  const UsualMealRow({
    required this.usualMeal,
    required this.onCaloriesChanged,
    required this.onRemoved,
    super.key,
  });

  /// The usual meal being displayed.
  final UsualMeal usualMeal;

  /// Called with the parsed calories, or null when the field is cleared.
  final ValueChanged<int?> onCaloriesChanged;

  /// Called when the remove button is pressed.
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(usualMeal.name, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TheUsualTextField(
              autoSize: true,
              dense: true,
              initialValue: usualMeal.calories?.toString() ?? '',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              hintText: '—',
              suffixText: ' cal',
              onChanged: (value) => onCaloriesChanged(int.tryParse(value)),
            ),
            const SizedBox(width: 4),
            IconButton(icon: const Icon(Icons.close), onPressed: onRemoved),
          ],
        ),
      ),
    );
  }
}
