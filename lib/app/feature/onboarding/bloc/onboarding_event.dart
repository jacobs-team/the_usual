part of 'onboarding_bloc.dart';

@Freezed()
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.backPressed() = BackPressed;
  const factory OnboardingEvent.resetPressed() = ResetPressed;
  const factory OnboardingEvent.skipPressed() = SkipPressed;
  const factory OnboardingEvent.continuePressed() = ContinuePressed;
  const factory OnboardingEvent.usualMealAdded(
    MealOfTheDay mealOfTheDay,
    String name,
    Nutrition nutrition,
  ) = UsualMealAdded;
  const factory OnboardingEvent.usualMealRemoved(
    MealOfTheDay mealOfTheDay,
    String id,
  ) = UsualMealRemoved;
  const factory OnboardingEvent.usualMealNutritionChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    Nutrition nutrition,
  ) = UsualMealNutritionChanged;
  const factory OnboardingEvent.usualMealNameChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    String name,
  ) = UsualMealNameChanged;
  const factory OnboardingEvent.reminderStyleSelected(
    ReminderStyle reminderStyle,
  ) = ReminderStyleSelected;
  const factory OnboardingEvent.mealCheckinScheduleModeChanged(
    MealCheckinScheduleMode mealCheckinScheduleMode,
  ) = MealCheckinScheduleModeChanged;
  const factory OnboardingEvent.mealReminderToggled(
    MealOfTheDay mealOfTheDay, {
    required bool enabled,
  }) = MealReminderToggled;
  const factory OnboardingEvent.mealReminderTimeChanged(
    MealOfTheDay mealOfTheDay,
    TimeOfDay timeOfDay,
  ) = MealReminderTimeChanged;
  const factory OnboardingEvent.endOfDayTimeChanged(TimeOfDay timeOfDay) =
      EndOfDayTimeChanged;
  const factory OnboardingEvent.weightCheckinFrequencySelected(
    WeightCheckinFrequency weightCheckinFrequency,
  ) = WeightCheckinFrequencySelected;
  const factory OnboardingEvent.weightTimeOfDaySelected(
    WeightTimeOfDay weightTimeOfDay,
  ) = WeightTimeOfDaySelected;
  const factory OnboardingEvent.weightUnitSelected(WeightUnit weightUnit) =
      WeightUnitSelected;
  const factory OnboardingEvent.startingWeightChanged(double? weight) =
      StartingWeightChanged;
  const factory OnboardingEvent.calorieGoalChanged(int? calorieGoal) =
      CalorieGoalChanged;
  const factory OnboardingEvent.weightGoalChanged(double? weightGoal) =
      WeightGoalChanged;
  const factory OnboardingEvent.firstLogItemToggled(String id) =
      FirstLogItemToggled;
  const factory OnboardingEvent.firstLogItemQuantityChanged(
    String id,
    int quantity,
  ) = FirstLogItemQuantityChanged;
  const factory OnboardingEvent.somethingElseLogged(
    MealOfTheDay mealOfTheDay,
    String name, {
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) int quantity,
  }) = SomethingElseLogged;
}
