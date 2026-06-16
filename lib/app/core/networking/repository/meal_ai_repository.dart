import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_ai_repository}
/// Coordinates AI-assisted meal entry.
///
/// Phase 1 exposes a plain text round-trip used to verify the Claude
/// connection end to end. Later phases add structured extraction of a meal's
/// name, quantity, and nutrition from a description or photo, parsed into
/// domain models before reaching a bloc.
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
}
