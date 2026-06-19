import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('DateTimeRange.logicalDays', () {
    test('returns one date-only day for a single-day range', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 17, 9),
        end: DateTime(2026, 6, 17, 22),
      );

      expect(range.logicalDays, equals([DateTime(2026, 6, 17)]));
    });

    test('returns every day from start to end inclusive', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 15),
        end: DateTime(2026, 6, 18),
      );

      expect(
        range.logicalDays,
        equals([
          DateTime(2026, 6, 15),
          DateTime(2026, 6, 16),
          DateTime(2026, 6, 17),
          DateTime(2026, 6, 18),
        ]),
      );
    });

    test('crosses a month boundary correctly', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 30),
        end: DateTime(2026, 7, 2),
      );

      expect(
        range.logicalDays,
        equals([
          DateTime(2026, 6, 30),
          DateTime(2026, 7, 1),
          DateTime(2026, 7, 2),
        ]),
      );
    });
  });
}
