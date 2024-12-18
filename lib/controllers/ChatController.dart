import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  late IO.Socket socket;
  RxList<String> messages = <String>[].obs;
  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize the socket connection
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the Socket.IO server
    socket.connect();

    // Listen for incoming messages
    socket.on('newMessage', (data) {
      messages.add(data['message']);
    });
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }

  void sendMessage() {
    String message = messageController.text;
    if (message.isNotEmpty) {
      // Send a message to the server
      socket.emit('sendMessage', {
        'senderId': 'user1', // Sender ID (can be dynamic)
        'receiverId': 'user2', // Receiver ID (can be dynamic)
        'message': message,
      });
      messageController.clear();
    }
  }
}
