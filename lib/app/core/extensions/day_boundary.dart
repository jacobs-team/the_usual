import 'package:flutter/material.dart';

/// Day-boundary helpers. The app's day rolls over at a configurable time — the
/// user's day-start, 4 AM by default — rather than at midnight, so a meal or
/// weigh-in logged just after midnight still counts toward the previous day.
extension DayBoundary on DateTime {
  /// The logical day this timestamp falls on for a day that begins at
  /// [dayStart]. Times earlier than [dayStart] belong to the previous calendar
  /// day. Returned date-only (midnight) so it can key a day bucket.
  DateTime logicalDay(TimeOfDay dayStart) {
    final dayStartOffset = Duration(
      hours: dayStart.hour,
      minutes: dayStart.minute,
    );
    return DateUtils.dateOnly(subtract(dayStartOffset));
  }

  /// This logical day shifted forward to [dayStart], i.e. the instant the day
  /// begins. Call on a logical-day date to stamp an entry onto that day so it
  /// buckets back to the same day.
  DateTime atDayStart(TimeOfDay dayStart) => DateUtils.dateOnly(this).add(
    Duration(hours: dayStart.hour, minutes: dayStart.minute),
  );
}
