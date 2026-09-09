import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/hadith_result.dart';
import '../models/quran_verse.dart';
import 'hadith_service.dart';
import 'quran_service.dart';

class ChatbotAnswer {
  const ChatbotAnswer({
    required this.text,
    required this.hasSources,
    required this.quranSources,
    required this.hadithSources,
  });

  final String text;
  final bool hasSources;

  /// The raw, unmodified verses/hadith actually used to ground this answer
  /// - straight from the API, never touched by the model - so the app can
  /// show them verbatim alongside Gemini's prose for independent
  /// verification, since Quran accuracy must never depend solely on an
  /// LLM's ability to quote correctly.
  final List<QuranVerse> quranSources;
  final List<HadithResult> hadithSources;
}

/// Orchestrates the chatbot: retrieves real Quran/Hadith text (see
/// [QuranService] and [HadithService]) and asks Gemini (free tier, see
/// https://ai.google.dev) to compose an answer strictly grounded in that
/// retrieved text. Gemini is never asked to answer from its own general
/// knowledge of Islam - only from the sources handed to it in the prompt.
///
/// Model name: 'gemini-3.6-flash' - the free-tier Flash model Google's own
/// API currently points to (gemini-2.0-flash was retired). If this model is
/// later renamed/retired too, the API error message names the current
/// replacement directly - update [_modelName] to match, or check
/// https://ai.google.dev/gemini-api/docs/models for the current free tier.
class GeminiService {
  GeminiService({
    required String apiKey,
    required QuranService quranService,
    required HadithService hadithService,
  })  : _apiKey = apiKey,
        _quranService = quranService,
        _hadithService = hadithService;

  static const _modelName = 'gemini-3.6-flash';

  final String _apiKey;
  final QuranService _quranService;
  final HadithService _hadithService;

  bool get isConfigured => _apiKey.isNotEmpty;

  GenerativeModel _model() => GenerativeModel(model: _modelName, apiKey: _apiKey);

  /// Gemini's free tier occasionally returns a transient 503 "high demand"
  /// error. Retrying a couple of times with a short delay resolves this in
  /// most cases without the user needing to manually retry.
  Future<GenerateContentResponse> _generateWithRetry(String prompt) async {
    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await _model().generateContent([Content.text(prompt)]);
      } on ServerException catch (e) {
        debugPrint('Gemini server error (attempt $attempt/$maxAttempts): $e');
        if (attempt == maxAttempts) rethrow;
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }
    throw StateError('unreachable');
  }

  /// Step 1: ask Gemini to turn the free-form question into a few short
  /// search keywords, since the Quran/Hadith sources only support literal
  /// keyword search, not semantic search.
  Future<List<String>> _extractKeywords(String question, String languageName) async {
    final prompt = '''
Extract 1 to 3 short search keywords (single words or very short phrases,
in $languageName) that would help find relevant Quran verses or Hadith
about the following question. Reply with ONLY the keywords separated by
commas and nothing else - no numbering, no explanation.

Question: $question
''';
    final response = await _generateWithRetry(prompt);
    final raw = response.text?.trim() ?? '';
    if (raw.isEmpty) return [question];
    return raw
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .take(3)
        .toList();
  }

  Future<ChatbotAnswer> answer(String question, {required String languageCode}) async {
    final languageName = languageCode == 'ar' ? 'Arabic' : 'English';

    final keywords = await _extractKeywords(question, languageName);

    final quranResults = <QuranVerse>[];
    final hadithResults = <HadithResult>[];
    for (final keyword in keywords) {
      try {
        quranResults.addAll(
          await _quranService.search(keyword, language: languageCode, limit: 3),
        );
      } catch (e) {
        // A single failed lookup shouldn't abort the whole answer.
        debugPrint('Quran lookup failed for "$keyword": $e');
      }
      try {
        if (_hadithService.isConfigured) {
          hadithResults.addAll(await _hadithService.search(keyword, limit: 3));
        }
      } catch (e) {
        debugPrint('Hadith lookup failed for "$keyword": $e');
      }
      if (quranResults.length >= 5 && hadithResults.length >= 5) break;
    }

    final hasSources = quranResults.isNotEmpty || hadithResults.isNotEmpty;

    final context = _buildContext(quranResults, hadithResults);
    final prompt = _buildPrompt(
      question: question,
      context: context,
      languageName: languageName,
      hasSources: hasSources,
    );

    final response = await _generateWithRetry(prompt);
    final text = response.text?.trim() ?? '';

    return ChatbotAnswer(
      text: text,
      hasSources: hasSources,
      quranSources: quranResults,
      hadithSources: hadithResults,
    );
  }

  String _buildContext(List<QuranVerse> quran, List<HadithResult> hadith) {
    final buffer = StringBuffer();

    if (quran.isEmpty && hadith.isEmpty) {
      return '(No matching Quran verses or Hadith were found for this question.)';
    }

    for (final verse in quran) {
      buffer.writeln('--- Quran ${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber} ---');
      buffer.writeln('Arabic: ${verse.arabicText}');
      buffer.writeln('Translation: ${verse.translation}');
      buffer.writeln();
    }

    for (final h in hadith) {
      buffer.writeln('--- Hadith: ${h.reference} ---');
      if (h.arabicText.isNotEmpty) buffer.writeln('Arabic: ${h.arabicText}');
      if (h.englishText.isNotEmpty) buffer.writeln('English: ${h.englishText}');
      buffer.writeln('Grade: ${h.grade ?? "not provided by source"}');
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _buildPrompt({
    required String question,
    required String context,
    required String languageName,
    required bool hasSources,
  }) {
    return '''
You are an assistant inside an Islamic app called Muslim Guide. You answer
questions ONLY using the Quran verses and Hadith provided below under
"SOURCES". Do not use any other knowledge, even if you know the answer -
only use what is written in SOURCES.

Rules:
1. If SOURCES contains material that actually answers the question, write a
   clear, respectful answer in $languageName, and explicitly cite what you
   used (Surah name and verse number, or Hadith collection and number).
2. Quran accuracy is absolutely critical. When quoting Quran text, copy the
   Arabic exactly character-for-character from SOURCES - never paraphrase,
   summarize, retranslate, or reconstruct a verse from memory, even
   partially. If you are not fully certain a verse in SOURCES answers the
   question, say so rather than stretching its meaning to fit.
3. If any Hadith you cite has a Grade listed, state that grade in the
   answer (e.g. "this is graded Sahih/authentic" or "this is graded
   Da'if/weak"). If the grade says "not provided by source", say the
   grade is not available rather than guessing.
4. If SOURCES does not contain anything that actually answers the
   question, reply in $languageName with a short, honest message saying
   you don't have information about this from the Quran or Hadith sources
   available to you, and suggest the user consult a qualified scholar. Do
   not make up an answer.
5. Keep the tone warm, humble, and respectful of the religion. Never issue
   personal religious rulings (fatwas) - only relay what the sources say.

SOURCES:
$context

QUESTION: $question
''';
  }
}
