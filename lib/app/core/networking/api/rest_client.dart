import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_template/environment.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'interceptors/logging_interceptor.dart';

/// {@template api_client}
/// A REST client for app services built on [Dio].
/// * **Logging:** Optional request/response logging via [PrettyDioLogger]
/// and [DevToolsCubit].
/// {@endtemplate}
@singleton
class RestClient {
  /// {@macro api_client}
  RestClient(this._authCubit, this._devToolsCubit, [@ignoreParam Dio? dio])
    : _dio =
          dio ??
          Dio(
            BaseOptions(baseUrl: EnvironmentConfig.apiDomain),
          ) {
    _dio.interceptors.addAll([
      if (kDebugMode)
        LoggingInterceptor(
          _devToolsCubit,
          PrettyDioLogger(
            requestBody: true,
            maxWidth: 100,
          ),
        ),
    ]);
  }

  final Dio _dio;

  final AuthCubit _authCubit;

  final DevToolsCubit _devToolsCubit;

  /// Closes the underlying Dio client.
  void close() => _dio.close();

  /// Sends a [Dio] request with the given [path] and [HttpMethod]
  Future<Response<T>> request<T>(
    String path,
    HttpMethod method, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresAuth = true,
    ResponseType? responseType,
  }) => _dio.request<T>(
    path,
    data: body,
    options: Options(
      method: method.name,
      headers: headers,
      responseType: responseType,
    ),
    queryParameters: queryParameters,
    cancelToken: cancelToken ?? _authCubit.cancelToken,
  );
}

// ignore: public_member_api_docs, no redundant docs
enum HttpMethod { get, post, put, patch, delete }
