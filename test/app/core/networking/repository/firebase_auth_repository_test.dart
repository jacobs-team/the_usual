import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class _FakeAuthCredential extends Fake implements AuthCredential {}

class _FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAuthCredential());
    registerFallbackValue(_FakeAuthProvider());
  });

  late MockFirebaseAuth firebaseAuth;
  late FirebaseAuthRepository repository;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    repository = FirebaseAuthRepository(firebaseAuth);
  });

  test('falls back to the SDK singleton when no deps are injected', () {
    // Constructing with no injected deps evaluates FirebaseAuth.instance, which
    // throws without an initialized app.
    expect(FirebaseAuthRepository.new, throwsA(anything));
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

  group(FirebaseAuthRepository, () {
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
          emits(isA<AuthUser>().having((u) => u.email, 'email', equals(''))),
        );
      });

      test('maps a null Firebase user to null', () {
        when(
          () => firebaseAuth.authStateChanges(),
        ).thenAnswer((_) => Stream<User?>.value(null));

        expect(repository.authChanges, emits(isNull));
      });
    });

    group('signInWithGoogleIdToken', () {
      test('returns the signed-in user and isNewUser on success', () async {
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

        final result = await repository.signInWithGoogleIdToken('id-token');

        expect(result.isNewUser, isTrue);
        expect(
          result.user,
          isA<AuthUser>().having((u) => u.id, 'id', equals('uid-1')),
        );
      });

      test('defaults isNewUser to false when info is null', () async {
        final firebaseUser = buildFirebaseUser();
        final userCredential = MockUserCredential();
        when(() => userCredential.user).thenReturn(firebaseUser);
        when(() => userCredential.additionalUserInfo).thenReturn(null);
        when(
          () => firebaseAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => userCredential);

        final result = await repository.signInWithGoogleIdToken('id-token');

        expect(result.isNewUser, isFalse);
      });
    });

    group('signInWithGooglePopup', () {
      test('returns the signed-in user on success', () async {
        final firebaseUser = buildFirebaseUser();
        final additionalUserInfo = MockAdditionalUserInfo();
        when(() => additionalUserInfo.isNewUser).thenReturn(false);
        final userCredential = MockUserCredential();
        when(() => userCredential.user).thenReturn(firebaseUser);
        when(
          () => userCredential.additionalUserInfo,
        ).thenReturn(additionalUserInfo);
        when(
          () => firebaseAuth.signInWithPopup(any()),
        ).thenAnswer((_) async => userCredential);

        final result = await repository.signInWithGooglePopup();

        expect(
          result?.user,
          isA<AuthUser>().having((u) => u.id, 'id', equals('uid-1')),
        );
      });

      test('returns null when the popup is closed or superseded', () async {
        when(() => firebaseAuth.signInWithPopup(any())).thenThrow(
          FirebaseAuthException(code: 'popup-closed-by-user'),
        );

        expect(await repository.signInWithGooglePopup(), isNull);
      });

      test('rethrows a non-cancel $FirebaseAuthException', () async {
        when(() => firebaseAuth.signInWithPopup(any())).thenThrow(
          FirebaseAuthException(code: 'network-request-failed'),
        );

        expect(
          repository.signInWithGooglePopup(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signOut', () {
      test('signs out of the Firebase session', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => firebaseAuth.signOut()).called(1);
      });
    });
  });
}
