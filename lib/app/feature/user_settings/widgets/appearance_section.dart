import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template appearance_section}
/// Settings section for choosing the app's theme: system, light, or dark.
/// {@endtemplate}
class AppearanceSection extends StatelessWidget {
  /// {@macro appearance_section}
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, ThemeMode>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.themeMode,
      builder: (context, themeMode) {
        return ThemeModeSelector(
          themeMode: themeMode,
          onChanged: (themeMode) => getIt<UserSettingsBloc>().add(
            UserSettingsEvent.themeModeSelected(themeMode),
          ),
        );
      },
    );
  }
}
