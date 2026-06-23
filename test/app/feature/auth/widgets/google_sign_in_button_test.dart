import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(GoogleSignInButton, () {
    late MockAuthCubit authCubit;

    setUp(() {
      authCubit = MockAuthCubit();
      when(() => authCubit.state).thenReturn(const AuthState());
      when(() => authCubit.stream).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('calls signInWithGoogle and onSignedIn on tap', (tester) async {
      when(() => authCubit.signInWithGoogle()).thenAnswer((_) async {});
      var signedIn = false;

      await tester.pumpPumpPumpItUP(
        GoogleSignInButton(onSignedIn: () => signedIn = true),
        deps: [authCubit],
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => authCubit.signInWithGoogle()).called(1);
      expect(signedIn, isTrue);
    });

    testWidgets('shows a spinner while signing in', (tester) async {
      final completer = Completer<void>();
      when(
        () => authCubit.signInWithGoogle(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpPumpPumpItUP(
        const GoogleSignInButton(),
        deps: [authCubit],
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows a snackbar and skips onSignedIn when sign-in fails', (
      tester,
    ) async {
      when(
        () => authCubit.signInWithGoogle(),
      ).thenThrow(Exception('sign-in failed'));
      var signedIn = false;

      await tester.pumpPumpPumpItUP(
        GoogleSignInButton(onSignedIn: () => signedIn = true),
        deps: [authCubit],
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(signedIn, isFalse);
    });
  });
}
