import 'package:flutter/material.dart';

/// When in the day the weigh-in happens.
enum WeightTimeOfDay {
  morning('Morning · recommended'),
  evening('Evening'),
  night('Night');

  const WeightTimeOfDay(this.label);

  /// Display label for the time of day.
  final String label;

  /// The clock time a weigh-in reminder fires for this slot.
  TimeOfDay get scheduledTime => switch (this) {
    WeightTimeOfDay.morning => const TimeOfDay(hour: 8, minute: 0),
    WeightTimeOfDay.evening => const TimeOfDay(hour: 18, minute: 0),
    WeightTimeOfDay.night => const TimeOfDay(hour: 21, minute: 0),
  };
}
