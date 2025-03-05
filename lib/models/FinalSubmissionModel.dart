class FinalSubmissionModel {
  final String submissionType;
  final String submissionValue;
  final String remark;
  final String status;

  FinalSubmissionModel({
    required this.submissionType,
    required this.submissionValue,
    required this.remark,
    required this.status

  });

  factory FinalSubmissionModel.fromJson(Map<String, dynamic> json) {
    return FinalSubmissionModel(
      submissionType: json['submission_type'] ?? '',
      submissionValue: json['submission_value'] ?? '',
      remark: json['remarks'] ?? 'No remarks',
      status: json['status'] ?? 'pending'
    );
  }

  Map<String, dynamic> toJson (){
    return {
      'submission_type': submissionType,
      'submission_value': submissionValue,
      'remarks': remark,
      'status': status
    };
  }
}
