import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'dev_tools_cubit.freezed.dart';
part 'dev_tools_cubit.g.dart';

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
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,
    @Default(true) bool isApiDebug,
  }) = _DevToolsState;

  const DevToolsState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  factory DevToolsState.fromJson(Map<String, dynamic> json) =>
      DevToolsState._fromVersionedJson(json);

  factory DevToolsState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up to the current one before this case.
      case 0:
      case _currentVersion:
        return _$DevToolsStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the stored config: unknown keys are ignored and missing
        // ones fall back to defaults.
        return _$DevToolsStateFromJson(json);
    }
  }
}
