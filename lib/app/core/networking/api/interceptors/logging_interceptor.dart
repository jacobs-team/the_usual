// coverage:ignore-file

part of '../rest_client.dart';

/// {@template logging_interceptor}
/// A Dio [Interceptor] that conditionally logs network traffic
/// if [DevToolsCubit] `isApiDebug` is true.
/// {@endtemplate}
class LoggingInterceptor extends Interceptor {
  /// {@macro logging_interceptor}
  LoggingInterceptor(this._devToolsCubit, this._logger);

  final DevToolsCubit _devToolsCubit;
  final PrettyDioLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_devToolsCubit.state.isApiDebug) {
      _logger.onRequest(options, handler);
    } else {
      super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_devToolsCubit.state.isApiDebug) {
      _logger.onResponse(response, handler);
    } else {
      super.onResponse(response, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_devToolsCubit.state.isApiDebug) {
      _logger.onError(err, handler);
    } else {
      super.onError(err, handler);
    }
  }
}
