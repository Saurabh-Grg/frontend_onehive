class Message {
  final int messageId;
  final String message;
  final String? fileUrl;
  final String messageType;
  final int senderId;
  final int receiverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.messageId,
    required this.message,
    this.fileUrl,
    required this.messageType,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      message: json['message'],
      fileUrl: json['fileUrl'],
      messageType: json['messageType'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'message': message,
      'fileUrl': fileUrl,
      'messageType': messageType,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}