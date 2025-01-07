import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ChatController.dart';
import '../models/Chat.dart';

class ChatScreen extends StatelessWidget {
  final Chat chat; // Chat object passed from ChatListPage
  final ChatController chatController = Get.put(ChatController());

  ChatScreen({required this.chat, Key? key}) : super(key: key);

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
      // chatController.sendFile(filePath, fileName);
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
          chat.name,
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
            // Chat messages list
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    final isSender = message.senderId == chatController.currentUserId;
                    return _buildChatBubble(message.text, isSender);
                  },
                );
              }),
            ),
            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(chat.avatarUrl), // Receiver's avatar
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: isSender ? Colors.deepOrange : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxWidth: 250),
              child: Text(
                message,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            if (isSender)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(chatController.currentUserAvatar), // Sender's avatar
                ),
              ),
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
              controller: chatController.messageController,
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
            icon: Icon(Icons.attach_file, color: Colors.deepOrange),
            onPressed: _pickFile,
          ),
          const SizedBox(width: 8),
          // Send button
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.deepOrange,
            onPressed: () {
              chatController.sendMessage();
            },
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
