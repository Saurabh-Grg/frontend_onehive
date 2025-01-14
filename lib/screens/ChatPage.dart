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

  const ChatScreen({Key? key, required this.user, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  final UserController _userController = Get.put(UserController());
  final ChatController _chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("User ID on socket connection: ${_userController.userId.value}");
    _socketService.connect(int.tryParse(_userController.userId.value) ?? 0);

    // Fetch messages for a specific sender and receiver
    int senderId = int.tryParse(_userController.userId.value) ?? 0;;
    int receiverId = widget.userId; // Replace with actual receiver ID
    _chatController.fetchMessages(senderId, receiverId);

    // Scroll to the bottom when chat is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Listen for incoming messages
    _socketService.socket?.on('receive_message', (data) {
      print(
          'Received message: ${data['message']} from senderId: ${data['senderId']}');

      setState(() {
        _chatController.messages.add(Message(
          messageId: data['messageId'],
          message: data['message'],
          senderId: data['senderId'],
          receiverId: int.tryParse(_userController.userId.value) ?? 0,
          messageType: data['messageType'],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
        ));
        _scrollToBottom(); // Scroll to the bottom after receiving a new message
      });
    });
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    int senderId = int.tryParse(_userController.userId.value) ?? 0;
    int receiverId = widget.userId;

    if (message.isNotEmpty && senderId > 0 && receiverId > 0) {
      setState(() {
        _chatController.messages.add(Message(
          messageId: DateTime.now().millisecondsSinceEpoch,
          // Generating unique messageId
          message: message,
          senderId: senderId,
          receiverId: receiverId,
          messageType: 'text',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
        _scrollToBottom(); // Scroll to the bottom after sending a message
      });

      // Send the message to the server
      _socketService.sendMessage(senderId, receiverId, message);
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }


  // Method to pick a file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Allow single file selection
    );

    if (result != null) {
      // The file is picked
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      // You can send the file path and file name to your server or handle it as needed
      Get.snackbar('File Selected', 'File: $fileName');
    } else {
      // User canceled the picker
      Get.snackbar('File Picking Cancelled', 'No file was selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.username,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        backgroundImage: NetworkImage('https://www.example.com/path/to/profile/pic/${widget.userId}.jpg'), // Replace with actual URL
                        radius: 20,
                      ),
                      trailing: isSender
                          ? CircleAvatar(
                        // Display the sender's profile image
                        backgroundImage: NetworkImage('https://www.example.com/path/to/profile/pic/${message.senderId}.jpg'), // Replace with actual URL
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
