import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/quran_verse.dart';

/// Retrieves real Quran text from api.alquran.cloud (a free, public,
/// long-established Quran API - no API key required). This service never
/// contains any Quran text written by the app itself; every word shown to
/// the user comes directly from the API response.
class QuranService {
  static const _base = 'https://api.alquran.cloud/v1';

  /// Searches the Quran for [query] and returns up to [limit] matching
  /// verses with both Arabic text and a translation.
  ///
  /// [language] should be 'ar' or 'en' - it selects which translation
  /// edition is searched, matching the language the question was likely
  /// asked in.
  Future<List<QuranVerse>> search(
    String query, {
    required String language,
    int limit = 5,
  }) async {
    final searchEdition = language == 'ar' ? 'quran-uthmani' : 'en.sahih';
    final searchUri = Uri.parse(
      '$_base/search/${Uri.encodeComponent(query)}/all/$searchEdition',
    );

    final response = await http.get(searchUri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return const [];

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>?;
    final matches = (data?['matches'] as List?) ?? const [];
    if (matches.isEmpty) return const [];

    final results = <QuranVerse>[];
    for (final raw in matches.take(limit)) {
      final match = raw as Map<String, dynamic>;
      final surah = match['surah'] as Map<String, dynamic>? ?? const {};
      final surahNumber = (surah['number'] as num?)?.toInt();
      final ayahNumber = (match['numberInSurah'] as num?)?.toInt();
      if (surahNumber == null || ayahNumber == null) continue;

      final verse = await _fetchWithBothTexts(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: (surah['englishName'] as String?) ?? '',
      );
      if (verse != null) results.add(verse);
    }
    return results;
  }

  Future<QuranVerse?> _fetchWithBothTexts({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final reference = '$surahNumber:$ayahNumber';
    final uri = Uri.parse(
      '$_base/ayah/$reference/editions/quran-uthmani,en.sahih',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final editions = (body['data'] as List?) ?? const [];
    if (editions.isEmpty) return null;

    String arabic = '';
    String translation = '';
    String resolvedSurahName = surahName;
    for (final raw in editions) {
      final edition = raw as Map<String, dynamic>;
      final editionInfo = edition['edition'] as Map<String, dynamic>? ?? const {};
      final identifier = editionInfo['identifier'] as String?;
      final text = (edition['text'] as String?) ?? '';
      final surah = edition['surah'] as Map<String, dynamic>?;
      if (surah != null && surah['englishName'] is String) {
        resolvedSurahName = surah['englishName'] as String;
      }
      if (identifier == 'quran-uthmani') {
        arabic = text;
      } else if (identifier == 'en.sahih') {
        translation = text;
      }
    }

    if (arabic.isEmpty && translation.isEmpty) return null;

    return QuranVerse(
      surahNumber: surahNumber,
      surahName: resolvedSurahName,
      ayahNumber: ayahNumber,
      arabicText: arabic,
      translation: translation,
    );
  }
}
