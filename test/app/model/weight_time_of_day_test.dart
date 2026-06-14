import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WeightTimeOfDay, () {
    test('exposes a display label for each slot', () {
      expect(WeightTimeOfDay.morning.label, equals('Morning · recommended'));
      expect(WeightTimeOfDay.evening.label, equals('Evening'));
      expect(WeightTimeOfDay.night.label, equals('Night'));
    });

    test('maps each slot to its scheduled clock time', () {
      expect(
        WeightTimeOfDay.morning.scheduledTime,
        equals(const TimeOfDay(hour: 8, minute: 0)),
      );
      expect(
        WeightTimeOfDay.evening.scheduledTime,
        equals(const TimeOfDay(hour: 18, minute: 0)),
      );
      expect(
        WeightTimeOfDay.night.scheduledTime,
        equals(const TimeOfDay(hour: 21, minute: 0)),
      );
    });
  });
}
