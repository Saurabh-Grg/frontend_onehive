import 'dart:async';

import 'package:get/get.dart';
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:onehive_frontend/controllers/ChatController.dart';
import 'package:onehive_frontend/models/Message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;
  Timer? typingTimer; // Timer for managing "stop_typing" timeout
  int? userId;  // Store userId

  // Initialize Socket connection
  void connect(int senderId, int receiverId) {
    socket = IO.io(ApiEndpoints.messageBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    // Register the userId with the server
    // Register the specific chat room between sender and receiver
    socket?.onConnect((_) {
      socket?.emit('join_chat', {
        'senderId': senderId,
        'receiverId': receiverId,
      });
      print('Connected and joined chat room between senderId: $senderId and receiverId: $receiverId');
    });

    // Listen for the message history
    socket?.on('message_history', (data) {
      final chatController = Get.find<ChatController>();
      final messages = (data as List).map((messageData) {
        return Message.fromJson(messageData);
      }).toList();
      chatController.loadInitialMessages(messages);
    });

    // Listen for incoming messages
    socket?.on('receive_message', (data) {
      print('Message received: ${data['message']} from senderId: ${data['senderId']}');
      final chatController = Get.find<ChatController>();

      try {
        final newMessage = Message.fromJson(data);
        chatController.addMessage(newMessage);
      } catch (e) {
        print('Error parsing message: $e');
      }
    });

    // Listen for typing status
    socket?.on('typing', (data) {
      final chatController = Get.find<ChatController>();
      final senderId = data['senderId'];
      final isTyping = data['isTyping'];

      // Update UI to show typing status for the receiver
      chatController.updateTypingStatus(senderId, isTyping);
    });

    // Listen for errors
    socket?.on('connect_error', (error) {
      print('Connection Error: $error');
    });
  }

  // Emit a message to the server
  void sendMessage(Message message) {
    if (socket != null) {
      socket?.emit('send_message', message.toJson());
    }
  }

  // Emit media to the server
  void sendMedia({
    required int senderId,
    required int receiverId,
    required String fileUrl,
  }) {
    if (socket != null) {
      socket?.emit('send_media', {
        'message': '[Media]',
        'fileUrl': fileUrl,
        'messageType': 'media',
        'senderId': senderId,
        'receiverId': receiverId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Emit typing status to the server with timeout handling
  void sendTypingStatusWithTimeout({
    required int senderId,
    required int receiverId,
    required bool isTyping,
  }) {
    if (socket != null) {
      if (isTyping) {
        // Emit typing event
        socket?.emit('typing', {
          'senderId': senderId,
          'receiverId': receiverId,
        });

        // Reset and start the timer to emit "stop_typing" after a delay
        typingTimer?.cancel();
        typingTimer = Timer(Duration(seconds: 3), () {
          socket?.emit('stop_typing', {
            'senderId': senderId,
            'receiverId': receiverId,
          });
        });
      } else {
        // Emit stop_typing immediately if explicitly called
        socket?.emit('stop_typing', {
          'senderId': senderId,
          'receiverId': receiverId,
        });
      }
    }
  }

  // Disconnect the socket
  void disconnect() {
    if (socket != null) {
      socket?.disconnect();
      print('Disconnected from socket and left the room.');
    }
  }
}


