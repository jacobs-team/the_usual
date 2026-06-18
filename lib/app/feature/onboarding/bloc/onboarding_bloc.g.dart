// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) =>
    _OnboardingState(
      version: (json['version'] as num?)?.toInt() ?? 2,
      step:
          $enumDecodeNullable(_$OnboardingStepEnumMap, json['step']) ??
          OnboardingStep.welcome,
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
      'step': _$OnboardingStepEnumMap[instance.step]!,
      'settings': instance.settings.toJson(),
      'firstLogSelectedIds': instance.firstLogSelectedIds,
      'firstLogQuantities': instance.firstLogQuantities,
    };

const _$OnboardingStepEnumMap = {
  OnboardingStep.welcome: 'welcome',
  OnboardingStep.buildUsuals: 'buildUsuals',
  OnboardingStep.firstLog: 'firstLog',
  OnboardingStep.reminders: 'reminders',
  OnboardingStep.weightTracking: 'weightTracking',
  OnboardingStep.goals: 'goals',
  OnboardingStep.complete: 'complete',
};
