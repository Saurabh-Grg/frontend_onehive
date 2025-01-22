
import 'package:get/get.dart';
import 'package:onehive_frontend/models/Message.dart';

class ChatController extends GetxController {
  // List of messages
  final messages = <Message>[].obs;

  // Observable property for typing status
  var isTyping = false.obs;

  // Observable map to track typing status for users
  final RxMap<int, bool> typingStatus = <int, bool>{}.obs;

  // Load initial messages (e.g., message history)
  void loadInitialMessages(List<Message> initialMessages) {
    messages.assignAll(initialMessages);
  }

  // Add a new message to the list
  void addMessage(Message message) {
    print('Adding new message: ${message.toJson()}');
    messages.add(message);
  }

  // Update typing status for a specific user
  void updateTypingStatus(int userId, bool isTyping) {
    typingStatus[userId] = isTyping;

    // Optional: Remove typing status after a delay if no "stop_typing" event is received
    if (isTyping) {
      Future.delayed(const Duration(seconds: 5), () {
        if (typingStatus[userId] == true) {
          typingStatus[userId] = false;
        }
      });
    }
  }

  // Clear typing status for a specific user (e.g., when the user disconnects)
  void clearTypingStatus(int userId) {
    typingStatus.remove(userId);
  }
}
