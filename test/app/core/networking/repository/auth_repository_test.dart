import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

class MockGoogleSignInRepository extends Mock
    implements GoogleSignInRepository {}

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

void main() {
  late MockGoogleSignInRepository googleSignInRepository;
  late MockFirebaseAuthRepository firebaseAuthRepository;
  late AuthRepository repository;

  const authUser = AuthUser(id: 'uid-1', email: 'jane@example.com');
  const signInResult = (user: authUser, isNewUser: true);

  setUp(() {
    googleSignInRepository = MockGoogleSignInRepository();
    firebaseAuthRepository = MockFirebaseAuthRepository();
    repository = AuthRepository(googleSignInRepository, firebaseAuthRepository);
  });

  group(AuthRepository, () {
    test('authChanges delegates to the Firebase repository', () {
      when(
        () => firebaseAuthRepository.authChanges,
      ).thenAnswer((_) => Stream<AuthUser?>.value(authUser));

      expect(repository.authChanges, emits(equals(authUser)));
    });

    test('initialize delegates to the Google sign-in repository', () async {
      when(() => googleSignInRepository.initialize()).thenAnswer((_) async {});

      await repository.initialize();

      verify(() => googleSignInRepository.initialize()).called(1);
    });

    group('signIn', () {
      test('exchanges the Google ID token for a Firebase session', () async {
        when(
          () => googleSignInRepository.authenticate(),
        ).thenAnswer((_) async => 'id-token');
        when(
          () => firebaseAuthRepository.signInWithGoogleIdToken('id-token'),
        ).thenAnswer((_) async => signInResult);

        final result = await repository.signIn();

        expect(result, equals(signInResult));
        verify(
          () => firebaseAuthRepository.signInWithGoogleIdToken('id-token'),
        ).called(1);
      });

      test('returns null without a Firebase exchange when cancelled', () async {
        when(
          () => googleSignInRepository.authenticate(),
        ).thenAnswer((_) async => null);

        expect(await repository.signIn(), isNull);
        verifyNever(
          () => firebaseAuthRepository.signInWithGoogleIdToken(any()),
        );
      });
    });

    group('signOut', () {
      test('signs out of both Firebase and Google', () async {
        when(() => firebaseAuthRepository.signOut()).thenAnswer((_) async {});
        when(() => googleSignInRepository.signOut()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => firebaseAuthRepository.signOut()).called(1);
        verify(() => googleSignInRepository.signOut()).called(1);
      });
    });
  });
}
