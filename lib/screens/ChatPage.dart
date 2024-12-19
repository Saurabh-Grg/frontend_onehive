// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/ChatController.dart';
//
// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ChatController chatController = Get.put(ChatController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Real-Time Chat', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 4.0,
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Display the chat messages
//             Expanded(
//               child: Obx(() {
//                 return ListView.builder(
//                   padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
//                   itemCount: chatController.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = chatController.messages[index];
//                     bool isSender = index % 2 == 0;  // For demonstration, alternate between sender and receiver
//                     return _buildChatBubble(message, isSender);
//                   },
//                 );
//               }),
//             ),
//             // Message input section
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   // File attachment button
//                   IconButton(
//                     icon: Icon(Icons.attach_file, color: Colors.deepOrange),
//                     onPressed: _selectFile, // Handle file selection
//                   ),
//                   // Input field
//                   Expanded(
//                     child: TextField(
//                       controller: chatController.messageController,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         hintStyle: TextStyle(color: Colors.grey),
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Send button
//                   IconButton(
//                     icon: Icon(Icons.send, color: Colors.deepOrange),
//                     onPressed: chatController.sendMessage,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build chat bubbles
//   Widget _buildChatBubble(String message, bool isSender) {
//     return Align(
//       alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//           children: [
//             // If receiver, show avatar at the left border, if sender show avatar at the right border
//             if (!isSender)
//               Padding(
//                 padding: const EdgeInsets.only(right: 8.0),
//                 child: CircleAvatar(
//                   radius: 20.0,
//                   backgroundImage: NetworkImage('https://static.wikia.nocookie.net/motu-patlu/images/a/a2/Duplicatepatlu.png/revision/latest?cb=20180109141805'), // Receiver's profile image URL
//                 ),
//               ),
//             // Chat bubble
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//               decoration: BoxDecoration(
//                 color: isSender ? Colors.deepOrange : Colors.grey[300],
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4.0,
//                     spreadRadius: 1.0,
//                   ),
//                 ],
//               ),
//               constraints: BoxConstraints(maxWidth: 250),
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: isSender ? Colors.white : Colors.black,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),
//             // If sender, show avatar at the right border
//             if (isSender)
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: CircleAvatar(
//                   radius: 20.0,
//                   backgroundImage: NetworkImage('https://i.ytimg.com/vi/r1vlUx3PlPM/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBKABIWbSUVNEGfBxEp42h73vBJ8Q'), // Sender's profile image URL
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Placeholder for file selection functionality (to be implemented)
//   void _selectFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       // File selected, you can now use result.files.single.path to get the file path
//       print('File selected: ${result.files.single.path}');
//     } else {
//       // User canceled the picker
//       print('No file selected');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ChatController.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Chat'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages list
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(chatController.messages[index]),
                    );
                  },
                );
              }),
            ),
            // Message input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (message) {
                        chatController.sendMessage(message);
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = 'Hello, this is a test message';
                      chatController.sendMessage(message);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
