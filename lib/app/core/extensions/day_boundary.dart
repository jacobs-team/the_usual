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

/// The day-selection range after stepping [deltaDays] from the day currently
/// shown, used by the swipe-between-days gesture. [selectedRange] is the view's
/// current selection — null is the live "today" view — and [today] is the
/// logical day now. Stepping onto today returns null so the view goes live
/// again; any other day returns a single-day range. Unbounded in both
/// directions, so days before and after today are reachable.
DateTimeRange? selectedDayShifted(
  DateTimeRange? selectedRange,
  int deltaDays,
  DateTime today,
) {
  final currentDay = selectedRange == null
      ? today
      : DateUtils.dateOnly(selectedRange.start);
  final shiftedDay = DateUtils.addDaysToDate(currentDay, deltaDays);
  if (DateUtils.isSameDay(shiftedDay, today)) return null;
  return DateTimeRange(start: shiftedDay, end: shiftedDay);
}

/// Calendar-day expansion of a date range.
extension LogicalDaysInRange on DateTimeRange {
  /// Every day this range covers, from [start] to [end] inclusive, each
  /// returned date-only (midnight) so it can key a day bucket or stamp an
  /// entry. A range whose [start] and [end] fall on the same day yields one.
  List<DateTime> get logicalDays {
    final firstDay = DateUtils.dateOnly(start);
    final lastDay = DateUtils.dateOnly(end);
    final dayCount = lastDay.difference(firstDay).inDays;
    return [
      for (var offset = 0; offset <= dayCount; offset++)
        DateTime(firstDay.year, firstDay.month, firstDay.day + offset),
    ];
  }
}
