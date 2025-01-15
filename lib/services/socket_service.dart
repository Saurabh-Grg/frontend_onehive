import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  // Initialize Socket connection
  void connect(int userId) {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    // Register the userId with the server
    socket?.onConnect((_) {
      // Join the room corresponding to the userId
      socket?.emit('join', userId);
      print('Connected and joined room for userId: $userId');
    });

    // Listen for incoming messages
    socket?.on('receive_message', (data) {
      print('Message received: ${data['message']} from senderId: ${data['senderId']}');
    });

    // Listen for incoming media
    socket?.on('receive_media', (data) {
      print('Media received: ${data['fileUrl']} from senderId: ${data['senderId']}');
    });

    // Listen for errors
    socket?.on('connect_error', (error) {
      print('Connection Error: $error');
    });
  }

  // Emit a message to the server
  void sendMessage(int senderId, int receiverId, String message) {
    if (socket != null) {
      socket?.emit('send_message', {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message
      });
    }
  }

  // Emit media to the server
  void sendMedia(int senderId, int receiverId, String fileUrl) {
    if (socket != null) {
      socket?.emit('send_media', {
        'senderId': senderId,
        'receiverId': receiverId,
        'fileUrl': fileUrl
      });
    }
  }

  // Disconnect the socket
  void disconnect() {
    if (socket != null) {
      socket?.disconnect();
      print('Disconnected from socket.');
    }
  }
}