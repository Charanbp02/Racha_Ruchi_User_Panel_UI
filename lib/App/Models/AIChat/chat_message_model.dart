class ChatMessageModel {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final String? imageUrl;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.index,
      'imageUrl': imageUrl,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      message: json['message'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values[json['status']],
      imageUrl: json['imageUrl'],
    );
  }
}

enum MessageStatus { sending, sent, error }
