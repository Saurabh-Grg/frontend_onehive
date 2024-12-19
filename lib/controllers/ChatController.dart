// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;
// //
// // class ChatController extends GetxController {
// //   late IO.Socket socket;
// //   RxList<String> messages = <String>[].obs;
// //   TextEditingController messageController = TextEditingController();
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // Initialize the socket connection
// //     socket = IO.io('http://localhost:3000', <String, dynamic>{
// //       'transports': ['websocket'],
// //       'autoConnect': false,
// //     });
// //
// //     // Connect to the Socket.IO server
// //     socket.connect();
// //
// //     // Listen for incoming messages
// //     socket.on('newMessage', (data) {
// //       messages.add(data['message']);
// //     });
// //   }
// //
// //   @override
// //   void onClose() {
// //     socket.dispose();
// //     super.onClose();
// //   }
// //
// //   void sendMessage() {
// //     String message = messageController.text;
// //     if (message.isNotEmpty) {
// //       // Send a message to the server
// //       socket.emit('sendMessage', {
// //         'senderId': 'user1', // Sender ID (can be dynamic)
// //         'receiverId': 'user2', // Receiver ID (can be dynamic)
// //         'message': message,
// //       });
// //       messageController.clear();
// //     }
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class ChatController extends GetxController {
//   late IO.Socket socket;
//   RxList<String> messages = <String>[].obs;
//   TextEditingController messageController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize the socket connection
//     socket = IO.io('http://localhost:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     // Connect to the Socket.IO server
//     socket.connect();
//
//     // Listen for incoming messages
//     socket.on('newMessage', (data) {
//       messages.add(data['message']);
//     });
//
//     // Add sample messages for demo purposes
//     _loadSampleMessages();
//   }
//
//   @override
//   void onClose() {
//     socket.dispose();
//     super.onClose();
//   }
//
//   void sendMessage() {
//     String message = messageController.text;
//     if (message.isNotEmpty) {
//       // Send a message to the server
//       socket.emit('sendMessage', {
//         'senderId': 'user1', // Sender ID (can be dynamic)
//         'receiverId': 'user2', // Receiver ID (can be dynamic)
//         'message': message,
//       });
//       messageController.clear();
//     }
//   }
//
//   // Method to load sample messages
//   void _loadSampleMessages() {
//     messages.addAll([
//       "Hello! How are you?",
//       "I'm good, thanks! How about you?",
//       "I'm doing great, just working on some code.",
//       "That's awesome! What are you coding?",
//       "A real-time chat app, just like this one!",
//       "That sounds cool. Good luck with your project!",
//     ]);
//   }
// }

import 'package:get/get.dart';
import '../services/SocketService.dart';

class ChatController extends GetxController {
  final SocketService socketService = Get.find();
  var messages = <String>[].obs;
  var receiverId = 1; // Replace with actual receiver ID

  // Send a message using the SocketService
  void sendMessage(String message) {
    socketService.sendMessage(receiverId, message);
    messages.add('Me: $message');  // Add to local chat view
  }

  // Listen for incoming messages
  void listenForMessages() {
    socketService.socket.on('receiveMessage', (data) {
      messages.add('Received: ${data['message']}');
    });
  }
}
