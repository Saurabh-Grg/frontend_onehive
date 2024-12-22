import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/NotificationModel.dart';
import 'UserController.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchNotifications(int userId) async {
    try {
      // Start loading and log the user ID
      isLoading.value = true;
      // Construct the API endpoint and log it
      final url = 'http://localhost:3000/api/notifications/$userId';

      // Make the API call
      final response = await http.get(Uri.parse(url));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode and log the response body
        List data = json.decode(response.body);

        // Parse the notifications and update the state
        notifications.value = data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load notifications');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      // Stop loading and log the state
      isLoading.value = false;
    }
  }


  Future<void> markAllAsRead(int userId) async {
    try {
      isLoading.value = true;
      final url = 'http://localhost:3000/api/notifications/user/$userId/readAll';
      final response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        // Update all notifications locally
        notifications.value = notifications.map((n) {
          return NotificationModel(
            notification_id: n.notification_id,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
          );
        }).toList();
        notifications.refresh(); // Refresh the observable list
        Get.snackbar('Success', 'All notifications marked as read');
      } else {
        Get.snackbar('Error', 'Failed to mark notifications as read');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
