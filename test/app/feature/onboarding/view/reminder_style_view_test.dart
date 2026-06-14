import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ReminderStyleView, () {
    late OnboardingBloc onboardingBloc;
    late NotificationService notificationService;

    OnboardingState stateWith(ReminderStyle reminderStyle) {
      return OnboardingState(
        activeStepIndex: 2,
        settings: UserSettingsState(reminderStyle: reminderStyle),
      );
    }

    void stubBloc(ReminderStyle reminderStyle) {
      when(() => onboardingBloc.state).thenReturn(stateWith(reminderStyle));
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      notificationService = MockNotificationService();
    });

    testWidgets('renders a card per reminder style', (tester) async {
      stubBloc(ReminderStyle.notifications);
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const ReminderStyleView(),
      );

      expect(find.byType(RadioOptionCard), findsNWidgets(3));
    });

    testWidgets('adds reminderStyleSelected when a card is tapped', (
      tester,
    ) async {
      stubBloc(ReminderStyle.notifications);
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const ReminderStyleView(),
      );

      await tester.tap(find.text(ReminderStyle.none.label));

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.reminderStyleSelected(ReminderStyle.none),
        ),
      ).called(1);
    });

    testWidgets('continues directly when notifications is not chosen', (
      tester,
    ) async {
      stubBloc(ReminderStyle.onAppOpen);
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const ReminderStyleView(),
      );

      await tester.tap(find.text('Continue'));
      await tester.pump();

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('continues when notification permission is granted', (
      tester,
    ) async {
      stubBloc(ReminderStyle.notifications);
      when(
        () => notificationService.requestPermission(),
      ).thenAnswer((_) async => PermissionStatus.granted);
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const ReminderStyleView(),
      );

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('falls back to on-app-open and warns when permission denied', (
      tester,
    ) async {
      stubBloc(ReminderStyle.notifications);
      when(
        () => notificationService.requestPermission(),
      ).thenAnswer((_) async => PermissionStatus.permanentlyDenied);
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const ReminderStyleView(),
      );

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.reminderStyleSelected(ReminderStyle.onAppOpen),
        ),
      ).called(1);
      expect(
        find.byType(EnableNotificationsInSettingsDialog),
        findsOneWidget,
      );
    });
  });
}
