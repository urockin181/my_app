/// A single hadith as returned live from the Hadith API.
/// Text and grade always come from the API response - never hardcoded.
class HadithResult {
  const HadithResult({
    required this.collection,
    required this.reference,
    required this.arabicText,
    required this.englishText,
    required this.grade,
  });

  final String collection;
  final String reference;
  final String arabicText;
  final String englishText;

  /// Raw grade string from the source (e.g. "Sahih", "Da'if"), or null if
  /// the source did not provide a grade for this hadith.
  final String? grade;
}
