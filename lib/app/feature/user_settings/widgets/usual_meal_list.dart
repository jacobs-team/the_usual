import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_meal_list}
/// One meal's tab on the usual meals screen: the saved items with an add
/// button, and an empty notice when there are none.
/// {@endtemplate}
class UsualMealList extends StatelessWidget {
  /// {@macro usual_meal_list}
  const UsualMealList({required this.meal, super.key});

  /// The meal group this list shows.
  final MealOfTheDay meal;

  Future<void> _addUsual(BuildContext context) async {
    final result = await showModalBottomSheet<(String, int?)>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddUsualSheet(meal: meal),
    );
    if (result == null) return;
    final (name, calories) = result;
    getIt<UserSettingsBloc>().add(
      UserSettingsEvent.usualAdded(meal, name, calories),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocSelector<UserSettingsBloc, UserSettingsState, List<UsualMeal>>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.usuals[meal] ?? <UsualMeal>[],
      builder: (context, items) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionLabel('${meal.label.toUpperCase()} (${items.length})'),
                Text('Tap calories to edit', style: textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              InfoBox('No ${meal.name} usuals yet. Add one below.'),
            for (final item in items)
              UsualMealRow(key: ValueKey(item.id), meal: meal, item: item),
            const SizedBox(height: 4),
            OutlinedButton(
              onPressed: () => _addUsual(context),
              child: const Text('+ Add a usual'),
            ),
          ],
        );
      },
    );
  }
}
