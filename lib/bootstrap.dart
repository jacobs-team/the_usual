import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Signature for reporting uncaught errors, e.g. to a crash-reporting service.
typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

/// Global [BlocObserver] used to log bloc state changes and errors.
class AppBlocObserver extends BlocObserver {
  /// Creates an [AppBlocObserver].
  const AppBlocObserver([this._onError]);

  final ErrorReporter? _onError;

  // Uncomment this if you want all bloc state changes to be logged.
  // @override
  // void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
  //   super.onChange(bloc, change);
  //   log('onChange(${bloc.runtimeType}, $change)');
  // }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    _onError?.call(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

/// App startup entrypoint and configuration, any config for all environments
/// can go here. Any environment specific config can go inside the the
/// environment entrypoint builder methods.
// TODO(jb): optimize error handler.
Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  ErrorReporter? onError,
}) async {
  if (onError != null) {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      onError(details.exception, details.stack ?? StackTrace.current);
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      onError(error, stackTrace);
      // Let the engine apply its default handling and logging.
      return false;
    };
  }
  Bloc.observer = AppBlocObserver(onError);

  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(await builder());
}
