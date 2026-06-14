import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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

  static const _channelId = 'reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Meal and weight check-in reminders at the times you chose.';

  // Stable notification ids per reminder so a resync replaces, not duplicates.
  static const _endOfDayId = 100;
  static const _weightBaseId = 200;

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

  /// Asks the OS for permission to show notifications. A no-op on platforms or
  /// runs where it has already been granted or denied.
  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
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
  }) async {
    await _plugin.cancelAll();
    if (reminderStyle != ReminderStyle.notifications) return;

    switch (scheduleMode) {
      case MealCheckinScheduleMode.perMeal:
        for (final MapEntry(key: mealOfTheDay, value: mealReminder)
            in mealReminders.entries) {
          if (!mealReminder.enabled) continue;
          await _scheduleDaily(
            id: mealOfTheDay.index,
            title: 'Did you eat ${mealOfTheDay.label.toLowerCase()}?',
            body: 'Tap to log it in The Usual.',
            time: mealReminder.timeOfDay,
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
      await _scheduleWeight(weightCheckinFrequency, weightTimeOfDay);
    }
  }

  Future<void> _scheduleWeight(
    WeightCheckinFrequency frequency,
    WeightTimeOfDay weightTimeOfDay,
  ) async {
    final time = weightTimeOfDay.scheduledTime;
    const title = 'Time to weigh in';
    const body = "Log today's weight in The Usual.";

    if (frequency == WeightCheckinFrequency.daily) {
      await _scheduleDaily(
        id: _weightBaseId,
        title: title,
        body: body,
        time: time,
      );
      return;
    }

    final intervalDays = frequency == WeightCheckinFrequency.weekly ? 7 : 2;
    final firstReminder = _nextInstanceOf(time);
    for (var occurrence = 0; occurrence < _weightRollingCount; occurrence++) {
      await _plugin.zonedSchedule(
        id: _weightBaseId + occurrence,
        title: title,
        body: body,
        scheduledDate: firstReminder.add(
          Duration(days: occurrence * intervalDays),
        ),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(time),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// The next occurrence of [time] in the device's local timezone, today if it
  /// hasn't passed yet, otherwise tomorrow.
  tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
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
