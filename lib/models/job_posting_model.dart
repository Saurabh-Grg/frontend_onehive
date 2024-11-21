class JobDetails {
  String title;
  String description;
  String category;
  int userId; // Ensure this is defined

  JobDetails({
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'user_id': userId,
    };
  }

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      userId: json['user_id'],
    );
  }
}