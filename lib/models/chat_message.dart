enum ChatSender { user, assistant }

class ChatMessage {
  const ChatMessage({
    required this.sender,
    required this.text,
    this.isError = false,
  });

  final ChatSender sender;
  final String text;
  final bool isError;
}
