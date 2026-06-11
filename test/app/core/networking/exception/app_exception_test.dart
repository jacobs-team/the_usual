import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TestException extends AppException {
  const _TestException({super.statusCode, super.error})
    : super(message: 'Something failed');
}

void main() {
  group(AppException, () {
    test('toString returns type and message', () {
      expect(
        const _TestException().toString(),
        equals('_TestException: Something failed'),
      );
    });

    test('toString includes status code and cause when present', () {
      expect(
        const _TestException(statusCode: 404, error: 'boom').toString(),
        equals('_TestException(404): Something failed\nCaused by: boom'),
      );
    });
  });
}
