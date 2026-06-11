/// {@template app_exception}
/// Base class for custom exceptions.
/// {@endtemplate}
abstract base class AppException implements Exception {
  /// {@macro app_exception}
  const AppException({
    required this.message,
    this.statusCode,
    this.error,
    this.stackTrace,
  });

  /// Human-readable description of the failure.
  final String message;

  /// HTTP status code returned by the server.
  final int? statusCode;

  /// The underlying error that caused this exception, if any.
  final Object? error;

  /// The stack trace associated with this exception, if any.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final code = statusCode != null ? '($statusCode)' : '';
    final cause = error != null ? '\nCaused by: $error' : '';
    return '$runtimeType$code: $message$cause';
  }
}
