import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_ai_repository}
/// Coordinates AI-assisted meal entry: it asks Claude to estimate a meal's
/// name, quantity, and [Nutrition] from a free-text description (and, in a
/// later phase, a photo), returning the domain [AiMealSuggestion] for the user
/// to confirm before logging.
/// {@endtemplate}
@singleton
class MealAiRepository {
  /// {@macro meal_ai_repository}
  MealAiRepository(this._client);

  final MealAiClient _client;

  /// Whether the AI client has an API key configured.
  bool get isConfigured => _client.isConfigured;

  /// Sends [prompt] to Claude and returns the raw text reply. Used by the dev
  /// smoke test to confirm connectivity before real prompts exist.
  Future<String> debugEcho(String prompt) => _client.generateText(prompt);

  /// Estimates a meal's name, quantity, and nutrition from a free-text
  /// [description] of what the user ate.
  Future<AiMealSuggestion> suggestFromDescription(String description) {
    return _client.generateStructured(
      prompt: _descriptionPrompt(description),
      outputSchema: _suggestionSchema,
    );
  }

  /// Estimates a meal's name, quantity, and nutrition from a [photo] of the
  /// food or its nutrition label. [imageMediaType] is the photo's MIME type and
  /// must be one Claude accepts (`image/jpeg`, `image/png`, `image/gif`, or
  /// `image/webp`).
  Future<AiMealSuggestion> suggestFromPhoto(
    Uint8List photo, {
    String imageMediaType = 'image/jpeg',
  }) {
    return _client.generateStructured(
      prompt: _photoPrompt,
      outputSchema: _suggestionSchema,
      image: photo,
      imageMediaType: imageMediaType,
    );
  }

  String _descriptionPrompt(String description) =>
      'Estimate the nutrition for the food described below.\n\n'
      '$_estimationRules\n\n'
      'Food: $description';

  String get _photoPrompt =>
      'Estimate the nutrition for the food in this photo. The photo may show a '
      'plate or serving of food, or a packaged item with a nutrition label; '
      'when a label is visible, base the estimate on its values.\n\n'
      '$_estimationRules';

  /// The shared rules every estimation prompt follows, regardless of whether
  /// the food came from a description or a photo.
  static const String _estimationRules =
      'Return the nutrition for ONE unit of the item you name, and set '
      'quantity to how many of that unit the person had, so nutrition times '
      'quantity equals the total they ate.\n'
      '- If the item is a one-off combination of foods (for example "eggs and '
      'toast"), treat the whole thing as a single unit: set quantity to 1, '
      'name the full combination, and put the combined total in nutrition.\n'
      '- Use quantity greater than 1 only when there are clearly several '
      'identical servings of the same item (for example "3 protein bars" means '
      'quantity 3 with the nutrition of a single bar).\n'
      'Keep the name as short as possible while still clearly identifying the '
      'food, dropping filler words like "a slice of" or "large" (for example '
      '"2 eggs & sourdough toast").\n'
      'Use whole-number calories and whole-number grams for protein, fat, and '
      'carbs. Leave a value null only when it genuinely cannot be estimated.';

  /// JSON-schema-backed [SchemanticType] that maps Claude's structured output
  /// straight into the freezed [AiMealSuggestion] via its `fromJson`.
  static final SchemanticType<AiMealSuggestion> _suggestionSchema =
      SchemanticType.from(
        jsonSchema: <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'name': <String, Object?>{
              'type': 'string',
              'description':
                  'A short label for the food, as few words as '
                  'possible without losing what it is (for example "2 eggs & '
                  'sourdough toast").',
            },
            'quantity': <String, Object?>{
              'type': 'integer',
              'description':
                  'How many identical units of the named item. Use '
                  '1 for a one-off meal; greater than 1 only for repeated '
                  'identical servings.',
            },
            'nutrition': <String, Object?>{
              'type': 'object',
              'description':
                  'Nutrition for a single unit of the named item; '
                  'it is multiplied by quantity to get the total eaten.',
              'properties': <String, Object?>{
                'calories': <String, Object?>{
                  'type': <String>['integer', 'null'],
                },
                'protein': <String, Object?>{
                  'type': <String>['integer', 'null'],
                },
                'fat': <String, Object?>{
                  'type': <String>['integer', 'null'],
                },
                'carbs': <String, Object?>{
                  'type': <String>['integer', 'null'],
                },
              },
            },
          },
          'required': <String>['name', 'quantity', 'nutrition'],
        },
        parse: (json) =>
            AiMealSuggestion.fromJson((json! as Map).cast<String, dynamic>()),
      );
}
