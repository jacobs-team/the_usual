// coverage:ignore-file

import 'package:flutter_template/app/core/dependencies/dependencies.config.dart';
import 'package:flutter_template/environment.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

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
Future<void> configureDependencies(String env) {
  EnvironmentConfig.environment = env;
  return getIt.init(environment: env);
}
