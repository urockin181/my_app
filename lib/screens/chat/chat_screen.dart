import 'package:flutter/material.dart';

import '../../config/api_keys.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/chat_message.dart';
import '../../services/gemini_service.dart';
import '../../services/hadith_service.dart';
import '../../services/quran_service.dart';
import 'widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messages = <ChatMessage>[];
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  late final GeminiService _geminiService;
  bool _isSending = false;
  bool _welcomeAdded = false;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(
      apiKey: ApiKeys.gemini,
      quranService: QuranService(),
      hadithService: HadithService(apiKey: ApiKeys.hadith),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(AppLocalizations l10n, String languageCode) async {
    final question = _inputController.text.trim();
    if (question.isEmpty || _isSending) return;

    setState(() {
      _messages.add(ChatMessage(sender: ChatSender.user, text: question));
      _isSending = true;
    });
    _inputController.clear();
    _scrollToBottom();

    if (!_geminiService.isConfigured) {
      setState(() {
        _messages.add(ChatMessage(
          sender: ChatSender.assistant,
          text: l10n.chatApiKeyMissing,
          isError: true,
        ));
        _isSending = false;
      });
      _scrollToBottom();
      return;
    }

    try {
      final answer = await _geminiService.answer(question, languageCode: languageCode);
      final text = answer.text.isEmpty ? l10n.chatNoInformation : answer.text;
      setState(() {
        _messages.add(ChatMessage(sender: ChatSender.assistant, text: text));
      });
    } catch (_) {
      setState(() {
        _messages.add(ChatMessage(
          sender: ChatSender.assistant,
          text: l10n.chatErrorGeneric,
          isError: true,
        ));
      });
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    if (!_welcomeAdded) {
      _welcomeAdded = true;
      _messages.add(ChatMessage(sender: ChatSender.assistant, text: l10n.chatWelcomeMessage));
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Text(
            l10n.chatDisclaimer,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_isSending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return ChatBubble(
                  message: ChatMessage(
                    sender: ChatSender.assistant,
                    text: l10n.chatSearching,
                  ),
                  isLoading: true,
                );
              }
              return ChatBubble(message: _messages[index]);
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(hintText: l10n.chatInputHint),
                    onSubmitted: (_) => _send(l10n, languageCode),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isSending ? null : () => _send(l10n, languageCode),
                  icon: const Icon(Icons.send),
                  tooltip: l10n.chatSend,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
