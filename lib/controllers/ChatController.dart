// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:onehive_frontend/constants/apis_endpoints.dart';
// import 'dart:convert';
//
// import '../models/Message.dart';
//
//
// class ChatController extends GetxController {
//   var messages = <Message>[].obs; // Observable list for Message objects
//
//   Future<void> fetchMessages(int senderId, int receiverId) async {
//     print('Fetching messages for senderId: $senderId, receiverId: $receiverId'); // Debugging line
//
//     try {
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.baseUrl}messages/get?senderId=$senderId&receiverId=$receiverId'),
//       ); // Increase timeout duration
//
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//
//         if (data.isEmpty) {
//           print('No messages found for senderId: $senderId, receiverId: $receiverId'); // Debugging line
//         }
//
//         // Map the fetched data to Message objects and assign to messages list
//         messages.assignAll(data.map((msg) => Message.fromJson(msg)).toList());
//
//         print('Messages fetched: ${messages.length}'); // Debugging line
//       } else {
//         print('Failed to load messages with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching messages: $e'); // Handle any errors
//     }
//   }
//
//   // Send message logic (if needed)
//   void sendMessage(int senderId, int receiverId, String message) {
//     print('Sending message: $message to receiverId: $receiverId'); // Debugging line
//     // Here you can send the message to the server using your SocketService
//   }
// }

import 'package:get/get.dart';
import 'package:onehive_frontend/models/Message.dart';

class ChatController extends GetxController {
  // List of messages
  final messages = <Message>[].obs;

  // Load initial messages (e.g., message history)
  void loadInitialMessages(List<Message> initialMessages) {
    messages.assignAll(initialMessages);
  }

  // Add a new message to the list
  void addMessage(Message message) {
    print('Adding new message: ${message.toJson()}');
    messages.add(message);
  }
}
