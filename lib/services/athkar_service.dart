import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/athkar_item.dart';

enum AthkarTarget { morning, evening }

/// Retrieves real Athkar (morning/evening remembrance) text from
/// hisnmuslim.com's public per-chapter JSON API. No dhikr text is ever
/// written by the app itself - everything shown comes from the source.
///
/// hisnmuslim.com organizes content into numbered chapters rather than
/// named ones, and the exact chapter number for "morning" / "evening"
/// athkar isn't documented in a stable, guessable way. Instead of hardcoding
/// a chapter number (which could silently point at the wrong chapter if
/// this app's guess is wrong), this service scans the first
/// [_scanRange] chapters and picks whichever chapter's own "category"
/// field actually contains the Arabic word for "morning" (الصباح) or
/// "evening" (المساء), then remembers that chapter number for next time.
/// If hisnmuslim.com ever restructures its numbering, this keeps working
/// automatically; if the site becomes unreachable, [fetch] throws and the
/// screen shows a retry state rather than any invented content.
class AthkarService {
  static const _base = 'https://www.hisnmuslim.com/api';
  static const _scanRange = 30;
  static const _prefsKeyPrefix = 'athkar_chapter_';

  Future<List<AthkarItem>> fetch(AthkarTarget target, {required String languageCode}) async {
    final chapter = await _resolveChapter(target);
    final langPath = languageCode == 'ar' ? 'ar' : 'eng';
    final json = await _fetchChapter(langPath, chapter);
    if (json == null) {
      throw Exception('Could not load Athkar chapter $chapter');
    }
    return _parseItems(json);
  }

  Future<int> _resolveChapter(AthkarTarget target) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_prefsKeyPrefix${target.name}';
    final cached = prefs.getInt(cacheKey);
    if (cached != null) {
      final json = await _fetchChapter('ar', cached);
      if (json != null && _matchesTarget(json, target)) return cached;
    }

    for (var chapter = 1; chapter <= _scanRange; chapter++) {
      final json = await _fetchChapter('ar', chapter);
      if (json != null && _matchesTarget(json, target)) {
        await prefs.setInt(cacheKey, chapter);
        return chapter;
      }
    }

    throw Exception('Could not locate ${target.name} Athkar chapter');
  }

  bool _matchesTarget(Map<String, dynamic> json, AthkarTarget target) {
    final category = (json['category'] as String?) ?? '';
    final keyword = target == AthkarTarget.morning ? 'الصباح' : 'المساء';
    return category.contains(keyword);
  }

  Future<Map<String, dynamic>?> _fetchChapter(String langPath, int chapter) async {
    final uri = Uri.parse('$_base/$langPath/$chapter.json');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        debugPrint('Athkar fetch $uri returned HTTP ${response.statusCode}');
        return null;
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Athkar fetch $uri failed: $e');
      return null;
    }
  }

  List<AthkarItem> _parseItems(Map<String, dynamic> json) {
    final array = (json['array'] as List?) ?? const [];
    return array.whereType<Map<String, dynamic>>().map((raw) {
      final text = (raw['top'] as String?)?.trim() ?? '';
      final reference = (raw['bottom'] as String?)?.trim() ?? '';
      final countRaw = raw['count'];
      final count = int.tryParse(countRaw?.toString() ?? '') ?? 1;
      return AthkarItem(text: text, reference: reference, repeatCount: count <= 0 ? 1 : count);
    }).where((item) => item.text.isNotEmpty).toList();
  }
}
