// models/total_proposals_model.dart
class TotalProposalsModel {
  final int totalProposals;

  TotalProposalsModel({required this.totalProposals});

  factory TotalProposalsModel.fromJson(Map<String, dynamic> json) {
    return TotalProposalsModel(
      totalProposals: json['totalProposals'],
    );
  }
}
