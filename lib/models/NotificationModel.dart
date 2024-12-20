class NotificationModel {
  final int notification_id;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notification_id,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notification_id: json['notification_id'],
      message: json['message'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}