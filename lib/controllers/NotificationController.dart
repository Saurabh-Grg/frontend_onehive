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
      print('[DEBUG] fetchNotifications called with userId: $userId');

      // Construct the API endpoint and log it
      final url = 'http://localhost:3000/api/notifications/$userId';
      print('[DEBUG] API URL: $url');

      // Make the API call
      final response = await http.get(Uri.parse(url));

      // Log the response status code
      print('[DEBUG] Response Status Code: ${response.statusCode}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode and log the response body
        List data = json.decode(response.body);
        print('[DEBUG] Response Body: $data');

        // Parse the notifications and update the state
        notifications.value = data.map((e) => NotificationModel.fromJson(e)).toList();
        print('[DEBUG] Notifications parsed successfully');
      } else {
        // Log the error status and response
        print('[ERROR] Failed to load notifications. Status Code: ${response.statusCode}');
        print('[ERROR] Response Body: ${response.body}');
        Get.snackbar('Error', 'Failed to load notifications');
      }
    } catch (e) {
      // Log the exception details
      print('[EXCEPTION] Error occurred: $e');
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      // Stop loading and log the state
      isLoading.value = false;
      print('[DEBUG] fetchNotifications completed. isLoading set to false');
    }
  }


  void markAsRead(int notificationId) {
    // Mark a notification as read in the backend or locally
    final index = notifications.indexWhere((n) => n.notification_id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationModel(
        notification_id: notifications[index].notification_id,
        message: notifications[index].message,
        isRead: true,
        createdAt: notifications[index].createdAt,
      );
      notifications.refresh();
    }
  }
}
