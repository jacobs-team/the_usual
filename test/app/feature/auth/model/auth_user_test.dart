import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(AuthUser, () {
    const authUser = AuthUser(
      id: 'user-1',
      email: 'jane@example.com',
      displayName: 'Jane Doe',
      photoUrl: 'https://example.com/avatar.png',
    );

    test('toJson serializes every field', () {
      expect(
        authUser.toJson(),
        equals({
          'id': 'user-1',
          'email': 'jane@example.com',
          'displayName': 'Jane Doe',
          'photoUrl': 'https://example.com/avatar.png',
        }),
      );
    });

    test('fromJson round-trips back to an equal $AuthUser', () {
      expect(AuthUser.fromJson(authUser.toJson()), equals(authUser));
    });

    test('fromJson reads null optional fields', () {
      final decoded = AuthUser.fromJson({
        'id': 'user-2',
        'email': 'no-name@example.com',
        'displayName': null,
        'photoUrl': null,
      });

      expect(decoded.displayName, isNull);
      expect(decoded.photoUrl, isNull);
      expect(decoded.id, equals('user-2'));
      expect(decoded.email, equals('no-name@example.com'));
    });
  });
}
