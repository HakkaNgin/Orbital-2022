enum ChatMessageType {text, audio, image, video}
enum MessageStatus {not_sent, not_view, viewed}

class ChatMessage {
  final String text;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;

  ChatMessage({
    this.text = '',
    required this.messageType,
    required this.messageStatus,
    required this.isSender,
  });
}

List demoChatMessges = [
  ChatMessage (
    text: "Hello",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: false,
  ),
  ChatMessage (
    text: "KISS KISS",
    messageType: ChatMessageType.text,
    messageStatus: MessageStatus.viewed,
    isSender: true,
  ),
];
