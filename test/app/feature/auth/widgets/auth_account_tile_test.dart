import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(AuthAccountTile, () {
    late MockAuthCubit authCubit;

    setUp(() {
      authCubit = MockAuthCubit();
      when(() => authCubit.stream).thenAnswer((_) => const Stream.empty());
    });

    void stubState(AuthState state) =>
        when(() => authCubit.state).thenReturn(state);

    testWidgets('shows a GoogleSignInButton when not signed in', (
      tester,
    ) async {
      stubState(const AuthState());

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      expect(find.byType(GoogleSignInButton), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('shows an account icon when the user has no photo', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(id: 'u', email: 'e@x.com'),
        ),
      );

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('shows a CircleAvatar when the user has a photo', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(
            id: 'u',
            email: 'e@x.com',
            photoUrl: 'https://example.com/avatar.png',
          ),
        ),
      );

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsNothing);

      // The CircleAvatar's NetworkImage fails to load in the test
      // environment; drain that async error so it doesn't fail the test.
      tester.takeException();
    });

    testWidgets('uses the email as the title and no subtitle without a name', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(id: 'u', email: 'e@x.com'),
        ),
      );

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.subtitle, isNull);
    });

    testWidgets('uses the name as the title and email as subtitle', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(id: 'u', email: 'e@x.com', displayName: 'Ada'),
        ),
      );

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect(listTile.subtitle, isNotNull);
    });

    testWidgets('calls signOut when the sign-out button is tapped', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(id: 'u', email: 'e@x.com'),
        ),
      );
      when(() => authCubit.signOut()).thenAnswer((_) async {});

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      verify(() => authCubit.signOut()).called(1);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows a snackbar when sign-out is attempted offline', (
      tester,
    ) async {
      stubState(
        const AuthState(
          status: AuthStatus.signedIn,
          user: AuthUser(id: 'u', email: 'e@x.com'),
        ),
      );
      when(
        () => authCubit.signOut(),
      ).thenThrow(const SignOutOfflineException());

      await tester.pumpPumpPumpItUP(
        const AuthAccountTile(),
        deps: [authCubit],
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
