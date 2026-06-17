import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

class _FakeSuggestionSchema extends Fake
    implements SchemanticType<AiMealSuggestion> {}

class _FakeItemsSchema extends Fake
    implements SchemanticType<List<AiMealSuggestion>> {}

void main() {
  late MockMealAiClient client;
  late MealAiRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeSuggestionSchema());
    registerFallbackValue(_FakeItemsSchema());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    client = MockMealAiClient();
    repository = MealAiRepository(client);
  });

  /// Drives the real schema's `parse` closure with [rawJson], mirroring what
  /// Genkit does with the model's structured output, so the repository's
  /// parsing wiring is exercised end to end.
  void stubWholeMeal(Object? rawJson) {
    when(
      () => client.generateStructured<AiMealSuggestion>(
        prompt: any(named: 'prompt'),
        outputSchema: any(named: 'outputSchema'),
        image: any(named: 'image'),
        imageMediaType: any(named: 'imageMediaType'),
      ),
    ).thenAnswer((invocation) async {
      final outputSchema =
          invocation.namedArguments[#outputSchema]
              as SchemanticType<AiMealSuggestion>;
      return outputSchema.parse(rawJson);
    });
  }

  void stubItemized(Object? rawJson) {
    when(
      () => client.generateStructured<List<AiMealSuggestion>>(
        prompt: any(named: 'prompt'),
        outputSchema: any(named: 'outputSchema'),
        image: any(named: 'image'),
        imageMediaType: any(named: 'imageMediaType'),
      ),
    ).thenAnswer((invocation) async {
      final outputSchema =
          invocation.namedArguments[#outputSchema]
              as SchemanticType<List<AiMealSuggestion>>;
      return outputSchema.parse(rawJson);
    });
  }

  group(MealAiRepository, () {
    group('isConfigured', () {
      test('reflects the client configuration', () {
        when(() => client.isConfigured).thenReturn(true);
        expect(repository.isConfigured, isTrue);

        when(() => client.isConfigured).thenReturn(false);
        expect(repository.isConfigured, isFalse);
      });
    });

    group('debugEcho', () {
      test('returns the client reply', () async {
        when(
          () => client.generateText('ping'),
        ).thenAnswer((_) async => 'pong');

        expect(await repository.debugEcho('ping'), equals('pong'));
      });
    });

    group('suggestFromDescription', () {
      test('wraps a whole-meal estimate in a single-element list', () async {
        stubWholeMeal(<String, dynamic>{
          'name': '2 eggs & toast',
          'quantity': 1,
          'nutrition': {'calories': 350, 'protein': 18, 'fat': 14, 'carbs': 30},
        });

        final suggestions = await repository.suggestFromDescription(
          'two eggs and toast',
          mode: MealEntryMode.wholeMeal,
        );

        expect(suggestions, hasLength(1));
        expect(
          suggestions.single,
          isA<AiMealSuggestion>()
              .having((s) => s.name, 'name', equals('2 eggs & toast'))
              .having((s) => s.quantity, 'quantity', equals(1.0))
              .having(
                (s) => s.nutrition.calories,
                'calories',
                equals(350),
              ),
        );
      });

      test('returns the itemized list directly', () async {
        stubItemized(<String, dynamic>{
          'items': [
            {
              'name': '5 strips bacon',
              'quantity': 5,
              'nutrition': {'calories': 40},
            },
            {
              'name': '2 eggs',
              'quantity': 2,
              'nutrition': {'calories': 70},
            },
          ],
        });

        final suggestions = await repository.suggestFromDescription(
          'bacon and eggs',
          mode: MealEntryMode.itemized,
        );

        expect(suggestions, hasLength(2));
        expect(
          suggestions.first,
          isA<AiMealSuggestion>()
              .having((s) => s.name, 'name', equals('5 strips bacon'))
              .having((s) => s.quantity, 'quantity', equals(5.0)),
        );
      });
    });

    group('suggestFromPhoto', () {
      test('estimates a whole meal from a photo with a description', () async {
        stubWholeMeal(<String, dynamic>{
          'name': '200g grilled chicken',
          'quantity': 1,
          'nutrition': {'calories': 330},
        });

        final suggestions = await repository.suggestFromPhoto(
          Uint8List.fromList([1, 2, 3]),
          mode: MealEntryMode.wholeMeal,
          description: 'grilled chicken',
          imageMediaType: 'image/png',
        );

        expect(suggestions, hasLength(1));
        expect(
          suggestions.single.name,
          equals('200g grilled chicken'),
        );
        verify(
          () => client.generateStructured<AiMealSuggestion>(
            prompt: any(named: 'prompt'),
            outputSchema: any(named: 'outputSchema'),
            image: any(named: 'image'),
            imageMediaType: 'image/png',
          ),
        ).called(1);
      });

      test('estimates an itemized meal from a photo without a '
          'description', () async {
        stubItemized(<String, dynamic>{
          'items': [
            {
              'name': '6 oz filet',
              'quantity': 1,
              'nutrition': {'calories': 400},
            },
          ],
        });

        final suggestions = await repository.suggestFromPhoto(
          Uint8List.fromList([4, 5, 6]),
          mode: MealEntryMode.itemized,
        );

        expect(suggestions, hasLength(1));
        expect(suggestions.single.name, equals('6 oz filet'));
      });
    });

    group('error paths', () {
      test('propagates a client failure', () async {
        when(
          () => client.generateStructured<AiMealSuggestion>(
            prompt: any(named: 'prompt'),
            outputSchema: any(named: 'outputSchema'),
            image: any(named: 'image'),
            imageMediaType: any(named: 'imageMediaType'),
          ),
        ).thenThrow(StateError('no structured output'));

        expect(
          () => repository.suggestFromDescription(
            'mystery food',
            mode: MealEntryMode.wholeMeal,
          ),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
