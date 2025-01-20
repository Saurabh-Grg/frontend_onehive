import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_posting_model.dart';

class JobPostingService with ChangeNotifier {
  JobDetails? _currentJobPosting;

  // Getter for current job posting
  JobDetails? get currentJobPosting => _currentJobPosting;

  // Method to initialize the job posting
  void initializeJobPosting(int userId) {
    _currentJobPosting = JobDetails(
      title: '',
      description: '',
      category: '',
      userId: userId, // Set userId when initializing
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Sets the job posting data, including userId
  void setJobPosting(String title, String description, String category, int userId) {
    _currentJobPosting = JobDetails(
      title: title,
      description: description,
      category: category,
      userId: userId, // Set userId
    );
    print('Job Posting Set: $title, $description, $category, $userId'); // Debug print
    notifyListeners(); // Notify listeners about the change
  }

  // Clears the job posting data
  void clearJobPosting() {
    _currentJobPosting = null;
    notifyListeners(); // Notify listeners about the change
  }

  // A method to get the job posting data as a map
  Map<String, String?> getJobPostingData() {
    return {
      'title': _currentJobPosting?.title,
      'description': _currentJobPosting?.description,
      'category': _currentJobPosting?.category,
      'user_id': _currentJobPosting?.userId?.toString(), // Include user_id in the map
    };
  }

  // A method to validate if the current job posting data is complete
  bool isJobPostingComplete() {
    return _currentJobPosting != null &&
        _currentJobPosting!.title.isNotEmpty &&
        _currentJobPosting!.description.isNotEmpty &&
        _currentJobPosting!.category.isNotEmpty &&
        _currentJobPosting!.userId != null; // Ensure userId is not null
  }

  // Method to store temporary job posting data
  Future<void> storeTempJob() async {
    if (_currentJobPosting == null) {
      throw Exception("Job posting details are not set.");
    }

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.storeCommonJobDetails),
        headers: {
          'Content-Type': 'application/json',
        },

        body: json.encode({
          'title': _currentJobPosting!.title,
          'description': _currentJobPosting!.description,
          'category': _currentJobPosting!.category,
          'user_id': _currentJobPosting!.userId.toString(), // Include user_id in the request body
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        // Store the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('job_token', token);

        // clearJobPosting(); // Optionally clear the job posting details after storing
      } else {
        throw Exception("Failed to store job posting: ${response.body}");
      }
    } catch (error) {
      print('Error storing job posting: $error');
      throw Exception("An error occurred while storing job posting.");
    }
  }


  // Method to print current job posting details for debugging
  void printCurrentJobPostingDetails() {
    if (_currentJobPosting != null) {
      print('Current Job Posting Details:');
      print('Title: ${_currentJobPosting!.title}');
      print('Description: ${_currentJobPosting!.description}');
      print('Category: ${_currentJobPosting!.category}');
      print('User ID: ${_currentJobPosting!.userId}');
    } else {
      print('No job posting details are currently set.');
    }
  }

  // Submit method to validate and store job posting
  Future<void> submitJobPosting() async {
    // Check if the job posting is complete
    if (!isJobPostingComplete()) {
      // Show an error message to the user
      print('Please fill in all required fields before submitting the job posting.');
      return; // Exit the method early
    }

    // Proceed to store the job posting if validation passes
    await storeTempJob();
  }
}
