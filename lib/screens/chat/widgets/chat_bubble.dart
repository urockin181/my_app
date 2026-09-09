import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/chat_message.dart';
import '../../../models/hadith_result.dart';
import '../../../models/quran_verse.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, this.isLoading = false});

  final ChatMessage message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.sender == ChatSender.user;

    final bubbleColor = isUser
        ? scheme.primary
        : message.isError
            ? scheme.errorContainer
            : scheme.surfaceContainerHigh;
    final textColor = isUser
        ? scheme.onPrimary
        : message.isError
            ? scheme.onErrorContainer
            : scheme.onSurface;

    final hasSources = message.quranSources.isNotEmpty || message.hadithSources.isNotEmpty;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                      ),
                      const SizedBox(width: 10),
                      Flexible(child: Text(message.text, style: TextStyle(color: textColor))),
                    ],
                  )
                : Text(message.text, style: TextStyle(color: textColor, height: 1.4)),
          ),
          if (!isLoading && hasSources)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: _SourcesPanel(message: message),
            ),
        ],
      ),
    );
  }
}

class _SourcesPanel extends StatelessWidget {
  const _SourcesPanel({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final count = message.quranSources.length + message.hadithSources.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: scheme.surfaceContainerLow,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          title: Text(
            l10n.chatSourcesTitle('$count'),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          children: [
            Text(
              l10n.chatSourcesVerifyNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.outline),
            ),
            const SizedBox(height: 12),
            for (final verse in message.quranSources) _QuranSourceCard(verse: verse),
            for (final hadith in message.hadithSources) _HadithSourceCard(hadith: hadith),
          ],
        ),
      ),
    );
  }
}

class _QuranSourceCard extends StatelessWidget {
  const _QuranSourceCard({required this.verse});

  final QuranVerse verse;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 6),
          if (verse.arabicText.isNotEmpty)
            Text(
              verse.arabicText,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
            ),
          if (verse.translation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              verse.translation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.outline),
            ),
          ],
        ],
      ),
    );
  }
}

class _HadithSourceCard extends StatelessWidget {
  const _HadithSourceCard({required this.hadith});

  final HadithResult hadith;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final grade = hadith.grade;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hadith.reference,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 6),
          if (hadith.arabicText.isNotEmpty)
            Text(
              hadith.arabicText,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
            ),
          if (hadith.englishText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              hadith.englishText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.outline),
            ),
          ],
          if (grade != null) ...[
            const SizedBox(height: 6),
            Chip(
              label: Text(l10n.chatHadithGradeLabel(grade)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ],
      ),
    );
  }
}
