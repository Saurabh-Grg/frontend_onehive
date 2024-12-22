import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ChatController.dart';
import 'ChatPage.dart';

class ChatListPage extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: Obx(() {
        if (chatController.chatList.isEmpty) {
          return const Center(
            child: Text('No chats available'),
          );
        }

        return ListView.builder(
          itemCount: chatController.chatList.length,
          itemBuilder: (context, index) {
            final chat = chatController.chatList[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(chat.name[0]), // Initial letter of the name
              ),
              title: Text(chat.name),
              subtitle: Text(chat.lastMessage),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(chat.time, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 5),
                  chat.isOnline
                      ? const Icon(Icons.circle, color: Colors.green, size: 12)
                      : const Icon(Icons.circle, color: Colors.grey, size: 12),
                ],
              ),
              onTap: () {
                // Navigate to the chat screen
                Get.to(() => ChatScreen(chat: chat));
              },
            );
          },
        );
      }),
    );
  }
}
