import 'package:flutter/material.dart';

/// The four meal groups a usual item can belong to.
enum MealOfTheDay {
  breakfast('Breakfast'),
  lunch('Lunch'),
  dinner('Dinner'),
  snacks('Snacks');

  const MealOfTheDay(this.label);

  /// The last meal the user likely ate by [time], based on typical meal
  /// times: breakfast 9am, lunch 2pm, dinner 7pm. A meal isn't asked about
  /// before its typical time has passed.
  factory MealOfTheDay.fromTime(TimeOfDay time) {
    return switch (time.hour) {
      >= 19 => MealOfTheDay.dinner,
      >= 14 => MealOfTheDay.lunch,
      _ => MealOfTheDay.breakfast,
    };
  }

  /// Display label for the meal.
  final String label;
}
