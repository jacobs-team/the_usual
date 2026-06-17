import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:the_usual/app/app.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/helpers.dart';

class _MockPermissionHandlerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/New_York'));
    registerFallbackValue(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    registerFallbackValue(
      const NotificationDetails(
        android: AndroidNotificationDetails('id', 'name'),
      ),
    );
    registerFallbackValue(tz.TZDateTime.now(tz.local));
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
    registerFallbackValue(DateTimeComponents.time);
    registerFallbackValue(
      const AndroidNotificationChannel('id', 'name'),
    );
    registerFallbackValue(Permission.notification);
  });

  late MockFlutterLocalNotificationsPlugin plugin;
  late MockAndroidFlutterLocalNotificationsPlugin androidPlugin;
  late NotificationService notificationService;

  setUp(() {
    plugin = MockFlutterLocalNotificationsPlugin();
    androidPlugin = MockAndroidFlutterLocalNotificationsPlugin();
    notificationService = NotificationService(plugin);

    when(
      () => plugin.initialize(
        settings: any(named: 'settings'),
        onDidReceiveNotificationResponse: any(
          named: 'onDidReceiveNotificationResponse',
        ),
        onDidReceiveBackgroundNotificationResponse: any(
          named: 'onDidReceiveBackgroundNotificationResponse',
        ),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >(),
    ).thenReturn(androidPlugin);
    when(
      () => androidPlugin.createNotificationChannel(any()),
    ).thenAnswer((_) async {});
    when(() => plugin.cancelAll()).thenAnswer((_) async {});
    when(
      () => plugin.zonedSchedule(
        id: any(named: 'id'),
        scheduledDate: any(named: 'scheduledDate'),
        notificationDetails: any(named: 'notificationDetails'),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
      ),
    ).thenAnswer((_) async {});
  });

  group(NotificationService, () {
    group('init', () {
      const channel = MethodChannel('flutter_timezone');

      setUp(() {
        TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              channel,
              (call) async => 'America/New_York',
            );
      });

      tearDown(() {
        TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      });

      test('initializes the plugin and creates the Android channel', () async {
        await notificationService.init();

        verify(
          () => plugin.initialize(
            settings: any(named: 'settings'),
            onDidReceiveNotificationResponse: any(
              named: 'onDidReceiveNotificationResponse',
            ),
          ),
        ).called(1);
        verify(() => androidPlugin.createNotificationChannel(any())).called(1);
      });

      test('forwards a notification tap to onReminderTapped', () async {
        var tapped = false;
        notificationService.onReminderTapped = () => tapped = true;

        await notificationService.init();

        final onResponse =
            verify(
                  () => plugin.initialize(
                    settings: any(named: 'settings'),
                    onDidReceiveNotificationResponse: captureAny(
                      named: 'onDidReceiveNotificationResponse',
                    ),
                  ),
                ).captured.single
                as DidReceiveNotificationResponseCallback;

        onResponse(
          const NotificationResponse(
            notificationResponseType:
                NotificationResponseType.selectedNotification,
          ),
        );

        expect(tapped, isTrue);
      });
    });

    group('permissions', () {
      late _MockPermissionHandlerPlatform permissionHandler;

      setUp(() {
        permissionHandler = _MockPermissionHandlerPlatform();
        PermissionHandlerPlatform.instance = permissionHandler;
      });

      test('requestPermission returns the resolved status', () async {
        when(
          () => permissionHandler.requestPermissions(any()),
        ).thenAnswer(
          (_) async => {Permission.notification: PermissionStatus.granted},
        );

        final status = await notificationService.requestPermission();

        expect(status, equals(PermissionStatus.granted));
      });

      test('openSystemSettings opens the app settings page', () async {
        when(
          () => permissionHandler.openAppSettings(),
        ).thenAnswer((_) async => true);

        await notificationService.openSystemSettings();

        verify(() => permissionHandler.openAppSettings()).called(1);
      });
    });

    group('sync', () {
      MealReminder reminder({required bool enabled, int hour = 9}) {
        return MealReminder(
          enabled: enabled,
          timeOfDay: TimeOfDay(hour: hour, minute: 0),
        );
      }

      test(
        'cancels everything and schedules nothing when not notifying',
        () async {
          await notificationService.sync(
            reminderStyle: ReminderStyle.none,
            scheduleMode: MealCheckinScheduleMode.perMeal,
            mealReminders: const {},
            endOfDayReminder: reminder(enabled: true),
            weightCheckinFrequency: WeightCheckinFrequency.off,
            weightTimeOfDay: WeightTimeOfDay.morning,
          );

          verify(() => plugin.cancelAll()).called(1);
          verifyNever(
            () => plugin.zonedSchedule(
              id: any(named: 'id'),
              scheduledDate: any(named: 'scheduledDate'),
              notificationDetails: any(named: 'notificationDetails'),
              androidScheduleMode: any(named: 'androidScheduleMode'),
            ),
          );
        },
      );

      test('rolls a passed reminder time to the next day', () async {
        // Midnight has always passed by the time "now" is read, forcing the
        // next-instance calculation onto tomorrow.
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.perMeal,
          mealReminders: {
            MealOfTheDay.breakfast: reminder(enabled: true, hour: 0),
          },
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.off,
          weightTimeOfDay: WeightTimeOfDay.morning,
        );

        verify(
          () => plugin.zonedSchedule(
            id: MealOfTheDay.breakfast.index,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('per-meal mode schedules only enabled meals', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.perMeal,
          mealReminders: {
            MealOfTheDay.breakfast: reminder(enabled: true),
            MealOfTheDay.lunch: reminder(enabled: false, hour: 14),
          },
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.off,
          weightTimeOfDay: WeightTimeOfDay.morning,
        );

        verify(
          () => plugin.zonedSchedule(
            id: MealOfTheDay.breakfast.index,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('end-of-day mode schedules the single daily reminder', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.endOfDay,
          mealReminders: const {},
          endOfDayReminder: reminder(enabled: true, hour: 20),
          weightCheckinFrequency: WeightCheckinFrequency.off,
          weightTimeOfDay: WeightTimeOfDay.morning,
        );

        verify(
          () => plugin.zonedSchedule(
            id: 100,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('daily weigh-in uses a single repeating reminder', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.endOfDay,
          mealReminders: const {},
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.daily,
          weightTimeOfDay: WeightTimeOfDay.morning,
        );

        verify(
          () => plugin.zonedSchedule(
            id: 200,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test(
        'weekly weigh-in schedules a rolling window of occurrences',
        () async {
          await notificationService.sync(
            reminderStyle: ReminderStyle.notifications,
            scheduleMode: MealCheckinScheduleMode.endOfDay,
            mealReminders: const {},
            endOfDayReminder: reminder(enabled: true),
            weightCheckinFrequency: WeightCheckinFrequency.weekly,
            weightTimeOfDay: WeightTimeOfDay.evening,
          );

          // 1 end-of-day + 14 rolling weight occurrences.
          verify(
            () => plugin.zonedSchedule(
              id: any(named: 'id'),
              scheduledDate: any(named: 'scheduledDate'),
              notificationDetails: any(named: 'notificationDetails'),
              androidScheduleMode: any(named: 'androidScheduleMode'),
              title: any(named: 'title'),
              body: any(named: 'body'),
              matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
            ),
          ).called(15);
        },
      );

      test('skips today for a meal already logged today', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.perMeal,
          mealReminders: {
            MealOfTheDay.breakfast: reminder(enabled: true),
          },
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.off,
          weightTimeOfDay: WeightTimeOfDay.morning,
          skipLoggedMealReminders: true,
          mealsLoggedToday: const {MealOfTheDay.breakfast},
        );

        verify(
          () => plugin.zonedSchedule(
            id: MealOfTheDay.breakfast.index,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('skips today for the weigh-in once weighed in today', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.endOfDay,
          mealReminders: const {},
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.daily,
          weightTimeOfDay: WeightTimeOfDay.morning,
          skipLoggedMealReminders: true,
          weighedInToday: true,
        );

        verify(
          () => plugin.zonedSchedule(
            id: 200,
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(1);
      });

      test('every-two-days weigh-in also schedules a rolling window', () async {
        await notificationService.sync(
          reminderStyle: ReminderStyle.notifications,
          scheduleMode: MealCheckinScheduleMode.endOfDay,
          mealReminders: const {},
          endOfDayReminder: reminder(enabled: true),
          weightCheckinFrequency: WeightCheckinFrequency.everyTwoDays,
          weightTimeOfDay: WeightTimeOfDay.night,
        );

        verify(
          () => plugin.zonedSchedule(
            id: any(named: 'id'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).called(15);
      });
    });
  });
}
