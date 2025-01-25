
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
    typingStatus.refresh(); // Trigger UI updates
  }

  // Clear typing status after a timeout
  void clearTypingStatusAfterTimeout(int userId) {
    Future.delayed(Duration(seconds: 3), () {
      if (typingStatus[userId] ?? false) {
        typingStatus[userId] = false;
        typingStatus.refresh();
      }
    });
  }
}
