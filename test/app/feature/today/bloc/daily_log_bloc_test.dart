import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
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
        calories: calories,
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
            calories: 450,
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
      'mealEntryCaloriesChanged updates the matching entry only',
      build: DailyLogBloc.new,
      seed: () => DailyLogState(
        mealEntries: [
          mealEntry(id: 'a', loggedAt: DateTime(2026, 6, 14), calories: 100),
          mealEntry(id: 'b', loggedAt: DateTime(2026, 6, 14), calories: 200),
        ],
      ),
      act: (bloc) =>
          bloc.add(const DailyLogEvent.mealEntryCaloriesChanged('a', 175)),
      expect: () => [
        isA<DailyLogState>().having(
          (s) => s.mealEntries.first.calories,
          'updated calories',
          175,
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

    group('todayWeightChanged', () {
      blocTest<DailyLogBloc, DailyLogState>(
        'adds a new entry when none exists for today',
        build: DailyLogBloc.new,
        act: (bloc) => bloc.add(
          const DailyLogEvent.todayWeightChanged(170, WeightUnit.lb),
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
          weightEntries: [weightEntry(id: 'today', loggedAt: DateTime.now())],
        ),
        act: (bloc) => bloc.add(
          const DailyLogEvent.todayWeightChanged(172, WeightUnit.kg),
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
            weightEntry(id: 'today', loggedAt: DateTime.now()),
            weightEntry(id: 'old', loggedAt: DateTime(2020)),
          ],
        ),
        act: (bloc) => bloc.add(
          const DailyLogEvent.todayWeightChanged(null, WeightUnit.lb),
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
            .having((s) => s.weightEntries, 'weightEntries', hasLength(10)),
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

        expect(state.weightOn(DateTime(2026, 6, 14, 23))?.id, equals('a'));
      });

      test('returns null when no entry was recorded that day', () {
        final state = DailyLogState(
          weightEntries: [weightEntry('a', DateTime(2026, 6, 14))],
        );

        expect(state.weightOn(DateTime(2026, 6, 13)), isNull);
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
        expect(const DailyLogState().historyByMonth, isEmpty);
      });

      test('rolls meals and weigh-ins up by month with averages', () {
        final state = DailyLogState(
          mealEntries: [
            MealLogEntry(
              id: 'm1',
              loggedAt: DateTime(2026, 5, 10, 8),
              mealOfTheDay: MealOfTheDay.breakfast,
              name: 'Eggs',
              calories: 300,
            ),
            MealLogEntry(
              id: 'm2',
              loggedAt: DateTime(2026, 6, 14, 8),
              mealOfTheDay: MealOfTheDay.breakfast,
              name: 'Oats',
              calories: 500,
            ),
          ],
          weightEntries: [weightEntry('w1', DateTime(2026, 6, 14, 7))],
        );

        final history = state.historyByMonth;

        expect(history, hasLength(2));
        // Oldest month first.
        expect(history.first.month, equals(DateTime(2026, 5)));
        expect(history.first.averageDailyCalories, equals(300));
        expect(history.last.month, equals(DateTime(2026, 6)));
        expect(history.last.averageDailyCalories, equals(500));
        expect(history.last.days.single.weightEntry?.id, equals('w1'));
      });
    });
  });
}
