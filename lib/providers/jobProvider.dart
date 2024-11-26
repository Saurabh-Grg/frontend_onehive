import 'package:flutter/material.dart';
import '../models/job_posting_model.dart';


class JobProvider with ChangeNotifier {
  JobDetails _commonJobDetails = JobDetails(
    title: '',
    description: '',
    category: '',
    userId: 0,
  );

  JobDetails get commonJobDetails => _commonJobDetails;

  // Function to update common job details
  void setCommonJobDetails(String title, String description, String category, int userId) {
    _commonJobDetails = JobDetails(
      title: title,
      description: description,
      category: category,
      userId: userId,
    );
    notifyListeners();  // Notify the app that common job details have been updated
  }
}
