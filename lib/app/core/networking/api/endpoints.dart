// coverage:ignore-file

/// Centralized endpoint definitions for all services.
///
/// Use namespaces for service groups:
/// * [Endpoints.coffee] for coffee services.
abstract final class Endpoints {
  /// Endpoints related to coffee services.
  static const coffee = CoffeeRoutes._();
}

/// Namespace for Coffee endpoints.
final class CoffeeRoutes {
  const CoffeeRoutes._();

  /// Path: /random.json
  String get random => '/random.json';
}
