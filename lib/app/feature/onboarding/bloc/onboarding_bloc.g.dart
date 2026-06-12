// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) =>
    _OnboardingState(
      step:
          $enumDecodeNullable(_$OnboardingStepEnumMap, json['step']) ??
          OnboardingStep.welcome,
    );

Map<String, dynamic> _$OnboardingStateToJson(_OnboardingState instance) =>
    <String, dynamic>{'step': _$OnboardingStepEnumMap[instance.step]!};

const _$OnboardingStepEnumMap = {
  OnboardingStep.welcome: 'welcome',
  OnboardingStep.buildUsuals: 'buildUsuals',
  OnboardingStep.reminderStyle: 'reminderStyle',
  OnboardingStep.mealSchedule: 'mealSchedule',
  OnboardingStep.weightTracking: 'weightTracking',
  OnboardingStep.firstLog: 'firstLog',
  OnboardingStep.complete: 'complete',
};
