import 'package:get/get.dart';
import '../models/Chat.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  var chatList = <Chat>[].obs; // Original chat list
  var filteredChatList = <Chat>[].obs; // Filtered chat list for search
  var messages = <Message>[].obs; // List of messages
  var currentUserId = '1'; // Assuming '1' is the current user's ID, this should be dynamically set
  var currentUserAvatar = 'https://example.com/current_user_avatar.png'; // Current user's avatar URL
  TextEditingController messageController = TextEditingController(); // Controller for the message input

  @override
  void onInit() {
    super.onInit();
    loadChats();
    filteredChatList.value = chatList; // Initialize filtered list
  }

  /// Simulates loading chat data
  void loadChats() {
    chatList.value = [
      Chat(
        id: '1',
        name: 'John Doe',
        lastMessage: 'Hello!',
        time: '10:00 AM',
        isOnline: true,
        avatarUrl: 'https://example.com/john_avatar.png',
      ),
      Chat(
        id: '2',
        name: 'Jane Smith',
        lastMessage: 'How are you?',
        time: '9:45 AM',
        isOnline: false,
        avatarUrl: 'https://example.com/john_avatar.png',
      ),
      Chat(
        id: '3',
        name: 'Alice Johnson',
        lastMessage: 'Let’s catch up later.',
        time: '8:30 AM',
        isOnline: true,
        avatarUrl: 'https://example.com/john_avatar.png',
      ),
      Chat(
        id: '4',
        name: 'Bob Brown',
        lastMessage: 'Great job on the project!',
        time: 'Yesterday',
        isOnline: false,
        avatarUrl: 'https://example.com/john_avatar.png',
      ),
      Chat(
        id: '5',
        name: 'Charlie Davis',
        lastMessage: 'See you at the meeting.',
        time: 'Yesterday',
        isOnline: true,
        avatarUrl: 'https://example.com/john_avatar.png',
      ),
      // Add more chat data as needed
    ];

    // Initialize filtered list
    filteredChatList.value = chatList;
  }

  /// Filters chats based on the search query
  void searchChats(String query) {
    if (query.isEmpty) {
      resetFilteredChats(); // Reset to full list if query is empty
    } else {
      filteredChatList.value = chatList
          .where((chat) =>
      chat.name.toLowerCase().contains(query.toLowerCase()) || // Match name
          chat.lastMessage.toLowerCase().contains(query.toLowerCase())) // Match last message
          .toList();
    }
  }

  /// Resets the filtered list to the full chat list
  void resetFilteredChats() {
    filteredChatList.value = chatList;
  }

  /// Adds a new chat to the list
  void addChat(Chat newChat) {
    chatList.add(newChat);
    resetFilteredChats(); // Refresh filtered list
  }

  /// Removes a chat from the list
  void deleteChat(String chatId) {
    chatList.removeWhere((chat) => chat.id == chatId);
    resetFilteredChats(); // Refresh filtered list
  }

  /// Updates the online status of a specific chat
  void updateOnlineStatus(String chatId, bool isOnline) {
    final index = chatList.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      chatList[index] = chatList[index].copyWith(isOnline: isOnline);
      resetFilteredChats(); // Refresh filtered list
    }
  }

  /// Sends a message in the current chat
  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      // Create and add the new message to the list
      Message newMessage = Message(
        senderId: currentUserId,
        text: messageText,
      );
      messages.add(newMessage); // Add message to the messages list
      messageController.clear(); // Clear input field after sending
    }
  }
}

class Message {
  final String senderId;
  final String text;

  Message({
    required this.senderId,
    required this.text,
  });
}