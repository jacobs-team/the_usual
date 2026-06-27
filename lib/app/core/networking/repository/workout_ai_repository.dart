import 'package:injectable/injectable.dart';
import 'package:schemantic/schemantic.dart';
import 'package:the_usual/app/app.dart';

/// {@template workout_ai_repository}
/// Coordinates AI-assisted workout entry: it asks Claude to identify gym
/// equipment from a photo and suggest exercise names, or to estimate the
/// effective load of a bodyweight movement given the user's body weight.
/// {@endtemplate}
@singleton
class WorkoutAiRepository {
  /// {@macro workout_ai_repository}
  WorkoutAiRepository(this._client);

  final MealAiClient _client;

  /// Whether the AI client has an API key configured.
  bool get isConfigured => _client.isConfigured;

  /// Sends [photos] of gym equipment to Claude and returns a list of exercise
  /// names commonly performed on it, up to six suggestions.
  Future<List<String>> suggestNamesFromPhoto(List<MealPhoto> photos) {
    const prompt =
        'This photo shows a piece of gym equipment or a weight machine. '
        'List the exercises commonly performed on it. Use the shortest clear, '
        'conventional exercise names (for example "Lat Pulldown", '
        '"Leg Press"). Return at most 6.';
    return _client.generateStructured(
      prompt: prompt,
      outputSchema: _namesSchema,
      images: photos,
    );
  }

  /// Estimates the effective weight lifted in one rep of [exerciseName] by a
  /// person who weighs [bodyWeight] in [unit], returning null when the model
  /// cannot estimate it.
  Future<double?> estimateBodyweightLoad({
    required String exerciseName,
    required double bodyWeight,
    required WeightUnit unit,
  }) {
    final prompt =
        'Estimate the effective weight lifted in one rep of "$exerciseName" '
        'by a person who weighs ${bodyWeight.round()} ${unit.name}. This is '
        'the share of body weight the movement actually loads (for example a '
        'push-up loads roughly 65% of body weight). Return a single number in '
        '${unit.name}, or null if it cannot be estimated.';
    return _client.generateStructured(
      prompt: prompt,
      outputSchema: _weightSchema,
    );
  }

  /// Maps Claude's `{names: [...]}` output into a [List<String>].
  static final SchemanticType<List<String>> _namesSchema = SchemanticType.from(
    jsonSchema: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'names': <String, Object?>{
          'type': 'array',
          'items': <String, Object?>{'type': 'string'},
        },
      },
      'required': <String>['names'],
    },
    parse: (json) {
      final map = (json! as Map).cast<String, dynamic>();
      return (map['names'] as List).cast<String>();
    },
  );

  /// Maps Claude's `{weight: <number|null>}` output into a [double?].
  static final SchemanticType<double?> _weightSchema = SchemanticType.from(
    jsonSchema: <String, Object?>{
      'type': 'object',
      'properties': <String, Object?>{
        'weight': <String, Object?>{
          'type': <String>['number', 'null'],
        },
      },
      'required': <String>['weight'],
    },
    parse: (json) {
      final map = (json! as Map).cast<String, dynamic>();
      final weight = map['weight'];
      if (weight == null) return null;
      return (weight as num).toDouble();
    },
  );
}
