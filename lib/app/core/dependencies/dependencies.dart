// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/core/dependencies/dependencies.config.dart';
import 'package:the_usual/app/core/dependencies/injectable_environments.dart';

/// The global instance of [GetIt] used for dependency injection.
final GetIt getIt = GetIt.instance;

/// {@template dependencies}
/// Initializes the application's dependency injection container.
///
/// This function uses the [injectable] package to generate and register
/// all dependencies marked with annotations like `@singleton` or `@injectable`.
///
/// See also:
/// * [configureDependencies]'s generated implementation
/// in `dependencies.config.dart`.
/// {@endtemplate}
@InjectableInit()
Future<void> configureDependencies() {
  // The running platform is the active environment, so unscoped dependencies
  // register everywhere while platform-scoped ones register only on their
  // platform. This skips `@mobile` plugins (home-screen widget, OS share
  // target, local notifications) on web, where they don't exist.
  return getIt.init(environment: kIsWeb ? web.name : mobile.name);
}
