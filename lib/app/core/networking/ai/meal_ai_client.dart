import 'package:genkit/genkit.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/environment.dart';

/// {@template meal_ai_client}
/// Wraps a [Genkit] instance configured with the Anthropic (Claude) plugin.
///
/// This is the AI analog of the REST client: it owns the connection to the
/// model provider and exposes a single text-generation entry point.
/// `genkit_anthropic` manages its own HTTP transport, so these calls do not go
/// through Dio. The Anthropic API key comes from [EnvironmentConfig]; when it
/// is empty the client reports [isConfigured] as false so callers can surface a
/// setup message instead of calling Claude.
/// {@endtemplate}
@singleton
class MealAiClient {
  /// {@macro meal_ai_client}
  MealAiClient()
    : _ai = Genkit(
        plugins: [anthropic(apiKey: EnvironmentConfig.anthropicApiKey)],
      );

  final Genkit _ai;

  /// The Claude model used for meal extraction.
  static final ModelRef<AnthropicOptions> _model = anthropic.model(
    'claude-sonnet-4-6',
  );

  /// Whether an Anthropic API key has been supplied at build time.
  bool get isConfigured => EnvironmentConfig.anthropicApiKey.isNotEmpty;

  /// Sends [prompt] to Claude and returns the response text.
  Future<String> generateText(String prompt) async {
    final response = await _ai.generate<AnthropicOptions, dynamic>(
      model: _model,
      prompt: prompt,
    );
    return response.text;
  }
}
