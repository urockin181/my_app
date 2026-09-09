/// A single ayah (verse) as returned live from the Quran API.
/// Text fields always come from the API response - never hardcoded in code.
class QuranVerse {
  const QuranVerse({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.arabicText,
    required this.translation,
  });

  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String arabicText;
  final String translation;

  String get reference => 'Surah $surahName $surahNumber:$ayahNumber';

  factory QuranVerse.fromSearchMatch({
    required Map<String, dynamic> match,
    required String translation,
  }) {
    final surah = match['surah'] as Map<String, dynamic>? ?? const {};
    return QuranVerse(
      surahNumber: (surah['number'] as num?)?.toInt() ?? 0,
      surahName: (surah['englishName'] as String?) ?? '',
      ayahNumber: (match['numberInSurah'] as num?)?.toInt() ?? 0,
      arabicText: '',
      translation: translation,
    );
  }
}
