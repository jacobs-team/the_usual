import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template save_food_as_usual_default_tile}
/// Settings toggle for the default value of the per-food "Save food as usual"
/// checkbox shown when adding a new food.
/// {@endtemplate}
class SaveFoodAsUsualDefaultTile extends StatelessWidget {
  /// {@macro save_food_as_usual_default_tile}
  const SaveFoodAsUsualDefaultTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, bool>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.saveFoodAsUsualDefault,
      builder: (context, saveFoodAsUsualDefault) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Save new foods as usual'),
          subtitle: const Text(
            'Default for the "Save food as usual" checkbox when you add a new '
            'food.',
          ),
          value: saveFoodAsUsualDefault,
          onChanged: (value) => getIt<UserSettingsBloc>().add(
            UserSettingsEvent.saveFoodAsUsualDefaultChanged(value: value),
          ),
        );
      },
    );
  }
}
