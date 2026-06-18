import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

final _pastDay = DateTime(2026, 6, 16);

void main() {
  // The default day boundary is midnight, so a logical day equals a calendar
  // day in these tests.
  const dayStart = TimeOfDay(hour: 0, minute: 0);

  group(DailyLogBloc, () {
    setUp(initHydratedStorage);

    WeightEntry weightEntry({
      required String id,
      required DateTime loggedAt,
      double weight = 165,
    }) {
      return WeightEntry(
        id: id,
        loggedAt: loggedAt,
        weight: weight,
        weightUnit: WeightUnit.lb,
      );
    }

    MealLogEntry mealEntry({
      required String id,
      required DateTime loggedAt,
      int? calories,
      MealOfTheDay mealOfTheDay = MealOfTheDay.breakfast,
    }) {
      return MealLogEntry(
        id: id,
        loggedAt: loggedAt,
        mealOfTheDay: mealOfTheDay,
        name: id,
        nutrition: Nutrition(calories: calories),
      );
    }

    test('initial state is the default DailyLogState', () {
      expect(DailyLogBloc().state, equals(const DailyLogState()));
    });

    group('mealLogged', () {
      blocTest<DailyLogBloc, DailyLogState>(
        'appends a meal entry',
        build: DailyLogBloc.new,
        act: (bloc) => bloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.lunch,
            'Sandwich',
            nutrition: Nutrition(calories: 450),
            usualMealId: 'usual-1',
            photoPath: '/tmp/p.png',
          ),
        ),
        expect: () => [
          isA<DailyLogState>().having(
            (s) => s.mealEntries,
            'mealEntries',
            hasLength(1),
          ),
        ],
      );

      blocTest<DailyLogBloc, DailyLogState>(
        'ignores a blank name',
        build: DailyLogBloc.new,
        act: (bloc) =>
            bloc.add(const DailyLogEvent.mealLogged(MealOfTheDay.lunch, '  ')),
        expect: () => <DailyLogState>[],
      );

      blocTest<DailyLogBloc, DailyLogState>(
        'stamps loggedAt at the logical day start when a day is given',
        build: DailyLogBloc.new,
        act: (bloc) => bloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.dinner,
            'Tacos',
            nutrition: const Nutrition(calories: 650),
            day: _pastDay,
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
        verify: (bloc) {
          final entry = bloc.state.mealEntries.single;
          expect(
            entry.loggedAt,
            equals(_pastDay.atDayStart(const TimeOfDay(hour: 4, minute: 0))),
          );
          expect(entry.mealOfTheDay, equals(MealOfTheDay.dinner));
          expect(
            entry.loggedAt.logicalDay(const TimeOfDay(hour: 4, minute: 0)),
            equals(_pastDay),
          );
        },
      );
    });

    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryRemoved drops the matching entry',
      build: DailyLogBloc.new,
      seed: () => DailyLogState(
        mealEntries: [
          mealEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          mealEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(const DailyLogEvent.mealEntryRemoved('a')),
      expect: () => [
        isA<DailyLogState>().having(
          (s) => s.mealEntries.single.id,
          'remaining entry id',
          'b',
        ),
      ],
    );

    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryNutritionChanged updates the matching entry only',
      build: DailyLogBloc.new,
      seed: () => DailyLogState(
        mealEntries: [
          mealEntry(id: 'a', loggedAt: DateTime(2026, 6, 14), calories: 100),
          mealEntry(id: 'b', loggedAt: DateTime(2026, 6, 14), calories: 200),
        ],
      ),
      act: (bloc) => bloc.add(
        const DailyLogEvent.mealEntryNutritionChanged(
          'a',
          Nutrition(calories: 175),
        ),
      ),
      expect: () => [
        isA<DailyLogState>().having(
          (s) => s.mealEntries.first.nutrition.calories,
          'updated calories',
          175,
        ),
      ],
    );

    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryQuantityChanged sanitizes and updates the matching entry only',
      build: DailyLogBloc.new,
      seed: () => DailyLogState(
        mealEntries: [
          mealEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          mealEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      // 1.25 sanitizes to 1.3 via asLoggedQuantity.
      act: (bloc) =>
          bloc.add(const DailyLogEvent.mealEntryQuantityChanged('a', 1.25)),
      expect: () => [
        isA<DailyLogState>()
            .having(
              (s) => s.mealEntries.first.quantity,
              'updated quantity',
              1.3,
            )
            .having(
              (s) => s.mealEntries.last.quantity,
              'untouched quantity',
              1,
            ),
      ],
    );

    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryUsualMealLinked stamps the usual meal id on the entry only',
      build: DailyLogBloc.new,
      seed: () => DailyLogState(
        mealEntries: [
          mealEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          mealEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(
        const DailyLogEvent.mealEntryUsualMealLinked('a', 'usual-1'),
      ),
      expect: () => [
        isA<DailyLogState>()
            .having(
              (s) => s.mealEntries.first.usualMealId,
              'linked usual meal id',
              'usual-1',
            )
            .having(
              (s) => s.mealEntries.last.usualMealId,
              'untouched usual meal id',
              isNull,
            ),
      ],
    );

    blocTest<DailyLogBloc, DailyLogState>(
      'weightLogged appends a weight entry',
      build: DailyLogBloc.new,
      act: (bloc) =>
          bloc.add(const DailyLogEvent.weightLogged(165.5, WeightUnit.lb)),
      expect: () => [
        isA<DailyLogState>().having(
          (s) => s.weightEntries.single.weight,
          'logged weight',
          165.5,
        ),
      ],
    );

    group('weightOnDayChanged', () {
      blocTest<DailyLogBloc, DailyLogState>(
        'adds a new entry when none exists for today',
        build: DailyLogBloc.new,
        act: (bloc) => bloc.add(
          DailyLogEvent.weightOnDayChanged(
            testNow,
            170,
            WeightUnit.lb,
            dayStart,
          ),
        ),
        expect: () => [
          isA<DailyLogState>().having(
            (s) => s.weightEntries.single.weight,
            'today weight',
            170,
          ),
        ],
      );

      blocTest<DailyLogBloc, DailyLogState>(
        'updates the existing entry for today',
        build: DailyLogBloc.new,
        seed: () => DailyLogState(
          weightEntries: [weightEntry(id: 'today', loggedAt: testNow)],
        ),
        act: (bloc) => bloc.add(
          DailyLogEvent.weightOnDayChanged(
            testNow,
            172,
            WeightUnit.kg,
            dayStart,
          ),
        ),
        expect: () => [
          isA<DailyLogState>()
              .having((s) => s.weightEntries, 'weightEntries', hasLength(1))
              .having(
                (s) => s.weightEntries.single.weight,
                'updated weight',
                172,
              )
              .having(
                (s) => s.weightEntries.single.weightUnit,
                'updated unit',
                WeightUnit.kg,
              ),
        ],
      );

      blocTest<DailyLogBloc, DailyLogState>(
        'removes today entry when weight is null, keeping other days',
        build: DailyLogBloc.new,
        seed: () => DailyLogState(
          weightEntries: [
            weightEntry(id: 'today', loggedAt: testNow),
            weightEntry(id: 'old', loggedAt: DateTime(2020)),
          ],
        ),
        act: (bloc) => bloc.add(
          DailyLogEvent.weightOnDayChanged(
            testNow,
            null,
            WeightUnit.lb,
            dayStart,
          ),
        ),
        expect: () => [
          isA<DailyLogState>().having(
            (s) => s.weightEntries.single.id,
            'remaining entry id',
            'old',
          ),
        ],
      );
    });

    blocTest<DailyLogBloc, DailyLogState>(
      'sampleDataSeeded fills the log with sample meals and weigh-ins',
      build: DailyLogBloc.new,
      act: (bloc) => bloc.add(const DailyLogEvent.sampleDataSeeded()),
      expect: () => [
        isA<DailyLogState>()
            .having((s) => s.mealEntries, 'mealEntries', isNotEmpty)
            .having((s) => s.weightEntries, 'weightEntries', isNotEmpty),
      ],
    );

    test('toJson then fromJson round-trips the state', () {
      final bloc = DailyLogBloc();
      final state = DailyLogState(
        weightEntries: [weightEntry(id: 'a', loggedAt: DateTime(2026, 6, 14))],
      );

      final restored = bloc.fromJson(bloc.toJson(state));

      expect(restored, equals(state));
    });
  });

  group(DailyLogState, () {
    test('fromJson reads a newer, unknown version with the current schema', () {
      final json = <String, dynamic>{
        'version': 99,
        'meal_entries': <dynamic>[],
        'weight_entries': <dynamic>[],
      };

      final state = DailyLogState.fromJson(json);

      expect(state.version, equals(99));
      expect(state.mealEntries, isEmpty);
      expect(state.weightEntries, isEmpty);
    });

    WeightEntry weightEntry(String id, DateTime loggedAt) {
      return WeightEntry(
        id: id,
        loggedAt: loggedAt,
        weight: 165,
        weightUnit: WeightUnit.lb,
      );
    }

    group('weightOn', () {
      test('returns the entry recorded on the given day', () {
        final state = DailyLogState(
          weightEntries: [weightEntry('a', DateTime(2026, 6, 14, 7))],
        );

        expect(
          state.weightOn(DateTime(2026, 6, 14, 23), dayStart)?.id,
          equals('a'),
        );
      });

      test('returns null when no entry was recorded that day', () {
        final state = DailyLogState(
          weightEntries: [weightEntry('a', DateTime(2026, 6, 14))],
        );

        expect(state.weightOn(DateTime(2026, 6, 13), dayStart), isNull);
      });
    });

    group('latestWeight', () {
      test('returns null when there are no weigh-ins', () {
        expect(const DailyLogState().latestWeight, isNull);
      });

      test('returns the most recent weigh-in', () {
        final state = DailyLogState(
          weightEntries: [
            weightEntry('old', DateTime(2026, 6, 10)),
            weightEntry('new', DateTime(2026, 6, 14)),
          ],
        );

        expect(state.latestWeight?.id, equals('new'));
      });
    });

    group('historyByMonth', () {
      test('is empty when nothing has been logged', () {
        expect(const DailyLogState().historyByMonth(dayStart), isEmpty);
      });

      test('rolls meals and weigh-ins up by month with averages', () {
        final state = DailyLogState(
          mealEntries: [
            MealLogEntry(
              id: 'm1',
              loggedAt: DateTime(2026, 5, 10, 8),
              mealOfTheDay: MealOfTheDay.breakfast,
              name: 'Eggs',
              nutrition: const Nutrition(calories: 300),
            ),
            MealLogEntry(
              id: 'm2',
              loggedAt: DateTime(2026, 6, 14, 8),
              mealOfTheDay: MealOfTheDay.breakfast,
              name: 'Oats',
              nutrition: const Nutrition(calories: 500),
            ),
          ],
          weightEntries: [weightEntry('w1', DateTime(2026, 6, 14, 7))],
        );

        final history = state.historyByMonth(dayStart);

        expect(history, hasLength(2));
        // Oldest month first.
        expect(history.first.month, equals(DateTime(2026, 5)));
        expect(history.first.averageNutrition.calories, equals(300));
        expect(history.last.month, equals(DateTime(2026, 6)));
        expect(history.last.averageNutrition.calories, equals(500));
        expect(history.last.days.single.weightEntry?.id, equals('w1'));
      });
    });
  });
}
