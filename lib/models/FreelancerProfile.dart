import 'dart:convert';

class FreelancerProfile {
  final int id;
  final int userId;
  final String? name;
  final String? bio;
  final String? skills;
  final String? experience;
  final String? education;
  final String? profileImageUrl;
  final List<String>? portfolioImages;
  final List<String>? certificates;

  FreelancerProfile({
    required this.id,
    required this.userId,
    this.name,
    this.bio,
    this.skills,
    this.experience,
    this.education,
    this.profileImageUrl,
    this.portfolioImages,
    this.certificates,
  });

  factory FreelancerProfile.fromJson(Map<String, dynamic> json) {
    return FreelancerProfile(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      skills: json['skills'] ?? '',
      experience: json['experience'] ?? '',
      education: json['education'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      portfolioImages: json['portfolioImages'] != null
          ? (json['portfolioImages'] is String
          ? List<String>.from(jsonDecode(json['portfolioImages']))
          : List<String>.from(json['portfolioImages']))
          : [],
      certificates: json['certificates'] != null
          ? (json['certificates'] is String
          ? List<String>.from(jsonDecode(json['certificates']))
          : List<String>.from(json['certificates']))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'bio': bio,
      'skills': skills,
      'experience': experience,
      'education': education,
      'profileImageUrl': profileImageUrl,
      'portfolioImages': portfolioImages,
      'certificates': certificates,
    };
  }
}