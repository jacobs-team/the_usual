import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WeightEntryField, () {
    final day = DateTime(2026, 6, 17);
    const dayStart = TimeOfDay(hour: 0, minute: 0);

    setUpAll(() {
      registerFallbackValue(
        DailyLogEvent.weightOnDayChanged(day, null, WeightUnit.lb, dayStart),
      );
    });

    WeightEntry weightEntryOn(DateTime loggedAt, double weight) => WeightEntry(
      id: 'w-${loggedAt.toIso8601String()}',
      loggedAt: loggedAt,
      weight: weight,
      weightUnit: WeightUnit.lb,
    );

    /// Builds a DailyLogBloc whose state holds [weightEntries] and emits
    /// [stream] of states, so external syncs can be driven.
    MockDailyLogBloc dailyLogBlocWith(
      List<WeightEntry> weightEntries, {
      Stream<DailyLogState>? stream,
    }) {
      final bloc = MockDailyLogBloc();
      when(
        () => bloc.state,
      ).thenReturn(DailyLogState(weightEntries: weightEntries));
      when(
        () => bloc.stream,
      ).thenAnswer((_) => stream ?? const Stream.empty());
      return bloc;
    }

    String fieldText(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField)).controller!.text;

    testWidgets('prefills with the day weight', (tester) async {
      final dailyLogBloc = dailyLogBlocWith([weightEntryOn(day, 165.5)]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day]),
        deps: [dailyLogBloc],
      );

      expect(fieldText(tester), equals('165.5'));
    });

    testWidgets('typing a weight dispatches weightOnDayChanged', (
      tester,
    ) async {
      final dailyLogBloc = dailyLogBlocWith([]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day]),
        deps: [dailyLogBloc],
      );

      await tester.enterText(find.byType(TextField), '170');
      await tester.pump();

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.weightOnDayChanged(
            day,
            170,
            WeightUnit.lb,
            dayStart,
          ),
        ),
      ).called(1);
    });

    testWidgets('typing a weight writes it to every day in the range', (
      tester,
    ) async {
      final days = [DateTime(2026, 6, 15), DateTime(2026, 6, 16)];
      final dailyLogBloc = dailyLogBlocWith([]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: days),
        deps: [dailyLogBloc],
      );

      await tester.enterText(find.byType(TextField), '170');
      await tester.pump();

      for (final day in days) {
        verify(
          () => dailyLogBloc.add(
            DailyLogEvent.weightOnDayChanged(day, 170, WeightUnit.lb, dayStart),
          ),
        ).called(1);
      }
    });

    testWidgets('clearing the field dispatches a null weight', (tester) async {
      final dailyLogBloc = dailyLogBlocWith([weightEntryOn(day, 165)]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day]),
        deps: [dailyLogBloc],
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.weightOnDayChanged(day, null, WeightUnit.lb, dayStart),
        ),
      ).called(1);
    });

    testWidgets('the "Use last" button fills the last recorded weight', (
      tester,
    ) async {
      final lastWeight = weightEntryOn(
        day.subtract(const Duration(days: 2)),
        180,
      );
      final dailyLogBloc = dailyLogBlocWith([lastWeight]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day], showLastWeightButton: true),
        deps: [dailyLogBloc],
      );

      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.weightOnDayChanged(day, 180, WeightUnit.lb, dayStart),
        ),
      ).called(1);
    });

    testWidgets('no "Use last" button when the day already has a weight', (
      tester,
    ) async {
      final dailyLogBloc = dailyLogBlocWith([
        weightEntryOn(day, 165),
        weightEntryOn(day.subtract(const Duration(days: 2)), 180),
      ]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day], showLastWeightButton: true),
        deps: [dailyLogBloc],
      );

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('syncs the field to an externally-set weight', (tester) async {
      final stateController = StreamController<DailyLogState>.broadcast();
      addTearDown(stateController.close);

      final dailyLogBloc = MockDailyLogBloc();
      var currentState = const DailyLogState();
      when(() => dailyLogBloc.state).thenAnswer((_) => currentState);
      when(
        () => dailyLogBloc.stream,
      ).thenAnswer((_) => stateController.stream);

      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day]),
        deps: [dailyLogBloc],
      );

      expect(fieldText(tester), equals(''));

      currentState = DailyLogState(
        weightEntries: [weightEntryOn(day, 175)],
      );
      stateController.add(currentState);
      await tester.pump();

      expect(fieldText(tester), equals('175'));
    });

    testWidgets('syncs an externally-set weight even while focused', (
      tester,
    ) async {
      final stateController = StreamController<DailyLogState>.broadcast();
      addTearDown(stateController.close);

      final dailyLogBloc = MockDailyLogBloc();
      var currentState = const DailyLogState();
      when(() => dailyLogBloc.state).thenAnswer((_) => currentState);
      when(
        () => dailyLogBloc.stream,
      ).thenAnswer((_) => stateController.stream);

      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: [day]),
        deps: [dailyLogBloc],
      );

      final focusNode = tester
          .widget<TextField>(find.byType(TextField))
          .focusNode;
      focusNode!.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      currentState = DailyLogState(weightEntries: [weightEntryOn(day, 175)]);
      stateController.add(currentState);
      await tester.pump();

      expect(fieldText(tester), equals('175'));
    });
  });
}
