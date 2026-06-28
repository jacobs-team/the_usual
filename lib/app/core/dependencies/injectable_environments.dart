import 'package:injectable/injectable.dart';

/// Environment for dependencies that only exist on mobile platforms (iOS and
/// Android) and have no web counterpart, such as the native home-screen widget,
/// the OS share target, and scheduled local notifications. Active only when the
/// app is not running on the web.
const mobile = Environment('mobile');

/// Environment for dependencies that only exist on the web. Active only when
/// the app is running on the web.
const web = Environment('web');
