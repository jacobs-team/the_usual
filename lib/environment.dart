// coverage:ignore-file

/// Environment values provided at build/run time.
///
/// See  `launch.json` which injects `env.json`
abstract class EnvironmentConfig {
  /// Base URL for the API.
  static const apiDomain = String.fromEnvironment(
    'API_DOMAIN',
    defaultValue: 'https://coffee.alexflipnote.dev',
  );

  /// Anthropic API key used by the in-app Genkit client to call Claude. Empty
  /// when not supplied; the AI client treats an empty key as "not configured".
  static const anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

  /// e.g prod, dev etc.
  static late final String environment;
}
