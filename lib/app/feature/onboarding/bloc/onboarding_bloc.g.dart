// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) =>
    _OnboardingState(
      version: (json['version'] as num?)?.toInt() ?? 1,
      activeStepIndex: (json['activeStepIndex'] as num?)?.toInt() ?? 0,
      settings: json['settings'] == null
          ? const UserSettingsState()
          : UserSettingsState.fromJson(
              json['settings'] as Map<String, dynamic>,
            ),
      firstLogSelectedIds:
          (json['firstLogSelectedIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      firstLogQuantities:
          (json['firstLogQuantities'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
    );

Map<String, dynamic> _$OnboardingStateToJson(_OnboardingState instance) =>
    <String, dynamic>{
      'version': instance.version,
      'activeStepIndex': instance.activeStepIndex,
      'settings': instance.settings.toJson(),
      'firstLogSelectedIds': instance.firstLogSelectedIds,
      'firstLogQuantities': instance.firstLogQuantities,
    };
