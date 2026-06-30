import 'package:injectable/injectable.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

/// An AI-estimated composed meal: a short `name` for the whole meal plus its
/// component foods as `items`. Returned by
/// `MealAiRepository.suggestComposedMealFromDescription`.
typedef AiComposedMeal = ({String name, List<AiMealSuggestion> items});

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

  /// Estimates one combined whole-meal item from a free-text [description]
  /// and/or any number of [photos] as added context (the count of photos does
  /// not matter). Returns the nutrition for one unit with a count.
  Future<AiMealSuggestion> suggestWholeMeal({
    String? description,
    List<MealPhoto> photos = const <MealPhoto>[],
  }) {
    return _client.generateStructured(
      prompt: _estimatePrompt(
        MealEntryMode.wholeMeal,
        description: description,
        fromPhoto: photos.isNotEmpty,
      ),
      outputSchema: _suggestionSchema,
      images: photos,
    );
  }

  /// Estimates a composed meal — a short name plus its base-unit component
  /// foods — from a free-text [description] and/or any number of [photos] as
  /// added context. Used by the by-foods flow to turn a description or photo
  /// into food rows and to name the meal.
  Future<AiComposedMeal> suggestComposedMeal({
    String? description,
    List<MealPhoto> photos = const <MealPhoto>[],
  }) {
    return _client.generateStructured(
      prompt: _estimatePrompt(
        MealEntryMode.itemized,
        description: description,
        fromPhoto: photos.isNotEmpty,
      ),
      outputSchema: _composedMealSchema,
      images: photos,
    );
  }

  /// Builds the prompt for an estimate: the photo intro when [fromPhoto], else
  /// the description intro, with any typed [description] woven in and the
  /// mode-specific rules appended.
  String _estimatePrompt(
    MealEntryMode mode, {
    required bool fromPhoto,
    String? description,
  }) {
    return fromPhoto
        ? _photoPrompt(mode, description)
        : _descriptionPrompt(description ?? '', mode);
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
    final naming = switch (mode) {
      // Itemized foods must carry their base unit in the name, so the
      // short-name rule (which strips amounts) does not apply.
      MealEntryMode.itemized => _itemizedNameRule,
      MealEntryMode.wholeMeal =>
        fromPhoto ? '$_shortNameRule $_photoPortionInName' : _shortNameRule,
    };
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
      'distinct food. For each food, return the nutrition of ONE BASE UNIT and '
      'set quantity to how many of that unit there are, so a portion is '
      'expressed as a base unit times a count. The base unit should be the '
      'smallest amount a person would realistically eat in a meal, so the '
      'quantity stays a small, sensible number the user can adjust in a few '
      'taps. Never pick a tiny unit that forces a huge quantity: do NOT use '
      '"Rice, 1 g" with quantity 150 — use "Rice, 100 g" with quantity about '
      '1 to 2. For a countable food the base unit is one of it: "1 egg", '
      '"1 strip of bacon", "1 carrot", "1 slice of toast". For a food measured '
      'by weight or volume the base unit is a natural serving, rarely smaller '
      'than 1 oz: meat in 1 oz steps (a 4 oz steak is "Steak, 1 oz" quantity '
      '4), rice or grains in ~100 g steps, chips or nuts in 1 oz steps. '
      'Examples: "4 oz chicken" becomes "Chicken, 1 oz" quantity 4; "200 g '
      'rice" becomes "Rice, 100 g" quantity 2; "5 strips of bacon" becomes '
      '"Bacon, 1 strip" quantity 5; "3 eggs" becomes "Egg, 1 egg" quantity 3.';

  static const String _shortNameRule =
      'Keep each name as short as possible while still clearly identifying the '
      'food, dropping filler words like "a slice of" or "large" (for example '
      '"2 eggs & sourdough toast").';

  static const String _itemizedNameRule =
      'Name every food as the food followed by its base unit, and ALWAYS '
      'include that unit or amount in the name: "Chicken, 1 oz", "Cheese, '
      '1 oz", "Sour cream, 1 oz", "Tortilla, medium", "Rice, 100 g", "Egg, '
      '1 egg". Never drop the unit and never return a bare food name like '
      '"Cheese" or "Flour tortilla" with no amount. Stay faithful to the '
      'foods the user listed: keep each one as its own food and do not rename, '
      'merge, or reinterpret it — if the user says "chicken" use "Chicken, '
      '1 oz", not "chicken quesadilla filling". When the user gives a unit or '
      'amount for a food, use exactly that as its base unit.';

  static const String _photoPortionInName =
      'When you can confidently estimate a portion size from the photo, '
      'include the amount in the name using grams or ounces (for example '
      '"200g grilled chicken" or "6 oz filet").';

  static const String _valueRules =
      'Give calories and the protein, fat, and carb grams for one unit as '
      'precisely as the unit size warrants. When the base unit is small '
      '(around 1 oz, 1 strip, a single egg, or any unit a person eats '
      'several of), return one decimal place: rounding a per-unit value to '
      'a whole number throws the total off once it is multiplied by the '
      'quantity, so a food at 1 oz might be 2.8 g protein and 7.6 '
      'calories, not 3 and 8. For a larger unit (around 100 g or a whole '
      'serving) whole numbers are fine. Leave a value null only when it '
      'genuinely cannot be estimated.';

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
            'type': <String>['number', 'null'],
          },
          'protein': <String, Object?>{
            'type': <String>['number', 'null'],
          },
          'fat': <String, Object?>{
            'type': <String>['number', 'null'],
          },
          'carbs': <String, Object?>{
            'type': <String>['number', 'null'],
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

  /// Maps Claude's `{mealName, items}` output into a short meal name and the
  /// list of [AiMealSuggestion]s, used to itemize a typed description into a
  /// composed meal.
  static final SchemanticType<AiComposedMeal> _composedMealSchema =
      SchemanticType.from(
        jsonSchema: <String, Object?>{
          'type': 'object',
          'properties': <String, Object?>{
            'mealName': <String, Object?>{
              'type': 'string',
              'description':
                  'A short, descriptive name for the whole meal, two to four '
                  'words, for example "Chicken quesadilla". Do not include '
                  'amounts or list every ingredient.',
            },
            'items': <String, Object?>{
              'type': 'array',
              'description': 'One entry per distinct food in the meal.',
              'items': _itemSchema,
            },
          },
          'required': <String>['mealName', 'items'],
        },
        parse: (json) {
          final map = (json! as Map).cast<String, dynamic>();
          final items = map['items'] as List;
          return (
            name: (map['mealName'] as String? ?? '').trim(),
            items: [
              for (final item in items)
                AiMealSuggestion.fromJson(
                  (item as Map).cast<String, dynamic>(),
                ),
            ],
          );
        },
      );
}
