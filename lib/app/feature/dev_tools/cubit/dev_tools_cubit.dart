// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'dev_tools_cubit.g.dart';
part 'dev_tools_cubit.freezed.dart';

/// {@template dev_tools_cubit}
/// A [HydratedCubit] that manages persistent developer settings
/// and app configurations.
/// {@endtemplate}
@singleton
class DevToolsCubit extends HydratedCubit<DevToolsState> {
  /// {@macro dev_tools_cubit}
  DevToolsCubit() : super(const DevToolsState());

  /// Toggles the API debugging flag.
  void toggleDebugApi() => emit(state.copyWith(isApiDebug: !state.isApiDebug));

  /// Toggles the application's dark mode setting. Does nothing in prod.
  void toggleDarkMode() => emit(state.copyWith(isDarkMode: !state.isDarkMode));

  @override
  DevToolsState fromJson(Map<String, dynamic> json) =>
      DevToolsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(DevToolsState state) => state.toJson();
}

/// {@template dev_tools_state}
/// Represents the current configuration of dev tools.
/// {@endtemplate}
@freezed
abstract class DevToolsState with _$DevToolsState {
  /// {@macro dev_tools_state}
  const factory DevToolsState({
    @Default(true) bool isApiDebug,
    @Default(false) bool isDarkMode,
  }) = _DevToolsState;

  const DevToolsState._();

  factory DevToolsState.fromJson(Map<String, dynamic> json) =>
      _$DevToolsStateFromJson(json);
}
