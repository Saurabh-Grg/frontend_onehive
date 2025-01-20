class Message {
  final int messageId;
  final String message;
  final String? fileUrl;  // This can be null, no fallback needed
  final String messageType;
  final int senderId;
  final int receiverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  Message({
    required this.messageId,
    required this.message,
    this.fileUrl,  // fileUrl is nullable, so no default fallback needed
    required this.messageType,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] ?? 0, // Default to 0 if null
      message: json['message'] ?? '',     // Default to empty string if null
      fileUrl: json['fileUrl'],           // fileUrl can be null, no fallback needed
      messageType: json['messageType'] ?? '',  // Default to empty string if null
      senderId: json['senderId'] ?? 0,   // Default to 0 if null
      receiverId: json['receiverId'] ?? 0, // Default to 0 if null
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Default to current DateTime if null
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(), // Default to current DateTime if null
    );
  }

  // Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'message': message,
      'fileUrl': fileUrl,  // This can be null
      'messageType': messageType,
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
