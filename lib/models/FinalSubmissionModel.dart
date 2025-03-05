class FinalSubmissionModel {
  final int submissionId;
  final String submissionType;
  final String submissionValue;
  final String remark;
  final String status;
  final String createdAt;

  FinalSubmissionModel({
    required this.submissionId,
    required this.submissionType,
    required this.submissionValue,
    required this.remark,
    required this.status,
    required this.createdAt

  });

  factory FinalSubmissionModel.fromJson(Map<String, dynamic> json) {
    return FinalSubmissionModel(
      submissionId: json['submission_id'] ?? 0,
      submissionType: json['submission_type'] ?? '',
      submissionValue: json['submission_value'] ?? '',
      remark: json['remarks'] ?? 'No remarks',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? 'Date not recorded'
    );
  }

  Map<String, dynamic> toJson (){
    return {
      'submission_id': submissionId,
      'submission_type': submissionType,
      'submission_value': submissionValue,
      'remarks': remark,
      'status': status,
      'createdAt': createdAt
    };
  }
}
