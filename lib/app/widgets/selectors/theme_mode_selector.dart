import 'package:flutter/material.dart';

/// {@template theme_mode_selector}
/// Segmented control for choosing whether the app follows the system theme or
/// is forced light or dark.
/// {@endtemplate}
class ThemeModeSelector extends StatelessWidget {
  /// {@macro theme_mode_selector}
  const ThemeModeSelector({
    required this.themeMode,
    required this.onChanged,
    super.key,
  });

  /// The currently selected theme mode.
  final ThemeMode themeMode;

  /// Called with the newly selected theme mode.
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        for (final option in ThemeMode.values)
          ButtonSegment(
            value: option,
            label: Text(switch (option) {
              ThemeMode.system => 'System',
              ThemeMode.light => 'Light',
              ThemeMode.dark => 'Dark',
            }),
          ),
      ],
      selected: {themeMode},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
