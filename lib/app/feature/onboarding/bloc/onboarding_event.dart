part of 'onboarding_bloc.dart';

@Freezed()
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.backPressed() = BackPressed;
  const factory OnboardingEvent.resetPressed() = ResetPressed;
  const factory OnboardingEvent.skipPressed() = SkipPressed;
  const factory OnboardingEvent.continuePressed() = ContinuePressed;
  const factory OnboardingEvent.usualAdded(MealOfTheDay meal, String name) =
      UsualAdded;
  const factory OnboardingEvent.usualRemoved(MealOfTheDay meal, String id) =
      UsualRemoved;
  const factory OnboardingEvent.reminderStyleSelected(ReminderStyle style) =
      ReminderStyleSelected;
  const factory OnboardingEvent.mealCheckinScheduleModeChanged(
    MealCheckinScheduleMode mode,
  ) = MealCheckinScheduleModeChanged;
  const factory OnboardingEvent.mealReminderToggled(
    MealOfTheDay meal, {
    required bool enabled,
  }) = MealReminderToggled;
  const factory OnboardingEvent.mealReminderTimeChanged(
    MealOfTheDay meal,
    TimeOfDay time,
  ) = MealReminderTimeChanged;
  const factory OnboardingEvent.endOfDayTimeChanged(TimeOfDay time) =
      EndOfDayTimeChanged;
  const factory OnboardingEvent.weightCheckinFrequencySelected(
    WeightCheckinFrequency frequency,
  ) = WeightCheckinFrequencySelected;
  const factory OnboardingEvent.weightTimeOfDaySelected(
    WeightTimeOfDay timeOfDay,
  ) = WeightTimeOfDaySelected;
  const factory OnboardingEvent.weightUnitSelected(WeightUnit unit) =
      WeightUnitSelected;
  const factory OnboardingEvent.startingWeightChanged(double? weight) =
      StartingWeightChanged;
  const factory OnboardingEvent.firstLogItemToggled(String id) =
      FirstLogItemToggled;
  const factory OnboardingEvent.somethingElseLogged(
    MealOfTheDay meal,
    String name,
  ) = SomethingElseLogged;
}
