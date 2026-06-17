// coverage:ignore-file
// Thin wrapper over the Genkit/Anthropic SDK that owns the live network
// connection; it has no unit-testable logic apart from SDK calls.
import 'dart:convert';
import 'dart:typed_data';

import 'package:genkit/genkit.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';
import 'package:injectable/injectable.dart';
import 'package:schemantic/schemantic.dart';
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

  /// Temperature 0 keeps nutrition estimates as accurate and repeatable as
  /// possible across identical inputs.
  static final AnthropicOptions _options = AnthropicOptions(temperature: 0);

  /// Whether an Anthropic API key has been supplied at build time.
  bool get isConfigured => EnvironmentConfig.anthropicApiKey.isNotEmpty;

  /// Sends [prompt] to Claude and returns the response text.
  Future<String> generateText(String prompt) async {
    final response = await _ai.generate<AnthropicOptions, dynamic>(
      model: _model,
      config: _options,
      prompt: prompt,
    );
    return response.text;
  }

  /// Sends [prompt] to Claude and returns its response parsed into [T] using
  /// [outputSchema]. Genkit constrains the model to the schema and maps the
  /// resulting JSON into [T]. Throws when the model returns no structured
  /// output.
  ///
  /// When [image] is supplied the request becomes multimodal: the prompt and
  /// the image are sent together as a single user message so Claude can read
  /// the picture. [imageMediaType] is the image's MIME type and must be one
  /// Claude accepts (`image/jpeg`, `image/png`, `image/gif`, or `image/webp`).
  Future<T> generateStructured<T>({
    required String prompt,
    required SchemanticType<T> outputSchema,
    Uint8List? image,
    String imageMediaType = 'image/jpeg',
  }) async {
    List<Message>? messages;
    if (image != null) {
      final dataUrl = 'data:$imageMediaType;base64,${base64Encode(image)}';
      messages = [
        Message(
          role: Role.user,
          content: [
            TextPart(text: prompt),
            MediaPart(
              media: Media(contentType: imageMediaType, url: dataUrl),
            ),
          ],
        ),
      ];
    }

    final response = await _ai.generate<AnthropicOptions, T>(
      model: _model,
      config: _options,
      prompt: image == null ? prompt : null,
      messages: messages,
      outputSchema: outputSchema,
    );
    final output = response.output;
    if (output == null) {
      throw StateError('Claude returned no structured output for the request.');
    }
    return output;
  }
}
