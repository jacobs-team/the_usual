// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) =>
    _OnboardingState(
      activeStepIndex: (json['activeStepIndex'] as num?)?.toInt() ?? 0,
      usuals:
          (json['usuals'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$MealOfTheDayEnumMap, k),
              (e as List<dynamic>)
                  .map((e) => UsualMeal.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          const <MealOfTheDay, List<UsualMeal>>{},
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
    );

Map<String, dynamic> _$OnboardingStateToJson(
  _OnboardingState instance,
) => <String, dynamic>{
  'activeStepIndex': instance.activeStepIndex,
  'usuals': instance.usuals.map(
    (k, e) =>
        MapEntry(_$MealOfTheDayEnumMap[k]!, e.map((e) => e.toJson()).toList()),
  ),
  'settings': instance.settings.toJson(),
  'firstLogSelectedIds': instance.firstLogSelectedIds,
};

const _$MealOfTheDayEnumMap = {
  MealOfTheDay.breakfast: 'breakfast',
  MealOfTheDay.lunch: 'lunch',
  MealOfTheDay.dinner: 'dinner',
  MealOfTheDay.snacks: 'snacks',
};
