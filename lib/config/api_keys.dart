/// API keys are passed in at build/run time via --dart-define so they are
/// never committed to source control. See README.md for how to get free
/// keys and pass them in, e.g.:
///
///   flutter run \
///     --dart-define=GEMINI_API_KEY=your_key \
///     --dart-define=HADITH_API_KEY=your_key
class ApiKeys {
  ApiKeys._();

  static const gemini = String.fromEnvironment('GEMINI_API_KEY');
  static const hadith = String.fromEnvironment('HADITH_API_KEY');
}
