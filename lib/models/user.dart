// lib/models/user.dart
class User {
  final int userId; // Corresponds to user_id in backend
  final String username; // Corresponds to username in backend
  final String password; // Corresponds to password in backend
  final String email; // Corresponds to email in backend
  final String role; // Corresponds to role in backend
  final String city; // Corresponds to city in backend
  final String? resetPasswordToken; // Corresponds to reset_password_token in backend
  final DateTime? resetPasswordExpires; // Corresponds to reset_password_expires in backend

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
    required this.city,
    this.resetPasswordToken,
    this.resetPasswordExpires,
  });

  // Factory method to create a User instance from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      password: json['password'], // Note: You might not want to include password in the model
      email: json['email'],
      role: json['role'],
      city: json['city'],
      resetPasswordToken: json['reset_password_token'],
      resetPasswordExpires: json['reset_password_expires'] != null
          ? DateTime.parse(json['reset_password_expires'])
          : null,
    );
  }

  // Method to convert User instance to JSON object
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'password': password, // Note: You might not want to include password in the model
      'email': email,
      'role': role,
      'city': city,
      'reset_password_token': resetPasswordToken,
      'reset_password_expires': resetPasswordExpires?.toIso8601String(),
    };
  }
}
