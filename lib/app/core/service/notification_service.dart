import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_usual/app/model/model.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// {@template notification_service}
/// Schedules the user's meal and weight check-in reminders as repeating local
/// OS notifications. Call [init] once at startup, then [sync] whenever the
/// user's settings change to reschedule from scratch.
/// {@endtemplate}
class NotificationService {
  /// {@macro notification_service}
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  VoidCallback? onReminderTapped;

  static const _channelId = 'reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Meal and weight check-in reminders at the times you chose.';

  // Stable notification ids per reminder so a resync replaces, not duplicates.
  static const _endOfDayId = 100;
  static const _weightBaseId = 200;
  static const _workoutBaseId = 300;

  // Weigh-ins that aren't daily can't use a native repeat, so a window of
  // upcoming occurrences is scheduled and topped up on each [sync].
  static const _weightRollingCount = 14;

  /// Initializes timezones and the plugin, and creates the Android channel.
  Future<void> init() async {
    tz_data.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (response) => onReminderTapped?.call(),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.high,
          ),
        );
  }

  /// Asks the OS for permission to show notifications and reports the
  /// resulting [PermissionStatus] so callers can fall back or point the user
  /// to system settings.
  Future<PermissionStatus> requestPermission() {
    return Permission.notification.request();
  }

  /// Opens the OS settings page for the app so the user can enable
  /// notifications after a permanent denial.
  Future<void> openSystemSettings() async {
    await openAppSettings();
  }

  /// Reschedules every reminder from the given settings. Cancels all existing
  /// notifications first, then schedules nothing when the user isn't using
  /// notifications.
  Future<void> sync({
    required ReminderStyle reminderStyle,
    required MealCheckinScheduleMode scheduleMode,
    required Map<MealOfTheDay, MealReminder> mealReminders,
    required MealReminder endOfDayReminder,
    required WeightCheckinFrequency weightCheckinFrequency,
    required WeightTimeOfDay weightTimeOfDay,
    bool skipLoggedMealReminders = false,
    Set<MealOfTheDay> mealsLoggedToday = const {},
    bool weighedInToday = false,
    WorkoutReminder workoutReminder = const WorkoutReminder(
      timeOfDay: TimeOfDay(hour: 18, minute: 0),
    ),
  }) async {
    await _plugin.cancelAll();
    if (reminderStyle != ReminderStyle.notifications) return;

    switch (scheduleMode) {
      case MealCheckinScheduleMode.perMeal:
        for (final MapEntry(key: mealOfTheDay, value: mealReminder)
            in mealReminders.entries) {
          if (!mealReminder.enabled) continue;
          // When the meal is already logged today, start the daily repeat
          // tomorrow so today's reminder is skipped while later days fire as
          // usual.
          final skipToday =
              skipLoggedMealReminders &&
              mealsLoggedToday.contains(mealOfTheDay);
          await _scheduleDaily(
            id: mealOfTheDay.index,
            title: 'Did you eat ${mealOfTheDay.label.toLowerCase()}?',
            body: 'Tap to log it in The Usual.',
            time: mealReminder.timeOfDay,
            skipToday: skipToday,
          );
        }
      case MealCheckinScheduleMode.endOfDay:
        await _scheduleDaily(
          id: _endOfDayId,
          title: 'Log your day',
          body: 'What did you eat today?',
          time: endOfDayReminder.timeOfDay,
        );
    }

    if (weightCheckinFrequency != WeightCheckinFrequency.off) {
      // The same skip-when-already-logged choice that governs meals also holds
      // back today's weigh-in reminder once the user has logged today's weight.
      final skipWeightToday = skipLoggedMealReminders && weighedInToday;
      await _scheduleWeight(
        weightCheckinFrequency,
        weightTimeOfDay,
        skipToday: skipWeightToday,
      );
    }

    if (workoutReminder.enabled) {
      for (final dayOfWeek in workoutReminder.daysOfWeek) {
        await _scheduleWeekly(
          id: _workoutBaseId + dayOfWeek,
          title: 'Did you work out today?',
          body: 'Tap to log it in The Usual.',
          dayOfWeek: dayOfWeek,
          time: workoutReminder.timeOfDay,
        );
      }
    }
  }

  Future<void> _scheduleWeight(
    WeightCheckinFrequency frequency,
    WeightTimeOfDay weightTimeOfDay, {
    bool skipToday = false,
  }) async {
    final time = weightTimeOfDay.scheduledTime;
    const title = 'Time to weigh in';
    const body = "Log today's weight in The Usual.";

    if (frequency == WeightCheckinFrequency.daily) {
      await _scheduleDaily(
        id: _weightBaseId,
        title: title,
        body: body,
        time: time,
        skipToday: skipToday,
      );
      return;
    }

    final intervalDays = frequency == WeightCheckinFrequency.weekly ? 7 : 2;
    final firstReminder = _nextInstanceOf(time, skipToday: skipToday);
    for (var occurrence = 0; occurrence < _weightRollingCount; occurrence++) {
      await _plugin.zonedSchedule(
        id: _weightBaseId + occurrence,
        title: title,
        body: body,
        scheduledDate: firstReminder.add(
          Duration(days: occurrence * intervalDays),
        ),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    bool skipToday = false,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(time, skipToday: skipToday),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required TimeOfDay time,
  }) async {
    var scheduled = _nextInstanceOf(time);
    while (scheduled.weekday != dayOfWeek) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: scheduled,
      title: title,
      body: body,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// The next occurrence of [time] in the device's local timezone, today if it
  /// hasn't passed yet, otherwise tomorrow. When [skipToday] is true, today's
  /// occurrence is always passed over so the first fire lands tomorrow.
  tz.TZDateTime _nextInstanceOf(TimeOfDay time, {bool skipToday = false}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (skipToday || !scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );
}
