import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_ai_repository}
/// Coordinates AI-assisted meal entry: it asks Claude to estimate a meal's
/// name, quantity, and [Nutrition] from a free-text description or a photo,
/// returning [AiMealSuggestion]s for the user to confirm before logging. The
/// [MealEntryMode] decides whether the meal comes back as one combined item
/// ([MealEntryMode.wholeMeal]) or broken into its individual foods
/// ([MealEntryMode.itemized]), so every estimate is returned as a list.
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

  /// Estimates the food in a free-text [description] of what the user ate,
  /// returning one combined item or a per-food breakdown per [mode].
  Future<List<AiMealSuggestion>> suggestFromDescription(
    String description, {
    required MealEntryMode mode,
  }) {
    return _estimate(prompt: _descriptionPrompt(description, mode), mode: mode);
  }

  /// Estimates the food in a [photo] of the meal or its nutrition label,
  /// returning one combined item or a per-food breakdown per [mode]. When the
  /// user has typed a [description] of the food it is sent alongside the photo
  /// to sharpen the estimate. [imageMediaType] is the photo's MIME type and
  /// must be one Claude accepts (`image/jpeg`, `image/png`, `image/gif`, or
  /// `image/webp`).
  Future<List<AiMealSuggestion>> suggestFromPhoto(
    Uint8List photo, {
    required MealEntryMode mode,
    String? description,
    String imageMediaType = 'image/jpeg',
  }) {
    return _estimate(
      prompt: _photoPrompt(mode, description),
      mode: mode,
      image: photo,
      imageMediaType: imageMediaType,
    );
  }

  /// Sends [prompt] (with an optional [image]) to Claude and normalises the
  /// result to a list: itemized mode returns the model's list directly, while
  /// whole-meal mode returns its single item wrapped in a one-element list.
  Future<List<AiMealSuggestion>> _estimate({
    required String prompt,
    required MealEntryMode mode,
    Uint8List? image,
    String imageMediaType = 'image/jpeg',
  }) async {
    if (mode == MealEntryMode.itemized) {
      return _client.generateStructured(
        prompt: prompt,
        outputSchema: _itemsSchema,
        image: image,
        imageMediaType: imageMediaType,
      );
    }
    final suggestion = await _client.generateStructured(
      prompt: prompt,
      outputSchema: _suggestionSchema,
      image: image,
      imageMediaType: imageMediaType,
    );
    return [suggestion];
  }

  String _descriptionPrompt(String description, MealEntryMode mode) =>
      'Estimate the nutrition for the food described below.\n\n'
      '${_rules(mode: mode, fromPhoto: false)}\n\n'
      'Food: $description';

  String _photoPrompt(MealEntryMode mode, String? description) {
    const intro =
        'Estimate the nutrition for the food in this photo. The photo may show '
        'a plate or serving of food, or a packaged item with a nutrition '
        'label; when a label is visible, base the estimate on its values.';
    final descriptionHint = description == null
        ? ''
        : '\n\nThe user describes the food as: "$description". Use this '
              'description to identify the food and sharpen the estimate.';
    return '$intro$descriptionHint\n\n${_rules(mode: mode, fromPhoto: true)}';
  }

  /// Assembles the estimation rules for a request: the grouping rule depends on
  /// [mode], and the portion-in-name rule is added only when the food came
  /// [fromPhoto], since a portion can't be gauged from text alone.
  String _rules({required MealEntryMode mode, required bool fromPhoto}) {
    final grouping = switch (mode) {
      MealEntryMode.wholeMeal => _wholeMealGrouping,
      MealEntryMode.itemized => _itemizedGrouping,
    };
    final naming = fromPhoto
        ? '$_shortNameRule $_photoPortionInName'
        : _shortNameRule;
    return '$grouping\n$naming\n$_valueRules';
  }

  static const String _wholeMealGrouping =
      'Treat the whole meal as a single item. Return the nutrition for ONE '
      'unit and set quantity to how many of that unit there are, so nutrition '
      'times quantity equals the total eaten. A one-off combination of foods '
      '(for example "eggs and toast") is one unit with quantity 1; use a '
      'quantity greater than 1 only for several identical servings (for '
      'example "3 protein bars" is quantity 3 with the nutrition of one bar).';

  static const String _itemizedGrouping =
      'Break the meal into its individual foods and return one item per '
      'distinct food. Set the quantity of each item to the count of that food '
      '(for example 5 strips of bacon is quantity 5 with the nutrition of one '
      'strip), and give the nutrition of each item for a single unit.';

  static const String _shortNameRule =
      'Keep each name as short as possible while still clearly identifying the '
      'food, dropping filler words like "a slice of" or "large" (for example '
      '"2 eggs & sourdough toast").';

  static const String _photoPortionInName =
      'When you can confidently estimate a portion size from the photo, '
      'include the amount in the name using grams or ounces (for example '
      '"200g grilled chicken" or "6 oz filet").';

  static const String _valueRules =
      'Use whole-number calories and whole-number grams for protein, fat, and '
      'carbs. Leave a value null only when it genuinely cannot be estimated.';

  /// JSON schema for a single estimated food: its name, quantity, and per-unit
  /// nutrition. Reused on its own for a whole-meal estimate and as the element
  /// type of the itemized list.
  static const Map<String, Object?> _itemSchema = <String, Object?>{
    'type': 'object',
    'properties': <String, Object?>{
      'name': <String, Object?>{
        'type': 'string',
        'description':
            'A short label for the food, as few words as possible without '
            'losing what it is (for example "2 eggs & sourdough toast" or '
            '"6 oz filet").',
      },
      'quantity': <String, Object?>{
        'type': 'integer',
        'description':
            'How many identical units of this item. Use 1 for a single '
            'serving; greater than 1 only for repeated identical servings.',
      },
      'nutrition': <String, Object?>{
        'type': 'object',
        'description':
            'Nutrition for a single unit of this item; it is multiplied by '
            'quantity to get the total eaten.',
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
  };

  /// Maps Claude's single-item output into an [AiMealSuggestion], used for
  /// whole-meal estimates.
  static final SchemanticType<AiMealSuggestion> _suggestionSchema =
      SchemanticType.from(
        jsonSchema: _itemSchema,
        parse: (json) =>
            AiMealSuggestion.fromJson((json! as Map).cast<String, dynamic>()),
      );

  /// Maps Claude's `{items: [...]}` output into a list of [AiMealSuggestion]s,
  /// used for itemized estimates.
  static final SchemanticType<List<AiMealSuggestion>> _itemsSchema =
      SchemanticType.from(
        jsonSchema: <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'items': <String, Object?>{
              'type': 'array',
              'description': 'One entry per distinct food in the meal.',
              'items': _itemSchema,
            },
          },
          'required': <String>['items'],
        },
        parse: (json) {
          final map = (json! as Map).cast<String, dynamic>();
          final items = map['items'] as List;
          return [
            for (final item in items)
              AiMealSuggestion.fromJson((item as Map).cast<String, dynamic>()),
          ];
        },
      );
}
