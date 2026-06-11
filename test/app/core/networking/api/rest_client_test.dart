import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const path = 'path';

  group(RestClient, () {
    late Dio dio;
    late AuthCubit authCubit;
    late DevToolsCubit devToolsCubit;
    late RestClient restClient;
    late CancelToken cancelToken;

    setUp(() {
      initHydratedStorage();
      dio = MockDio();
      authCubit = MockAuthCubit();
      devToolsCubit = MockDevToolsCubit();
      cancelToken = CancelToken();

      when(() => authCubit.cancelToken).thenReturn(cancelToken);
      when(() => dio.interceptors).thenReturn(Interceptors());

      when(
        () => dio.request<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => Response(requestOptions: RequestOptions()));

      restClient = RestClient(authCubit, devToolsCubit, dio);
    });

    for (final method in HttpMethod.values) {
      test('request calls dio.request with $method', () async {
        await restClient.request<dynamic>(path, method);

        final captured = verify(
          () => dio.request<dynamic>(
            path,
            data: any(named: 'data'),
            options: captureAny(named: 'options'),
            queryParameters: any(named: 'queryParameters'),
            cancelToken: cancelToken,
          ),
        ).captured;

        final options = captured.first as Options;
        expect(options.method, equals(method.name));
      });
    }

    test('passes body to dio.request', () async {
      const body = {'key': 'value'};
      await restClient.request<dynamic>(path, HttpMethod.post, body: body);

      verify(
        () => dio.request<dynamic>(
          path,
          data: body,
          options: any(named: 'options'),
          queryParameters: any(named: 'queryParameters'),
          cancelToken: cancelToken,
        ),
      ).called(1);
    });

    test('creates its own $Dio when not passed in', () {
      final client = RestClient(authCubit, devToolsCubit);
      expect(client, isA<RestClient>());
    });

    test('close calls dio.close', () {
      when(() => dio.close()).thenAnswer((_) => {});
      restClient.close();
      verify(() => dio.close()).called(1);
    });
  });
}
