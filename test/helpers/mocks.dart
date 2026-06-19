import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:the_usual/app/app.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

class MockDailyLogBloc extends MockBloc<DailyLogEvent, DailyLogState>
    implements DailyLogBloc {}

class MockUserSettingsBloc
    extends MockBloc<UserSettingsEvent, UserSettingsState>
    implements UserSettingsBloc {}

class MockNotificationService extends Mock implements NotificationService {}

class MockShareIngestService extends Mock implements ShareIngestService {}

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockConnectivityCubit extends MockCubit<bool>
    implements ConnectivityCubit {}

class MockDevToolsCubit extends MockCubit<DevToolsState>
    implements DevToolsCubit {}

class MockCoffeeApi extends Mock implements CoffeeApi {}

class MockRestClient extends Mock implements RestClient {}

class MockFileCacheService extends Mock implements FileCacheService {}

class MockMealAiRepository extends Mock implements MealAiRepository {}

class MockMealAiClient extends Mock implements MealAiClient {}

class MockDio extends Mock implements Dio {}

class MockPrettyDioLogger extends Mock implements PrettyDioLogger {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock
    implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockFile extends Mock implements File {}

final transparentPixel = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
