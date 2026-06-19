import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('NumberFormatting', () {
    group('compact', () {
      test('leaves values under 1000 as whole numbers', () {
        expect(0.compact, equals('0'));
        expect(999.compact, equals('999'));
        expect(950.4.compact, equals('950'));
      });

      test('renders thousands with one decimal and a k suffix', () {
        expect(1000.compact, equals('1.0k'));
        expect(1500.compact, equals('1.5k'));
        expect(12300.compact, equals('12.3k'));
      });
    });

    group('trimmedDecimal', () {
      test('drops a trailing .0 for whole numbers', () {
        expect(165.0.trimmedDecimal, equals('165'));
        expect(200.trimmedDecimal, equals('200'));
      });

      test('keeps the decimal for fractional numbers', () {
        expect(165.5.trimmedDecimal, equals('165.5'));
      });

      test('clears floating-point dust', () {
        expect(2.3000000000000003.trimmedDecimal, equals('2.3'));
        expect((0.1 + 0.2).trimmedDecimal, equals('0.3'));
      });
    });
  });
}
