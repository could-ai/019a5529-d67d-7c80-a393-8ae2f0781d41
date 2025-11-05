class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  
  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });
}

enum MessageType {
  text,
  command,
  error,
  system,
}