// import 'package:get/get.dart';
// import 'package:onehive_frontend/controllers/ChatController.dart';
// import 'package:onehive_frontend/models/Chat.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class SocketService {
//   IO.Socket? socket;
//
//   // Initialize Socket connection
//   void connect(int userId) {
//     socket = IO.io('http://172.25.6.211:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     socket?.connect();
//
//     // Register the userId with the server
//     socket?.onConnect((_) {
//       // Join the room corresponding to the userId
//       socket?.emit('join', userId);
//       print('Connected and joined room for userId: $userId');
//     });
//
//     // Listen for the message history
//     socket?.on('message_history', (data) {
//       print('Message history received: $data');
//       // Parse the message history and update the UI
//       final chatController = Get.find<ChatController>();
//       final chats = (data as List).map((chat) {
//         return Chat(
//           id: chat['id'], // Assuming unique ID exists for a chat message
//           name: chat['name'], // Sender or receiver name
//           lastMessage: chat['lastMessage'], // Message content
//           time: chat['time'], // Timestamp
//           isOnline: chat['isOnline'], // Online status
//           avatarUrl: chat['avatarUrl'], // Avatar URL
//         );
//       }).toList();
//       chatController.loadInitialMessages(chats);
//     });
//
//       // Listen for incoming messages
//     socket?.on('receive_message', (data) {
//       print('Message received: ${data['message']} from senderId: ${data['senderId']}');
//     });
//
//     // Listen for incoming media
//     socket?.on('receive_media', (data) {
//       print('Media received: ${data['fileUrl']} from senderId: ${data['senderId']}');
//     });
//
//     // Listen for errors
//     socket?.on('connect_error', (error) {
//       print('Connection Error: $error');
//     });
//   }
//
//   // Emit a message to the server
//   void sendMessage(int senderId, int receiverId, String message) {
//     if (socket != null) {
//       socket?.emit('send_message', {
//         'senderId': senderId,
//         'receiverId': receiverId,
//         'message': message
//       });
//     }
//   }
//
//   // Emit media to the server
//   void sendMedia(int senderId, int receiverId, String fileUrl) {
//     if (socket != null) {
//       socket?.emit('send_media', {
//         'senderId': senderId,
//         'receiverId': receiverId,
//         'fileUrl': fileUrl
//       });
//     }
//   }
//
//   // Disconnect the socket
//   void disconnect() {
//     if (socket != null) {
//       socket?.disconnect();
//       print('Disconnected from socket.');
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/ChatController.dart';
import 'package:onehive_frontend/models/Message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  // Initialize Socket connection
  void connect(int userId) {
    socket = IO.io('http://172.25.4.79:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    // Register the userId with the server
    socket?.onConnect((_) {
      socket?.emit('join', userId);
      print('Connected and joined room for userId: $userId');
    });

    // Listen for the message history
    socket?.on('message_history', (data) {
      print('Message history received: $data');
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

  // Disconnect the socket
  void disconnect() {
    if (socket != null) {
      socket?.disconnect();
      print('Disconnected from socket.');
    }
  }
}
