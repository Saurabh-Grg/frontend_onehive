import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Message.dart';


class ChatController extends GetxController {
  var messages = <Message>[].obs; // Observable list for Message objects

  Future<void> fetchMessages(int senderId, int receiverId) async {
    print('Fetching messages for senderId: $senderId, receiverId: $receiverId'); // Debugging line

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/messages/get?senderId=$senderId&receiverId=$receiverId'),
      ); // Increase timeout duration


      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          print('No messages found for senderId: $senderId, receiverId: $receiverId'); // Debugging line
        }

        // Map the fetched data to Message objects and assign to messages list
        messages.assignAll(data.map((msg) => Message.fromJson(msg)).toList());

        print('Messages fetched: ${messages.length}'); // Debugging line
      } else {
        print('Failed to load messages with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e'); // Handle any errors
    }
  }

  // Send message logic (if needed)
  void sendMessage(int senderId, int receiverId, String message) {
    print('Sending message: $message to receiverId: $receiverId'); // Debugging line
    // Here you can send the message to the server using your SocketService
  }
}