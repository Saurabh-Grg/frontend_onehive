class FollowUser {
  final int userId;
  final String username;
  final String profileImageUrl;

  FollowUser({required this.userId, required this.username, required this.profileImageUrl});

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    return FollowUser(
      userId: json['user_id'],
      username: json['username'],
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
