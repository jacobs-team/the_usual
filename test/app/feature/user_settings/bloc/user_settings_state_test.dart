import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UserSettingsState, () {
    test('dayStartTime defaults to midnight', () {
      expect(
        const UserSettingsState().dayStartTime,
        equals(const TimeOfDay(hour: 0, minute: 0)),
      );
    });

    group('fromJson', () {
      UserSettingsState withCalorieGoal(int calories) => UserSettingsState(
        calorieGoalHistory: [
          CalorieGoalEntry(
            effectiveFrom: DateTime.fromMillisecondsSinceEpoch(0),
            calories: calories,
          ),
        ],
      );

      test('reads current-version data straight through', () {
        final restored = UserSettingsState.fromJson(
          withCalorieGoal(2000).toJson(),
        );

        expect(restored.calorieGoal, equals(2000));
      });

      test('reads a newer unknown version as a best effort', () {
        final json = withCalorieGoal(1800).toJson()..['version'] = 99;

        final restored = UserSettingsState.fromJson(json);

        expect(restored.calorieGoal, equals(1800));
      });

      test('maps the removed onAppOpen reminder style to none', () {
        final json = const UserSettingsState().toJson()
          ..['reminderStyle'] = 'onAppOpen';

        final restored = UserSettingsState.fromJson(json);

        expect(restored.reminderStyle, equals(ReminderStyle.none));
      });

      test('migrates v2 scalar calorie and weight goals into histories', () {
        final restored = UserSettingsState.fromJson(<String, dynamic>{
          'version': 2,
          'calorieGoal': 2100,
          'weightGoal': 72.5,
          'weightUnit': 'kg',
        });

        expect(restored.calorieGoal, equals(2100));
        expect(restored.calorieGoalHistory, hasLength(1));
        expect(restored.weightGoal, equals(72.5));
        expect(restored.weightGoalHistory, hasLength(1));
        expect(
          restored.weightGoalHistory.single.weightUnit,
          equals(WeightUnit.kg),
        );
      });

      test('round-trips a populated usualWorkouts map', () {
        const state = UserSettingsState(
          usualWorkouts: {
            'push': [
              UsualWorkout(
                id: 'usual-1',
                name: 'Bench Press',
                sets: [WorkoutSet(weight: 135, reps: 8)],
              ),
            ],
          },
        );

        final restored = UserSettingsState.fromJson(state.toJson());

        expect(restored.usualWorkouts['push'], hasLength(1));
        expect(
          restored.usualWorkouts['push']!.single.name,
          equals('Bench Press'),
        );
      });
    });

    group('usualMealCount', () {
      test('is zero when there are no usuals', () {
        expect(const UserSettingsState().usualMealCount, equals(0));
      });

      test('sums usuals across all meal timings', () {
        const state = UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(id: 'a', name: 'Eggs'),
              UsualMeal(id: 'b', name: 'Oats'),
            ],
            MealOfTheDay.dinner: [UsualMeal(id: 'c', name: 'Tacos')],
          },
        );

        expect(state.usualMealCount, equals(3));
      });
    });

    group('hasEstablishedUsuals', () {
      test('is false with no usuals', () {
        expect(const UserSettingsState().hasEstablishedUsuals, isFalse);
      });

      test('is false with a single usual across all timings', () {
        const state = UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
          },
        );

        expect(state.hasEstablishedUsuals, isFalse);
      });

      test('is true with more than one usual across all timings', () {
        const state = UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'a', name: 'Eggs')],
            MealOfTheDay.lunch: [UsualMeal(id: 'b', name: 'Salad')],
          },
        );

        expect(state.hasEstablishedUsuals, isTrue);
      });
    });

    group('currentMeal', () {
      test('falls back to the meal time when there are no boundaries', () {
        const state = UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        );
        final lunchTime = DateTime(2026, 6, 17, 13);

        expect(
          state.currentMeal(lunchTime),
          equals(MealOfTheDay.fromTime(TimeOfDay.fromDateTime(lunchTime))),
        );
      });

      test('rests on the first meal before any reminder has fired', () {
        const state = UserSettingsState();
        final earlyMorning = DateTime(2026, 6, 17, 6);

        expect(
          state.currentMeal(earlyMorning),
          equals(MealOfTheDay.breakfast),
        );
      });

      test('moves to the latest meal whose reminder has passed', () {
        const state = UserSettingsState();
        final afternoon = DateTime(2026, 6, 17, 15);

        expect(state.currentMeal(afternoon), equals(MealOfTheDay.lunch));
      });
    });

    group('nextMealBoundary', () {
      test('returns the top of the next hour with no boundaries', () {
        const state = UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        );
        final now = DateTime(2026, 6, 17, 13, 20);

        expect(
          state.nextMealBoundary(now),
          equals(DateTime(2026, 6, 17, 14)),
        );
      });

      test('returns the next later reminder still ahead', () {
        const state = UserSettingsState();
        final morning = DateTime(2026, 6, 17, 10);

        expect(
          state.nextMealBoundary(morning),
          equals(DateTime(2026, 6, 17, 14)),
        );
      });

      test('returns the next midnight once every later reminder passed', () {
        const state = UserSettingsState();
        final lateEvening = DateTime(2026, 6, 17, 23);

        expect(
          state.nextMealBoundary(lateEvening),
          equals(DateTime(2026, 6, 18)),
        );
      });
    });

    group('workout defaults', () {
      test('seeds Push, Pull, Legs as the default workout groups', () {
        const state = UserSettingsState();

        expect(
          state.workoutGroups.map((workoutGroup) => workoutGroup.id).toList(),
          equals(['push', 'pull', 'legs']),
        );
        expect(
          state.workoutGroups.map((workoutGroup) => workoutGroup.name).toList(),
          equals(['Push', 'Pull', 'Legs']),
        );
      });

      test('usualWorkouts and the workout reminder start empty/disabled', () {
        const state = UserSettingsState();

        expect(state.usualWorkouts, isEmpty);
        expect(state.workoutReminder.enabled, isFalse);
      });
    });

    group('usualFoodCount', () {
      test('usualFoodCount counts the library', () {
        const state = UserSettingsState(
          usualFoods: [
            UsualFood(id: 'a', name: 'Chicken'),
            UsualFood(id: 'b', name: 'Rice'),
          ],
        );
        expect(state.usualFoodCount, equals(2));
      });
    });

    group('usualMealsUsingFood', () {
      test('counts meals with a matching component link', () {
        const state = UserSettingsState(
          usuals: {
            MealOfTheDay.lunch: [
              UsualMeal(id: 'm1', name: 'Bowl', components: [
                MealComponent(
                  name: 'Chicken, 1 oz',
                  usualFoodId: 'f1',
                  quantity: 4,
                ),
                MealComponent(name: 'Rice, 100 g', usualFoodId: 'f2'),
              ]),
            ],
            MealOfTheDay.dinner: [
              UsualMeal(id: 'm2', name: 'Plate', components: [
                MealComponent(
                  name: 'Chicken, 1 oz',
                  usualFoodId: 'f1',
                  quantity: 2,
                ),
              ]),
              UsualMeal(id: 'm3', name: 'Salad'),
            ],
          },
        );
        expect(state.usualMealsUsingFood('f1'), equals(2));
        expect(state.usualMealsUsingFood('f2'), equals(1));
        expect(state.usualMealsUsingFood('f9'), equals(0));
      });
    });

    group('usualFoods', () {
      test('defaults to empty', () {
        expect(const UserSettingsState().usualFoods, isEmpty);
      });

      test('round-trips a populated usualFoods library', () {
        const state = UserSettingsState(
          usualFoods: [
            UsualFood(
              id: 'food-1',
              name: 'Chicken, 1 oz',
              nutrition: Nutrition(calories: 22, protein: 5),
            ),
          ],
        );

        final restored = UserSettingsState.fromJson(state.toJson());

        expect(restored.usualFoods, hasLength(1));
        expect(restored.usualFoods.single.name, equals('Chicken, 1 oz'));
      });

      test('v3 data reads through with an empty library and bumps to v4', () {
        final restored = UserSettingsState.fromJson(<String, dynamic>{
          'version': 3,
          'weightUnit': 'kg',
        });

        expect(restored.usualFoods, isEmpty);
        expect(restored.version, equals(4));
      });
    });

    group('workout weight unit migration', () {
      test('v1 data inherits the body-weight unit and bumps to current', () {
        final state = UserSettingsState.fromJson(<String, dynamic>{
          'version': 1,
          'weightUnit': 'kg',
        });

        expect(state.workoutWeightUnit, equals(WeightUnit.kg));
        expect(state.version, equals(4));
      });

      test('current-version data reads workoutWeightUnit as stored', () {
        final state = UserSettingsState.fromJson(<String, dynamic>{
          'version': 2,
          'weightUnit': 'kg',
          'workoutWeightUnit': 'lb',
        });

        expect(state.workoutWeightUnit, equals(WeightUnit.lb));
      });
    });
  });
}
