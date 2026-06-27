import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ReminderStyleSection, () {
    late UserSettingsBloc userSettingsBloc;
    late NotificationService notificationService;

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      notificationService = MockNotificationService();
    });

    testWidgets('renders a card per reminder style', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc, notificationService],
        const ReminderStyleSection(),
      );

      expect(
        find.byType(RadioOptionCard),
        findsNWidgets(ReminderStyle.values.length),
      );
    });

    testWidgets('selects a non-notification style directly', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc, notificationService],
        const ReminderStyleSection(),
      );

      // Cards render in ReminderStyle.values order.
      await tester.tap(
        find
            .byType(RadioOptionCard)
            .at(
              ReminderStyle.values.indexOf(ReminderStyle.none),
            ),
      );

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.reminderStyleSelected(ReminderStyle.none),
        ),
      ).called(1);
    });

    testWidgets('selects notifications when permission is granted', (
      tester,
    ) async {
      when(
        () => notificationService.requestPermission(),
      ).thenAnswer((_) async => PermissionStatus.granted);
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc, notificationService],
        const ReminderStyleSection(),
      );

      await tester.tap(
        find
            .byType(RadioOptionCard)
            .at(
              ReminderStyle.values.indexOf(ReminderStyle.notifications),
            ),
      );
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.reminderStyleSelected(
            ReminderStyle.notifications,
          ),
        ),
      ).called(1);
    });

    testWidgets('warns and keeps the choice when permission is denied', (
      tester,
    ) async {
      when(
        () => notificationService.requestPermission(),
      ).thenAnswer((_) async => PermissionStatus.denied);
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc, notificationService],
        const ReminderStyleSection(),
      );

      await tester.tap(
        find
            .byType(RadioOptionCard)
            .at(
              ReminderStyle.values.indexOf(ReminderStyle.notifications),
            ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EnableNotificationsInSettingsDialog), findsOneWidget);
      verifyNever(
        () => userSettingsBloc.add(
          const UserSettingsEvent.reminderStyleSelected(
            ReminderStyle.notifications,
          ),
        ),
      );
    });
  });
}
