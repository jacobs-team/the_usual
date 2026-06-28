import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(AuthCubit, () {
    late MockAuthRepository authRepository;
    late MockSyncRepository syncRepository;
    late MockConnectivityCubit connectivityCubit;
    late StreamController<AuthUser?> authChanges;
    late AuthCubit cubit;

    const user = AuthUser(id: 'u1', email: 'e@x.com');
    const newUserResult = (user: user, isNewUser: true);
    const returningUserResult = (user: user, isNewUser: false);

    AuthCubit buildCubit() =>
        AuthCubit(authRepository, syncRepository, connectivityCubit);

    // Drives an authChanges emission to completion. ready resolves once the
    // first emission is handled (resume awaits its async work before marking
    // ready); a tiny delay drains later emissions.
    Future<void> settle() => Future<void>.delayed(Duration.zero);

    setUp(() {
      initHydratedStorage();
      authRepository = MockAuthRepository();
      syncRepository = MockSyncRepository();
      connectivityCubit = MockConnectivityCubit();
      authChanges = StreamController<AuthUser?>.broadcast();

      when(
        () => authRepository.authChanges,
      ).thenAnswer((_) => authChanges.stream);
      when(() => authRepository.initialize()).thenAnswer((_) async {});
      when(() => authRepository.signOut()).thenAnswer((_) async {});
      when(() => syncRepository.hasEstablishedData).thenReturn(false);
      when(
        () => syncRepository.cloudDocExists(any()),
      ).thenAnswer((_) async => false);
      when(() => syncRepository.uploadLocal(any())).thenAnswer((_) async {});
      when(
        () => syncRepository.downloadAndApply(any()),
      ).thenAnswer((_) async => false);
      when(
        () => syncRepository.markOnboardingComplete(),
      ).thenAnswer((_) async {});
      when(() => syncRepository.clearLocal()).thenAnswer((_) async {});
      when(
        () => syncRepository.flushAndConfirm(any()),
      ).thenAnswer((_) async {});
      when(() => connectivityCubit.state).thenReturn(true);

      cubit = buildCubit();
    });

    tearDown(() async {
      await authChanges.close();
      await cubit.close();
    });

    group('startup auth changes', () {
      test('resumes a persisted session and skips onboarding when '
          'cloud data is established', () async {
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenAnswer((_) async => true);

        authChanges.add(user);
        await cubit.ready;

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        expect(cubit.state.user, equals(user));
        verify(() => syncRepository.downloadAndApply('u1')).called(1);
        verify(() => syncRepository.markOnboardingComplete()).called(1);
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('resumes a session and leaves onboarding when cloud data is '
          'empty', () async {
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenAnswer((_) async => false);

        authChanges.add(user);
        await cubit.ready;

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verifyNever(() => syncRepository.markOnboardingComplete());
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('resume swallows a download failure and still watches', () async {
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenThrow(Exception('offline'));

        authChanges.add(user);
        await cubit.ready;

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('a relaunch already signed in just resyncs', () async {
        // First emission resumes to signedIn.
        authChanges.add(user);
        await cubit.ready;
        // A second emission now takes the already-signed-in branch.
        authChanges.add(user);
        await settle();

        verify(() => syncRepository.startWatching('u1')).called(2);
      });

      test('a null emission while signed in drops to guest', () async {
        authChanges.add(user);
        await cubit.ready;

        authChanges.add(null);
        await settle();

        expect(cubit.state.status, equals(AuthStatus.guest));
        expect(cubit.state.user, isNull);
        verify(() => syncRepository.stopWatching()).called(1);
      });

      test('a null emission while unknown just resolves ready', () async {
        authChanges.add(null);
        await cubit.ready;

        expect(cubit.state.status, equals(AuthStatus.unknown));
      });
    });

    group('restoreOnStartup', () {
      test('initializes the sign-in SDK', () async {
        await cubit.restoreOnStartup();
        verify(() => authRepository.initialize()).called(1);
      });

      test('swallows an initialize failure', () async {
        when(() => authRepository.initialize()).thenThrow(Exception('boom'));
        await expectLater(cubit.restoreOnStartup(), completes);
      });
    });

    group('signInWithGoogle', () {
      test('does nothing when the user cancels', () async {
        when(() => authRepository.signIn()).thenAnswer((_) async => null);

        await cubit.signInWithGoogle();

        expect(cubit.state.status, equals(AuthStatus.unknown));
        verifyNever(() => syncRepository.uploadLocal(any()));
      });

      test('rethrows and resets the in-progress flag on failure', () async {
        when(() => authRepository.signIn()).thenThrow(Exception('network'));

        await expectLater(cubit.signInWithGoogle(), throwsException);
      });

      test('new account with no guest data uploads and signs in', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => newUserResult);

        await cubit.signInWithGoogle();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.uploadLocal('u1')).called(1);
        verify(() => syncRepository.resetOnboarding()).called(1);
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('new account with guest data raises the keep/start-fresh '
          'prompt', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => newUserResult);
        when(() => syncRepository.hasEstablishedData).thenReturn(true);

        await cubit.signInWithGoogle();

        expect(
          cubit.state.pendingPrompt,
          equals(SignInPrompt.keepOrStartFresh),
        );
        expect(cubit.state.status, equals(AuthStatus.unknown));
      });

      test('a missing cloud doc is treated as a new account', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => returningUserResult);
        when(
          () => syncRepository.cloudDocExists('u1'),
        ).thenAnswer((_) async => false);

        await cubit.signInWithGoogle();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.uploadLocal('u1')).called(1);
      });

      test('existing account with guest data raises the replace '
          'prompt', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => returningUserResult);
        when(
          () => syncRepository.cloudDocExists('u1'),
        ).thenAnswer((_) async => true);
        when(() => syncRepository.hasEstablishedData).thenReturn(true);

        await cubit.signInWithGoogle();

        expect(
          cubit.state.pendingPrompt,
          equals(SignInPrompt.replaceLocalWithCloud),
        );
      });

      test('existing account with no guest data downloads and signs '
          'in', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => returningUserResult);
        when(
          () => syncRepository.cloudDocExists('u1'),
        ).thenAnswer((_) async => true);
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenAnswer((_) async => true);

        await cubit.signInWithGoogle();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.markOnboardingComplete()).called(1);
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('existing account with empty cloud data routes to '
          'onboarding', () async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => returningUserResult);
        when(
          () => syncRepository.cloudDocExists('u1'),
        ).thenAnswer((_) async => true);
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenAnswer((_) async => false);

        await cubit.signInWithGoogle();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.resetOnboarding()).called(1);
      });
    });

    group('guest-data dialog resolutions', () {
      // Puts the cubit into a pending-prompt state with _pendingUid set.
      Future<void> startPendingSignIn({required bool existing}) async {
        when(() => syncRepository.hasEstablishedData).thenReturn(true);
        when(() => authRepository.signIn()).thenAnswer(
          (_) async => existing ? returningUserResult : newUserResult,
        );
        when(
          () => syncRepository.cloudDocExists('u1'),
        ).thenAnswer((_) async => existing);
        await cubit.signInWithGoogle();
      }

      test('keepGuestData uploads and signs in', () async {
        await startPendingSignIn(existing: false);

        await cubit.keepGuestData();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.uploadLocal('u1')).called(1);
        verify(() => syncRepository.startWatching('u1')).called(1);
      });

      test('startFresh clears local, uploads empty and signs in', () async {
        await startPendingSignIn(existing: false);

        await cubit.startFresh();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.clearLocal()).called(1);
        verify(() => syncRepository.uploadLocal('u1')).called(1);
      });

      test('confirmReplaceWithCloud downloads over local', () async {
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenAnswer((_) async => true);
        await startPendingSignIn(existing: true);

        await cubit.confirmReplaceWithCloud();

        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verify(() => syncRepository.downloadAndApply('u1')).called(1);
        verify(() => syncRepository.markOnboardingComplete()).called(1);
      });

      test('cancelSignIn signs back out and stays guest', () async {
        await startPendingSignIn(existing: true);

        await cubit.cancelSignIn();

        expect(cubit.state.pendingPrompt, isNull);
        expect(cubit.state.status, equals(AuthStatus.unknown));
        verify(() => authRepository.signOut()).called(1);
      });

      test('a resolution is a no-op when no sign-in is pending', () async {
        await cubit.keepGuestData();
        await cubit.startFresh();
        await cubit.confirmReplaceWithCloud();

        verifyNever(() => syncRepository.uploadLocal(any()));
        verifyNever(() => syncRepository.downloadAndApply(any()));
      });

      test('keepGuestData rethrows and resets on upload failure', () async {
        await startPendingSignIn(existing: false);
        when(
          () => syncRepository.uploadLocal('u1'),
        ).thenThrow(Exception('upload'));

        await expectLater(cubit.keepGuestData(), throwsException);
        expect(cubit.state.pendingPrompt, isNull);
      });

      test('startFresh rethrows and resets on clear failure', () async {
        await startPendingSignIn(existing: false);
        when(
          () => syncRepository.clearLocal(),
        ).thenThrow(Exception('clear'));

        await expectLater(cubit.startFresh(), throwsException);
        expect(cubit.state.pendingPrompt, isNull);
      });

      test('confirmReplaceWithCloud rethrows and resets on download '
          'failure', () async {
        await startPendingSignIn(existing: true);
        when(
          () => syncRepository.downloadAndApply('u1'),
        ).thenThrow(Exception('download'));

        await expectLater(cubit.confirmReplaceWithCloud(), throwsException);
        expect(cubit.state.pendingPrompt, isNull);
      });
    });

    group('continueAsGuest', () {
      test('records the guest choice', () {
        cubit.continueAsGuest();
        expect(cubit.state.status, equals(AuthStatus.guest));
      });
    });

    group('signOut', () {
      Future<void> signIn() async {
        when(
          () => authRepository.signIn(),
        ).thenAnswer((_) async => newUserResult);
        await cubit.signInWithGoogle();
      }

      test('flushes to the cloud, clears local and returns to guest', () async {
        await signIn();

        await cubit.signOut();

        expect(cubit.state.status, equals(AuthStatus.guest));
        expect(cubit.state.user, isNull);
        verify(() => syncRepository.flushAndConfirm('u1')).called(1);
        verify(() => syncRepository.stopWatching()).called(1);
        verify(() => syncRepository.clearLocal()).called(1);
        verify(() => authRepository.signOut()).called(1);
      });

      test('throws and keeps state when offline', () async {
        await signIn();
        when(() => connectivityCubit.state).thenReturn(false);

        await expectLater(
          cubit.signOut(),
          throwsA(isA<SignOutOfflineException>()),
        );
        expect(cubit.state.status, equals(AuthStatus.signedIn));
        verifyNever(() => syncRepository.flushAndConfirm(any()));
      });

      test('skips the flush when there is no signed-in user', () async {
        await cubit.signOut();

        verifyNever(() => syncRepository.flushAndConfirm(any()));
        expect(cubit.state.status, equals(AuthStatus.guest));
      });
    });

    group('hydration', () {
      test('restores a persisted signed-in session via fromJson', () {
        when(() => HydratedBloc.storage.read('AuthCubit')).thenReturn(
          const AuthState(status: AuthStatus.signedIn, user: user).toJson(),
        );

        final hydrated = buildCubit();
        addTearDown(hydrated.close);

        expect(hydrated.state.status, equals(AuthStatus.signedIn));
        expect(hydrated.state.user, equals(user));
      });
    });

    group('as a Listenable', () {
      test('notifies and stops notifying listeners on state change', () {
        var notified = 0;
        void listener() => notified++;

        cubit
          ..addListener(listener)
          ..continueAsGuest();
        expect(notified, equals(1));

        cubit
          ..removeListener(listener)
          ..continueAsGuest();
        expect(notified, equals(1));
      });
    });
  });

  group(AuthState, () {
    const user = AuthUser(id: 'u1', email: 'e@x.com');

    test('signedIn reflects the status', () {
      expect(const AuthState(status: AuthStatus.signedIn).signedIn, isTrue);
      expect(const AuthState().signedIn, isFalse);
    });

    test('discards legacy v0 and v1 placeholder data', () {
      expect(AuthState.fromJson({'version': 0}), equals(const AuthState()));
      expect(AuthState.fromJson({'version': 1}), equals(const AuthState()));
    });

    test('reads current version data', () {
      final state = AuthState.fromJson(
        const AuthState(status: AuthStatus.signedIn, user: user).toJson(),
      );
      expect(state.status, equals(AuthStatus.signedIn));
      expect(state.user, equals(user));
    });

    test('best-effort reads an unknown future version', () {
      final json = const AuthState(
        version: 99,
        status: AuthStatus.guest,
      ).toJson();
      expect(AuthState.fromJson(json).status, equals(AuthStatus.guest));
    });
  });
}
