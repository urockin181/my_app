import 'package:flutter/material.dart';

import '../../../models/chat_message.dart';

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

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
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
    );
  }
}
