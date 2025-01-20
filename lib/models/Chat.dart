// class Chat {
//   final String id;
//   final String name;
//   final String lastMessage;
//   final String time;
//   final bool isOnline;
//   final String avatarUrl; // Add the avatar URL field
//
//   Chat({
//     required this.id,
//     required this.name,
//     required this.lastMessage,
//     required this.time,
//     required this.isOnline,
//     required this.avatarUrl, // Include avatar URL in constructor
//   });
//
//   // You can also add a copyWith method to make it easier to update the avatar URL if needed
//   Chat copyWith({
//     String? id,
//     String? name,
//     String? lastMessage,
//     String? time,
//     bool? isOnline,
//     String? avatarUrl,
//   }) {
//     return Chat(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       lastMessage: lastMessage ?? this.lastMessage,
//       time: time ?? this.time,
//       isOnline: isOnline ?? this.isOnline,
//       avatarUrl: avatarUrl ?? this.avatarUrl,
//     );
//   }
// }
