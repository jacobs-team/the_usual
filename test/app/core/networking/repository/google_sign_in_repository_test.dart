import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

void main() {
  late MockGoogleSignIn googleSignIn;
  late GoogleSignInRepository repository;

  setUp(() {
    googleSignIn = MockGoogleSignIn();
    repository = GoogleSignInRepository(googleSignIn);
  });

  group(GoogleSignInRepository, () {
    test('falls back to the SDK singleton when none is injected', () {
      // Constructing with no injected dep evaluates GoogleSignIn.instance,
      // which resolves the platform interface without a registered
      // implementation in the test host.
      expect(GoogleSignInRepository.new, returnsNormally);
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

    group('authenticate', () {
      test('returns null when authenticate is not supported', () async {
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(false);

        expect(await repository.authenticate(), isNull);
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

        expect(await repository.authenticate(), isNull);
      });

      test('rethrows non-cancel $GoogleSignInException', () async {
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
        when(() => googleSignIn.authenticate()).thenThrow(
          const GoogleSignInException(
            code: GoogleSignInExceptionCode.unknownError,
            description: 'boom',
          ),
        );

        expect(
          repository.authenticate(),
          throwsA(isA<GoogleSignInException>()),
        );
      });

      test('returns the account ID token on success', () async {
        final account = MockGoogleSignInAccount();
        when(() => googleSignIn.supportsAuthenticate()).thenReturn(true);
        when(
          () => googleSignIn.authenticate(),
        ).thenAnswer((_) async => account);
        when(() => account.authentication).thenReturn(
          const GoogleSignInAuthentication(idToken: 'id-token'),
        );

        expect(await repository.authenticate(), equals('id-token'));
      });
    });

    group('signOut', () {
      test('signs out of the Google SDK', () async {
        when(() => googleSignIn.signOut()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => googleSignIn.signOut()).called(1);
      });
    });
  });
}
