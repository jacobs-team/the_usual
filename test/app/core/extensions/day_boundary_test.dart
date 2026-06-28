import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('selectedDayShifted', () {
    final today = DateTime(2026, 6, 17);

    test('returns null when stepping back onto today from a selected day', () {
      final selectedRange = DateTimeRange(
        start: DateTime(2026, 6, 16),
        end: DateTime(2026, 6, 16),
      );

      expect(selectedDayShifted(selectedRange, 1, today), isNull);
    });

    test('returns null when stepping from the live view onto today', () {
      expect(selectedDayShifted(null, 0, today), isNull);
    });

    test('returns a single-day range when stepping off today', () {
      expect(
        selectedDayShifted(null, -1, today),
        isA<DateTimeRange>()
            .having((r) => r.start, 'start', equals(DateTime(2026, 6, 16)))
            .having((r) => r.end, 'end', equals(DateTime(2026, 6, 16))),
      );
    });

    test('steps forward from a selected day to another non-today day', () {
      final selectedRange = DateTimeRange(
        start: DateTime(2026, 6, 14),
        end: DateTime(2026, 6, 14),
      );

      expect(
        selectedDayShifted(selectedRange, 1, today),
        isA<DateTimeRange>().having(
          (r) => r.start,
          'start',
          equals(DateTime(2026, 6, 15)),
        ),
      );
    });
  });

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
          DateTime(2026, 7),
          DateTime(2026, 7, 2),
        ]),
      );
    });
  });
}
