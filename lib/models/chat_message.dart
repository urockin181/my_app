import 'hadith_result.dart';
import 'quran_verse.dart';

enum ChatSender { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.sender,
    required this.text,
    this.isError = false,
    this.quranSources = const [],
    this.hadithSources = const [],
  });

  final ChatSender sender;
  final String text;
  final bool isError;

  /// Raw, unmodified verses/hadith used to ground this answer - shown
  /// verbatim in the UI so the user can verify the exact source text
  /// independent of the AI's own prose.
  final List<QuranVerse> quranSources;
  final List<HadithResult> hadithSources;
}
