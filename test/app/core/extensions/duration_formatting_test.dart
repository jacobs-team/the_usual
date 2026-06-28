import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('Duration.clockLabel', () {
    test('reads 0:00 for zero', () {
      expect(Duration.zero.clockLabel, equals('0:00'));
    });

    test('pads seconds under a minute', () {
      expect(const Duration(seconds: 5).clockLabel, equals('0:05'));
    });

    test('shows m:ss under an hour', () {
      expect(
        const Duration(minutes: 5, seconds: 30).clockLabel,
        equals('5:30'),
      );
    });

    test('shows h:mm:ss once it reaches an hour', () {
      expect(
        const Duration(hours: 1, minutes: 5).clockLabel,
        equals('1:05:00'),
      );
    });

    test('pads minutes and seconds in the hour form', () {
      expect(
        const Duration(hours: 2, minutes: 3, seconds: 9).clockLabel,
        equals('2:03:09'),
      );
    });
  });
}
