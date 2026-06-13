/// Whether reminders fire per meal or once at the end of the day.
enum MealCheckinScheduleMode {
  perMeal('After each meal'),
  endOfDay('Once a day');

  const MealCheckinScheduleMode(this.label);

  /// Display label for the mode.
  final String label;
}
