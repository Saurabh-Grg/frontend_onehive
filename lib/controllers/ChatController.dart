import 'package:get/get.dart';
import '../models/Chat.dart';


class ChatController extends GetxController {
  var chatList = <Chat>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  void loadChats() {
    // Simulating fetching chat data
    chatList.value = [
      Chat(
        id: '1',
        name: 'John Doe',
        lastMessage: 'Hello!',
        time: '10:00 AM',
        isOnline: true,
      ),
      Chat(
        id: '2',
        name: 'Jane Smith',
        lastMessage: 'How are you?',
        time: '9:45 AM',
        isOnline: false,
      ),
      // Add more chat data
    ];
  }
}
