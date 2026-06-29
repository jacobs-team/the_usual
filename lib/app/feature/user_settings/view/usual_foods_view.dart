import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_foods_view}
/// Manages the user's usual foods library: the saved foods as editable cards,
/// with a floating action button to add more.
/// {@endtemplate}
class UsualFoodsView extends StatelessWidget {
  /// {@macro usual_foods_view}
  const UsualFoodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usual foods'),
      ),
      body: const UsualFoodList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a usual food',
        onPressed: () async {
          final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
            context,
            builder: (context) => const FoodEntrySheet(
              title: 'Add a usual food',
              confirmLabel: 'Add',
              showQuantity: false,
            ),
          );
          if (result == null) return;
          for (final foodResult in result.foods) {
            getIt<UserSettingsBloc>().add(
              UserSettingsEvent.usualFoodAdded(
                foodResult.name,
                foodResult.nutrition,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
