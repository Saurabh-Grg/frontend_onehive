import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/NotificationController.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return Center(child: Text('No notifications'));
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              title: Text(notification.message),
              subtitle: Text(notification.createdAt.toString()),
              trailing: notification.isRead
                  ? Icon(Icons.check, color: Colors.green)
                  : Icon(Icons.mark_email_unread, color: Colors.blue),
              onTap: () {
                // Mark as read
                controller.markAsRead(notification.notification_id);
              },
            );
          },
        );
      }),
    );
  }
}
