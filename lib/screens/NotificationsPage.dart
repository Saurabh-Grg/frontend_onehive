import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/NotificationController.dart';
import '../controllers/UserController.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationController controller = Get.find();

  NotificationsPage({Key? key}) : super(key: key) {
    _markAllAsRead(); // Automatically mark all notifications as read
  }

  void _markAllAsRead() {
    final userController = Get.find<UserController>();
    final userId = int.tryParse(userController.userId.value);
    if (userId != null) {
      controller.markAllAsRead(userId);
    } else {
      Get.snackbar('Error', 'User ID not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold),),
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
                // You can define specific actions for individual notifications if needed
              },
            );
          },
        );
      }),
    );
  }
}
