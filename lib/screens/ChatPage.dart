// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../controllers/ChatController.dart';
// import '../controllers/UserController.dart';
// import '../models/FollowUser.dart';
// import '../models/Message.dart';
// import '../services/socket_service.dart';
//
// class ChatScreen extends StatefulWidget {
//   final FollowUser user;
//   final int userId;
//   final String profileImageUrl; // Add this parameter
//
//   const ChatScreen({Key? key, required this.user, required this.userId, required this.profileImageUrl }) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final SocketService _socketService = SocketService();
//   final TextEditingController _messageController = TextEditingController();
//   final UserController _userController = Get.put(UserController());
//   final ChatController _chatController = Get.put(ChatController());
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     print("User ID on socket connection: ${_userController.userId.value}");
//     _socketService.connect(int.tryParse(_userController.userId.value) ?? 0);
//
//     // Fetch messages for a specific sender and receiver
//     int senderId = int.tryParse(_userController.userId.value) ?? 0;;
//     int receiverId = widget.userId; // Replace with actual receiver ID
//     _chatController.fetchMessages(senderId, receiverId);
//
//     // Scroll to the bottom when chat is loaded
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollToBottom();
//     });
//
//     // Listen for incoming messages
//     _socketService.socket?.on('receive_message', (data) {
//       print(
//           'Received message: ${data['message']} from senderId: ${data['senderId']}');
//
//       setState(() {
//         _chatController.messages.add(Message(
//           messageId: data['messageId'],
//           message: data['message'],
//           senderId: data['senderId'],
//           receiverId: int.tryParse(_userController.userId.value) ?? 0,
//           messageType: data['messageType'],
//           createdAt: DateTime.parse(data['createdAt']),
//           updatedAt: DateTime.parse(data['updatedAt']),
//         ));
//         _scrollToBottom(); // Scroll to the bottom after receiving a new message
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _socketService.disconnect();
//     _scrollController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   void _sendMessage() {
//     String message = _messageController.text.trim();
//     int senderId = int.tryParse(_userController.userId.value) ?? 0;
//     int receiverId = widget.userId;
//
//     if (message.isNotEmpty && senderId > 0 && receiverId > 0) {
//       setState(() {
//         _chatController.messages.add(Message(
//           messageId: DateTime.now().millisecondsSinceEpoch,
//           // Generating unique messageId
//           message: message,
//           senderId: senderId,
//           receiverId: receiverId,
//           messageType: 'text',
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ));
//         _scrollToBottom(); // Scroll to the bottom after sending a message
//       });
//
//       // Send the message to the server
//       _socketService.sendMessage(senderId, receiverId, message);
//       _messageController.clear();
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }
//
//
//   // Method to pick a file
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false, // Allow single file selection
//     );
//
//     if (result != null) {
//       // The file is picked
//       String filePath = result.files.single.path!;
//       String fileName = result.files.single.name;
//
//       // You can send the file path and file name to your server or handle it as needed
//       Get.snackbar('File Selected', 'File: $fileName');
//     } else {
//       // User canceled the picker
//       Get.snackbar('File Picking Cancelled', 'No file was selected.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userController = Get.find<UserController>();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.user.username,
//           style: const TextStyle( fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               // Placeholder for options menu
//               Get.snackbar('Feature Coming Soon', 'Options will be available soon.');
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//
//               child: Obx(() {
//                 // Check if there are messages
//                 if (_chatController.messages.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'You can now send a message to ${widget.user.username}!',
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                       textAlign: TextAlign.center,
//                     ),
//                   );
//                 }
//                 // Use GetX's Obx to reactively rebuild when messages change
//                 return ListView.builder(
//                   controller: _scrollController, // Attach the ScrollController
//                   reverse: true, // Enable reverse scrolling for latest messages at the bottom
//                   itemCount: _chatController.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _chatController.messages[_chatController.messages.length - 1 - index];
//                     final isSender = message.senderId == int.tryParse(_userController.userId.value);
//                     return ListTile(
//                       contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                       leading: isSender
//                           ? null // No avatar on the left for the sender (optional, can be added if needed)
//                           : CircleAvatar(
//                         // Display the receiver's profile image
//                         backgroundImage: NetworkImage(widget.user.profileImageUrl), // Replace with actual URL
//                         radius: 20,
//                       ),
//                       trailing: isSender
//                           ? CircleAvatar(
//                         // Display the sender's profile image
//                         backgroundImage: NetworkImage(userController.profileImage.value), // Replace with actual URL
//                         radius: 20,
//                       )
//                           : null, // No avatar on the right for the receiver (optional, can be added if needed)
//                       title: Align(
//                         alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Column(
//                           crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               constraints: BoxConstraints(
//                                 maxWidth: MediaQuery.of(context).size.width * 0.75,
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                               decoration: BoxDecoration(
//                                 color: isSender ? Colors.deepOrange[100] : Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: Text(
//                                 message.message,
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ),
//                             const SizedBox(height: 4.0), // Space between message and time
//                             Text(
//                               DateFormat('yyyy-MM-dd hh:mm a').format(message.createdAt),
//                               style: const TextStyle(fontSize: 12, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//
//                 );
//               }),
//             ),
//             _buildMessageInput(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message...',
//                 hintStyle: const TextStyle(color: Colors.grey),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           // File picker button
//           IconButton(
//             icon: const Icon(Icons.attach_file, color: Colors.deepOrange),
//             onPressed: _pickFile,
//           ),
//           const SizedBox(width: 8),
//           // Send button
//           FloatingActionButton(
//             mini: true,
//             backgroundColor: Colors.deepOrange,
//             onPressed: () {
//               if (_messageController.text.trim().isNotEmpty) {
//                 // Send message logic here
//                 _sendMessage();
//                 _messageController.clear();
//               } else {
//                 Get.snackbar('Error', 'Message cannot be empty.');
//               }
//             },
//             child: const Icon(Icons.send, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/ChatController.dart';
import '../controllers/UserController.dart';
import '../models/FollowUser.dart';
import '../models/Message.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  final FollowUser user;
  final int userId;
  final String profileImageUrl; // Add this parameter

  const ChatScreen({Key? key, required this.user, required this.userId, required this.profileImageUrl }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  final UserController _userController = Get.put(UserController());
  final ChatController _chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _socketService.connect(int.parse(_userController.userId.value));
    _chatController.loadInitialMessages([]); // Clear and load fresh messages
    _scrollToBottom();

    // Listen for typing status
    _socketService.socket?.on('typing', (data) {
      if (data['senderId'] == widget.userId) {
        _chatController.updateTypingStatus(widget.userId, true);
      }
    });

    _socketService.socket?.on('stop_typing', (data) {
      if (data['senderId'] == widget.userId) {
        _chatController.updateTypingStatus(widget.userId, false);
      }
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final message = Message(
      messageId: DateTime.now().millisecondsSinceEpoch,
      message: messageText,
      senderId: int.parse(_userController.userId.value),
      receiverId: widget.userId,
      messageType: 'text',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _chatController.addMessage(message);
    _socketService.sendMessage(message);
    _messageController.clear();
    _scrollToBottom();
  }

  void _sendTypingStatus(bool isTyping) {
    _isTyping = isTyping;
    if (isTyping) {
      _socketService.socket?.emit('typing', {
        'senderId': int.parse(_userController.userId.value),
        'receiverId': widget.userId,
      });
    } else {
      _socketService.socket?.emit('stop_typing', {
        'senderId': int.parse(_userController.userId.value),
        'receiverId': widget.userId,
      });
    }
  }

  void _sendMedia(String filePath) {
    final fileMessage = Message(
      messageId: DateTime.now().millisecondsSinceEpoch,
      message: '[Media]',
      senderId: int.parse(_userController.userId.value),
      receiverId: widget.userId,
      messageType: 'media',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _chatController.addMessage(fileMessage);
    _socketService.sendMedia(
      senderId: fileMessage.senderId,
      receiverId: fileMessage.receiverId,
      fileUrl: filePath,
    );
    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      _sendMedia(result.files.single.path!);
      Get.snackbar('File Selected', result.files.single.name);
    } else {
      Get.snackbar('Cancelled', 'No file was selected.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.username,
          style: const TextStyle( fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Placeholder for options menu
              Get.snackbar('Feature Coming Soon', 'Options will be available soon.');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(

              child: Obx(() {
                // Check if there are messages
                if (_chatController.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'You can now send a message to ${widget.user.username}!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                // Use GetX's Obx to reactively rebuild when messages change
                return ListView.builder(
                  controller: _scrollController, // Attach the ScrollController
                  reverse: true, // Enable reverse scrolling for latest messages at the bottom
                  itemCount: _chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = _chatController.messages[_chatController.messages.length - 1 - index];
                    final isSender = message.senderId == int.tryParse(_userController.userId.value);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      leading: isSender
                          ? null // No avatar on the left for the sender (optional, can be added if needed)
                          : CircleAvatar(
                        // Display the receiver's profile image
                        backgroundImage: NetworkImage(widget.user.profileImageUrl), // Replace with actual URL
                        radius: 20,
                      ),
                      trailing: isSender
                          ? CircleAvatar(
                        // Display the sender's profile image
                        backgroundImage: NetworkImage(userController.profileImage.value), // Replace with actual URL
                        radius: 20,
                      )
                          : null, // No avatar on the right for the receiver (optional, can be added if needed)
                      title: Align(
                        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: isSender ? Colors.deepOrange[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                message.message,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 4.0), // Space between message and time
                            Text(
                              DateFormat('yyyy-MM-dd hh:mm a').format(message.createdAt),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                );
              }),
            ),
            Obx(() {
              if (_chatController.isTyping.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.user.username} is typing...',
                      style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // File picker button
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.deepOrange),
            onPressed: _pickFile,
          ),
          const SizedBox(width: 8),
          // Send button
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                // Send message logic here
                _sendMessage();
                _messageController.clear();
              } else {
                Get.snackbar('Error', 'Message cannot be empty.');
              }
            },
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
