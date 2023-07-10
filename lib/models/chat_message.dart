import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage(
      {required this.senderId,
      required this.type,
      required this.content,
      required this.sentTime});

  factory ChatMessage.fromJSON(Map<String, dynamic> _json) {
    MessageType _messageType;
    switch (_json["type"]) {
      case "text":
        _messageType = MessageType.TEXT;
        break;
      case "image":
        _messageType = MessageType.IMAGE;
        break;
      default:
        _messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(
      senderId: _json["senderId"],
      type: _messageType,
      content: _json["content"],
      sentTime: _json["sentTime"].toDate(),
    );
  }
  Map<String, dynamic> toJson() {
    String _messageType;
    switch (type) {
      case MessageType.TEXT:
        _messageType = "text";
        break;
      case MessageType.IMAGE:
        _messageType = "image";
        break;
      default:
        _messageType = "";
    }
    return {
      "senderId": senderId,
      "type": _messageType,
      "content": content,
      "sentTime": Timestamp.fromDate(sentTime),
    };
  }
}
