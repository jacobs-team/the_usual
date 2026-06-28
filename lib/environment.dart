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

  static const _googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );

  static const _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// iOS OAuth client id for Google Sign-In, or null when not configured.
  static String? get googleIosClientId =>
      _googleIosClientId.isEmpty ? null : _googleIosClientId;

  /// Web/server OAuth client id for Google Sign-In. Only needed for an ID token
  /// or backend; null for the current client-only flow.
  static String? get googleServerClientId =>
      _googleServerClientId.isEmpty ? null : _googleServerClientId;
}
