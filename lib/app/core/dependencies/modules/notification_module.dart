// coverage:ignore-file

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/core/dependencies/injectable_environments.dart';
import 'package:the_usual/app/core/service/service.dart';

/// {@template notification_module}
/// An [injectable] module that builds and initializes the
/// [NotificationService] before the container finishes setup, so timezones and
/// the plugin are ready before the first schedule.
/// {@endtemplate}
@module
abstract class NotificationModule {
  /// Creates and initializes the [NotificationService]. Scheduled local OS
  /// notifications are mobile-only, so it isn't registered on web.
  @preResolve
  @mobile
  Future<NotificationService> notificationService() async {
    final notificationService = NotificationService(
      FlutterLocalNotificationsPlugin(),
    );
    await notificationService.init();
    return notificationService;
  }
}
