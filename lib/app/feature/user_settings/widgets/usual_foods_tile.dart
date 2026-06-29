import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template usual_foods_tile}
/// Settings tile summarizing the usual foods library, navigating to the usual
/// foods screen.
/// {@endtemplate}
class UsualFoodsTile extends StatelessWidget {
  /// {@macro usual_foods_tile}
  const UsualFoodsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, int>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.usualFoodCount,
      builder: (context, usualFoodCount) {
        return SettingsNavRow(
          title: 'Usual foods',
          subtitle: '$usualFoodCount items',
          onTap: () => context.push(Routes.usualFoods),
        );
      },
    );
  }
}
