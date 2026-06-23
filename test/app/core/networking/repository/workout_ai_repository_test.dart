import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

class _FakeNamesSchema extends Fake implements SchemanticType<List<String>> {}

class _FakeWeightSchema extends Fake implements SchemanticType<double?> {}

void main() {
  late MockMealAiClient client;
  late WorkoutAiRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeNamesSchema());
    registerFallbackValue(_FakeWeightSchema());
    registerFallbackValue(<MealPhoto>[]);
  });

  setUp(() {
    client = MockMealAiClient();
    repository = WorkoutAiRepository(client);
  });

  void stubNamesFromPhoto(Object? rawJson) {
    when(
      () => client.generateStructured<List<String>>(
        prompt: any(named: 'prompt'),
        outputSchema: any(named: 'outputSchema'),
        images: any(named: 'images'),
      ),
    ).thenAnswer((invocation) async {
      final outputSchema =
          invocation.namedArguments[#outputSchema]
              as SchemanticType<List<String>>;
      return outputSchema.parse(rawJson);
    });
  }

  void stubWeightSchema(Object? rawJson) {
    when(
      () => client.generateStructured<double?>(
        prompt: any(named: 'prompt'),
        outputSchema: any(named: 'outputSchema'),
        images: any(named: 'images'),
      ),
    ).thenAnswer((invocation) async {
      final outputSchema =
          invocation.namedArguments[#outputSchema]
              as SchemanticType<double?>;
      return outputSchema.parse(rawJson);
    });
  }

  group(WorkoutAiRepository, () {
    group('isConfigured', () {
      test('delegates to the client', () {
        when(() => client.isConfigured).thenReturn(true);
        expect(repository.isConfigured, isTrue);

        when(() => client.isConfigured).thenReturn(false);
        expect(repository.isConfigured, isFalse);
      });
    });

    group('suggestNamesFromPhoto', () {
      test('returns the parsed name list', () async {
        stubNamesFromPhoto(<String, dynamic>{
          'names': ['Lat Pulldown', 'Seated Row', 'Cable Curl'],
        });

        final names = await repository.suggestNamesFromPhoto([
          MealPhoto(bytes: transparentPixel, mediaType: 'image/png'),
        ]);

        expect(names, equals(['Lat Pulldown', 'Seated Row', 'Cable Curl']));
      });
    });

    group('estimateBodyweightLoad', () {
      test('returns the parsed weight', () async {
        stubWeightSchema(<String, dynamic>{'weight': 130.5});

        final result = await repository.estimateBodyweightLoad(
          exerciseName: 'Push-up',
          bodyWeight: 200,
          unit: WeightUnit.lb,
        );

        expect(result, closeTo(130.5, 0.01));
      });

      test('returns null when the model returns null weight', () async {
        stubWeightSchema(<String, dynamic>{'weight': null});

        final result = await repository.estimateBodyweightLoad(
          exerciseName: 'Handstand Push-up',
          bodyWeight: 200,
          unit: WeightUnit.lb,
        );

        expect(result, isNull);
      });
    });
  });
}
