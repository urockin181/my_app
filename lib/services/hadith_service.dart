import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/hadith_result.dart';

/// Retrieves real Hadith text and authenticity grading from hadithapi.com
/// (a free API - get a key at https://hadithapi.com/register). This service
/// never contains any hadith text written by the app itself; every word
/// shown to the user comes directly from the API response.
///
/// hadithapi.com's exact response shape can change between API versions.
/// If searches stop returning results, check the current docs at
/// https://hadithapi.com/docs and adjust the field names read in
/// [_parseHadith] below.
class HadithService {
  HadithService({required this.apiKey});

  final String apiKey;
  static const _base = 'https://hadithapi.com/api/hadiths';

  bool get isConfigured => apiKey.isNotEmpty;

  Future<List<HadithResult>> search(String query, {int limit = 5}) async {
    if (!isConfigured) return const [];

    final uri = Uri.parse(_base).replace(queryParameters: {
      'apiKey': apiKey,
      'hadithEnglish': query,
      'paginate': '$limit',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return const [];

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = _extractHadithList(body);
    if (list == null) return const [];

    return list
        .whereType<Map<String, dynamic>>()
        .map(_parseHadith)
        .whereType<HadithResult>()
        .take(limit)
        .toList();
  }

  List<dynamic>? _extractHadithList(Map<String, dynamic> body) {
    final hadiths = body['hadiths'];
    if (hadiths is Map<String, dynamic> && hadiths['data'] is List) {
      return hadiths['data'] as List;
    }
    if (body['data'] is List) return body['data'] as List;
    return null;
  }

  HadithResult? _parseHadith(Map<String, dynamic> raw) {
    final arabic = (raw['hadithArabic'] as String?)?.trim() ?? '';
    final english = (raw['hadithEnglish'] as String?)?.trim() ?? '';
    if (arabic.isEmpty && english.isEmpty) return null;

    final book = raw['book'] as Map<String, dynamic>?;
    final collection = (book?['bookName'] as String?) ??
        (raw['bookSlug'] as String?) ??
        'Unknown collection';
    final number = (raw['hadithNumber'] as String?) ??
        (raw['hadithNumber'] as num?)?.toString() ??
        '';

    return HadithResult(
      collection: collection,
      reference: number.isEmpty ? collection : '$collection #$number',
      arabicText: arabic,
      englishText: english,
      grade: (raw['status'] as String?)?.trim(),
    );
  }
}
