// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hydrated_bloc/hydrated_bloc.dart' as _i67;
import 'package:injectable/injectable.dart' as _i526;
import 'package:the_usual/app/core/core.dart' as _i540;
import 'package:the_usual/app/core/cubit/auth_cubit.dart' as _i335;
import 'package:the_usual/app/core/cubit/connectivity_cubit.dart' as _i473;
import 'package:the_usual/app/core/dependencies/modules/hydrated_bloc_module.dart'
    as _i316;
import 'package:the_usual/app/core/networking/api/coffee_api.dart' as _i6;
import 'package:the_usual/app/core/networking/api/rest_client.dart' as _i13;
import 'package:the_usual/app/core/networking/repository/coffee_repository.dart'
    as _i83;
import 'package:the_usual/app/core/service/file_cache_service.dart' as _i115;
import 'package:the_usual/app/feature/coffee/bloc/coffee_bloc.dart' as _i1016;
import 'package:the_usual/app/feature/dev_tools/cubit/dev_tools_cubit.dart'
    as _i818;
import 'package:the_usual/app/feature/feature.dart' as _i476;
import 'package:the_usual/app/navigation/app_router.dart' as _i874;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final hydratedBlocModule = _$HydratedBlocModule();
    await gh.factoryAsync<_i67.HydratedStorage>(
      () => hydratedBlocModule.init(),
      preResolve: true,
    );
    gh.singleton<_i335.AuthCubit>(() => _i335.AuthCubit());
    gh.singleton<_i473.ConnectivityCubit>(() => _i473.ConnectivityCubit());
    gh.singleton<_i115.FileCacheService>(() => _i115.FileCacheService());
    gh.singleton<_i818.DevToolsCubit>(() => _i818.DevToolsCubit());
    gh.singleton<_i13.RestClient>(
      () => _i13.RestClient(gh<_i540.AuthCubit>(), gh<_i476.DevToolsCubit>()),
    );
    gh.singleton<_i874.AppRouter>(() => _i874.AppRouter(gh<_i335.AuthCubit>()));
    gh.singleton<_i6.CoffeeApi>(() => _i6.CoffeeApi(gh<_i540.RestClient>()));
    gh.singleton<_i83.CoffeeRepository>(
      () => _i83.CoffeeRepository(gh<_i540.CoffeeApi>()),
    );
    gh.singleton<_i1016.CoffeeBloc>(
      () => _i1016.CoffeeBloc(
        gh<_i83.CoffeeRepository>(),
        gh<_i115.FileCacheService>(),
      ),
    );
    return this;
  }
}

class _$HydratedBlocModule extends _i316.HydratedBlocModule {}
