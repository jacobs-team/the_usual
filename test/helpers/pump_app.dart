import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpPumpPumpItUP(
    Widget widget, {
    List<Object> deps = const [],
    Locale locale = const Locale('en'),
  }) async {
    initHydratedStorage();
    final getIt = GetIt.instance;
    await getIt.reset();

    final authCubit = MockAuthCubit();
    when(() => authCubit.state).thenReturn(const AuthState());

    getIt
      ..registerSingleton<AuthCubit>(authCubit)
      ..registerSingleton<ConnectivityCubit>(MockConnectivityCubit())
      ..registerSingleton<DevToolsCubit>(MockDevToolsCubit())
      ..registerSingleton<CoffeeBloc>(MockCoffeeBloc())
      ..registerSingleton<CoffeeApi>(MockCoffeeApi())
      ..registerSingleton<RestClient>(MockRestClient())
      ..registerSingleton<FileCacheService>(MockFileCacheService())
      ..registerSingleton<CoffeeRepository>(MockCoffeeRepository());

    for (final instance in [...deps]) {
      await _registerOverride(instance);
    }

    // Lazy so the router binds to whichever AuthCubit the test registered.
    getIt.registerLazySingleton<AppRouter>(
      () => AppRouter(getIt<AuthCubit>()),
    );

    await pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: Layout(child: Scaffold(body: widget)),
      ),
    );

    await pump();
  }

  Future<void> _registerOverride(Object instance) async {
    final getIt = GetIt.instance;

    if (instance is AuthCubit) {
      getIt
        ..unregister<AuthCubit>()
        ..registerSingleton<AuthCubit>(instance);
    } else if (instance is ConnectivityCubit) {
      getIt
        ..unregister<ConnectivityCubit>()
        ..registerSingleton<ConnectivityCubit>(instance);
    } else if (instance is DevToolsCubit) {
      getIt
        ..unregister<DevToolsCubit>()
        ..registerSingleton<DevToolsCubit>(instance);
    } else if (instance is CoffeeBloc) {
      getIt
        ..unregister<CoffeeBloc>()
        ..registerSingleton<CoffeeBloc>(instance);
    } else if (instance is CoffeeApi) {
      getIt
        ..unregister<CoffeeApi>()
        ..registerSingleton<CoffeeApi>(instance);
    } else if (instance is RestClient) {
      getIt
        ..unregister<RestClient>()
        ..registerSingleton<RestClient>(instance);
    } else if (instance is FileCacheService) {
      getIt
        ..unregister<FileCacheService>()
        ..registerSingleton<FileCacheService>(instance);
    } else if (instance is CoffeeRepository) {
      getIt
        ..unregister<CoffeeRepository>()
        ..registerSingleton<CoffeeRepository>(instance);
    }
  }
}
