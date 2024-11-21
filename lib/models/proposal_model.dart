class Proposal {
  final int proposalId; // Matching the primary key
  final int jobId; // Foreign key reference to jobs
  final int freelancerId; // Foreign key reference to users
  final String name; // Freelancer's name
  final double budget; // Proposed budget
  final bool useEscrow; // Whether to use escrow
  final double escrowCharge; // Escrow charge
  final DateTime createdAt; // Created timestamp
  final DateTime updatedAt; // Updated timestamp
  final String title;

  Proposal({
    required this.proposalId,
    required this.jobId,
    required this.freelancerId,
    required this.name,
    required this.budget,
    required this.useEscrow,
    required this.escrowCharge,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
  });

  // Factory constructor to create a Proposal from JSON
  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      proposalId: json['proposal_id'],
      jobId: json['job_id'],
      freelancerId: json['freelancer_id'],
      name: json['name'],
      budget: double.tryParse(json['budget'].toString()) ?? 0.0, // Convert String to double
      useEscrow: json['use_escrow'],
      escrowCharge: double.tryParse(json['escrow_charge'].toString()) ?? 0.0, // Convert String to double
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['job']['title'], // Extract title from nested job object
    );
  }
}
