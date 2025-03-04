class AcceptedJob {
  final int id;
  final double budget;
  final bool useEscrow;
  final double escrowCharge;
  final String status;
  final int progress;
  final String createdAt;
  final String updatedAt;
  final Job job;
  final User client;
  final Freelancer freelancer;

  AcceptedJob({
    required this.id,
    required this.budget,
    required this.useEscrow,
    required this.escrowCharge,
    required this.status,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    required this.job,
    required this.client,
    required this.freelancer,
  });

  factory AcceptedJob.fromJson(Map<String, dynamic> json) {
    return AcceptedJob(
      id: json['accepted_job_id'] ?? 0,
      budget: double.tryParse(json['budget'].toString()) ?? 0.0,
      useEscrow: json['use_escrow'] ?? false,
      escrowCharge: double.tryParse(json['escrow_charge'].toString()) ?? 0.0,
      progress: json['progress'] ?? 0,
      status: json['status'] ?? "Unknown",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      job: Job.fromJson(json['job'] ?? {}),
      client: User.fromJson(json['client'] ?? {}),
      freelancer: Freelancer.fromJson(json['freelancer'] ?? {}),
    );
  }
}

class Job {
  final int jobId;
  final String title;
  final String category;
  final String description;
  final String paymentStatus;

  Job({
    required this.jobId,
    required this.title,
    required this.category,
    required this.description,
    required this.paymentStatus,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'] ?? 0,
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

class Freelancer {
  final int id;
  final String profileImageUrl;
  final String name;

  Freelancer({
    required this.id,
    required this.profileImageUrl,
    required this.name,
  });

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
        id: json['freelancerProfile']['id'] ?? 0,
        profileImageUrl: json['freelancerProfile']['profileImageUrl'] ?? '',
        name: json['freelancerProfile']['name'] ?? 'Freelancer'
    );
  }
}





