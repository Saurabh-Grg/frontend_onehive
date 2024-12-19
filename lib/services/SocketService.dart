import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../controllers/UserController.dart';

class SocketService extends GetxController {
  late IO.Socket socket;
  RxBool isConnected = false.obs;

  final UserController userController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _connectSocket();
  }

  // Connect to the Socket.IO server
  void _connectSocket() {
    socket = IO.io('ws://localhost:3000/socket.io/?EIO=4&transport=websocket', <String, dynamic>{
      'transports': ['websocket'],
      // 'autoConnect': false,
      'autoConnect': true,  // Automatically connect
      'reconnect': true,    // Automatically attempt to reconnect
      'auth': {
        'token': '${userController.token.value}', // Pass the token here
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO server');
      isConnected.value = true;
    });

    socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
      isConnected.value = false;
    });

    socket.on('receiveMessage', (data) {
      print('Received message: $data');
      // Handle incoming messages (e.g., update UI)
    });

    socket.onConnectError((data) {
      print('Connection error: $data');
      isConnected.value = false;
    });
  }



  // Send message to a receiver
  void sendMessage(int to, String message) {
    socket.emit('sendMessage', {'to': to, 'message': message});
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
