class AcceptedJob {
  final double budget;
  final bool useEscrow;
  final double escrowCharge;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Job job;
  final User client;
  final User freelancer;

  AcceptedJob({
    required this.budget,
    required this.useEscrow,
    required this.escrowCharge,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.job,
    required this.client,
    required this.freelancer,
  });

  factory AcceptedJob.fromJson(Map<String, dynamic> json) {
    return AcceptedJob(
      budget: double.tryParse(json['budget'].toString()) ?? 0.0,
      useEscrow: json['use_escrow'] ?? false,
      escrowCharge: double.tryParse(json['escrow_charge'].toString()) ?? 0.0,
      status: json['status'] ?? "Unknown",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      job: Job.fromJson(json['job'] ?? {}),
      client: User.fromJson(json['client'] ?? {}),
      freelancer: User.fromJson(json['freelancer'] ?? {}),
    );
  }
}

class Job {
  final String title;
  final String category;
  final String description;
  final String paymentStatus;

  Job({
    required this.title,
    required this.category,
    required this.description,
    required this.paymentStatus,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'] ?? "No Title",
      category: json['category'] ?? "Unknown Category",
      description: json['description'] ?? "No Description",
      paymentStatus: json['payment_status'] ?? "Unpaid",
    );
  }
}

class User {
  final int userId;
  final String username;
  final String email;

  User({
    required this.userId,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? "Unknown",
      email:  json['email'] ?? "No email",

    );
  }
}
