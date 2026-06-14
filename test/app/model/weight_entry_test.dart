import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WeightEntry, () {
    final loggedAt = DateTime(2026, 6, 14, 7);

    test('round-trips through json', () {
      final weightEntry = WeightEntry(
        id: 'weight-1',
        loggedAt: loggedAt,
        weight: 165.5,
        weightUnit: WeightUnit.lb,
      );

      final decoded = WeightEntry.fromJson(weightEntry.toJson());

      expect(decoded, equals(weightEntry));
    });

    group('label', () {
      test('drops a trailing .0 for whole numbers', () {
        final weightEntry = WeightEntry(
          id: 'weight-2',
          loggedAt: loggedAt,
          weight: 165,
          weightUnit: WeightUnit.lb,
        );

        expect(weightEntry.label, equals('165 lb'));
      });

      test('keeps the decimal for fractional weights', () {
        final weightEntry = WeightEntry(
          id: 'weight-3',
          loggedAt: loggedAt,
          weight: 72.4,
          weightUnit: WeightUnit.kg,
        );

        expect(weightEntry.label, equals('72.4 kg'));
      });
    });
  });
}
