import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(AppearanceSection, () {
    late UserSettingsBloc userSettingsBloc;

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders the theme mode selector', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const AppearanceSection(),
      );

      expect(find.byType(ThemeModeSelector), findsOneWidget);
    });

    testWidgets('adds themeModeSelected when a mode is chosen', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const AppearanceSection(),
      );

      // Segments render in ThemeMode.values order: system, light, dark.
      final darkSegment = find
          .descendant(
            of: find.byType(ThemeModeSelector),
            matching: find.byType(TextButton),
          )
          .at(ThemeMode.values.indexOf(ThemeMode.dark));
      await tester.tap(darkSegment);

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.themeModeSelected(ThemeMode.dark),
        ),
      ).called(1);
    });
  });
}
