import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class _FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthCredential());
  });

  late MockGoogleSignIn googleSignIn;
  late MockFirebaseAuth firebaseAuth;
  late GoogleAuthRepository repository;

  setUp(() {
    googleSignIn = MockGoogleSignIn();
    firebaseAuth = MockFirebaseAuth();
    repository = GoogleAuthRepository(googleSignIn, firebaseAuth);
  });

  test('falls back to the SDK singletons when no deps are injected', () {
    // Constructing with no injected deps evaluates GoogleSignIn.instance and
    // FirebaseAuth.instance; the latter throws without an initialized app.
    expect(GoogleAuthRepository.new, throwsA(anything));
  });

  MockUser buildFirebaseUser({
    String uid = 'uid-1',
    String? email = 'jane@example.com',
    String? displayName = 'Jane Doe',
    String? photoUrl = 'https://example.com/avatar.png',
  }) {
    final user = MockUser();
    when(() => user.uid).thenReturn(uid);
    when(() => user.email).thenReturn(email);
    when(() => user.displayName).thenReturn(displayName);
    when(() => user.photoURL).thenReturn(photoUrl);
    return user;
  }

  group(GoogleAuthRepository, () {
    group('authChanges', () {
      test('maps a Firebase user to an $AuthUser', () {
        final firebaseUser = buildFirebaseUser();
        when(
          () => firebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream<User?>.value(firebaseUser));

        expect(
          repository.authChanges,
          emits(
            isA<AuthUser>()
                .having((u) => u.id, 'id', equals('uid-1'))
                .having((u) => u.email, 'email', equals('jane@example.com'))
                .having(
                  (u) => u.displayName,
                  'displayName',
                  equals('Jane Doe'),
                )
                .having(
                  (u) => u.photoUrl,
                  'photoUrl',
                  equals('https://example.com/avatar.png'),
                ),
          ),
        );
      });

      test('maps a null email to an empty string', () {
        final firebaseUser = buildFirebaseUser(email: null);
        when(
          () => firebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream<User?>.value(firebaseUser));

        expect(
          repository.authChanges,
          emits(
            isA<AuthUser>().having((u) => u.email, 'email', equals('')),
          ),
        );
      });

      test('maps a null Firebase user to null', () {
        when(
          () => firebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream<User?>.value(null));

        expect(repository.authChanges, emits(isNull));
      });
    });

    group('initialize', () {
      test('initializes the Google sign-in SDK once', () async {
        when(
          () => googleSignIn.initialize(
            clientId: any(named: 'clientId'),
            serverClientId: any(named: 'serverClientId'),
          ),
        ).thenAnswer((_) async {});

        await repository.initialize();
        await repository.initialize();

        verify(
          () => googleSignIn.initialize(
            clientId: any(named: 'clientId'),
            serverClientId: any(named: 'serverClientId'),
          ),
        ).called(1);
      });
    });

    group('signIn', () {
      test('returns null when authenticate is not supported', () async {
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(false);

        expect(await repository.signIn(), isNull);
        verifyNever(() => googleSignIn.authenticate());
      });

      test('returns null when the user cancels', () async {
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
        when(() => googleSignIn.authenticate()).thenThrow(
          const GoogleSignInException(
            code: GoogleSignInExceptionCode.canceled,
            description: 'cancelled',
          ),
        );

        expect(await repository.signIn(), isNull);
      });

      test('rethrows non-cancel $GoogleSignInException', () async {
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
        when(() => googleSignIn.authenticate()).thenThrow(
          const GoogleSignInException(
            code: GoogleSignInExceptionCode.unknownError,
            description: 'boom',
          ),
        );

        expect(repository.signIn(), throwsA(isA<GoogleSignInException>()));
      });

      test('returns the signed-in user and isNewUser on success', () async {
        final account = MockGoogleSignInAccount();
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
        when(
          () => googleSignIn.authenticate(),
        ).thenAnswer((_) async => account);
        when(() => account.authentication).thenReturn(
          const GoogleSignInAuthentication(idToken: 'id-token'),
        );

        final firebaseUser = buildFirebaseUser();
        final additionalUserInfo = MockAdditionalUserInfo();
        when(() => additionalUserInfo.isNewUser).thenReturn(true);
        final userCredential = MockUserCredential();
        when(() => userCredential.user).thenReturn(firebaseUser);
        when(
          () => userCredential.additionalUserInfo,
        ).thenReturn(additionalUserInfo);
        when(
          () => firebaseAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => userCredential);

        final result = await repository.signIn();

        expect(result, isNotNull);
        expect(result!.isNewUser, isTrue);
        expect(
          result.user,
          isA<AuthUser>().having((u) => u.id, 'id', equals('uid-1')),
        );
      });

      test(
        'defaults isNewUser to false when additionalUserInfo is null',
        () async {
          final account = MockGoogleSignInAccount();
          when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
          when(
            () => googleSignIn.authenticate(),
          ).thenAnswer((_) async => account);
          when(() => account.authentication).thenReturn(
            const GoogleSignInAuthentication(idToken: 'id-token'),
          );

          final firebaseUser = buildFirebaseUser();
          final userCredential = MockUserCredential();
          when(() => userCredential.user).thenReturn(firebaseUser);
          when(() => userCredential.additionalUserInfo).thenReturn(null);
          when(
            () => firebaseAuth.signInWithCredential(any()),
          ).thenAnswer((_) async => userCredential);

          final result = await repository.signIn();

          expect(result!.isNewUser, isFalse);
        },
      );
    });

    group('signOut', () {
      test('signs out of both Firebase and Google', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });
    });
  });
}
