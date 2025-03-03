import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/controllers/MyProjectController.dart';
import 'package:onehive_frontend/controllers/UserController.dart';

class MilestoneController extends GetxController {

  final UserController userController = Get.find();
  final MyProjectsController myProjectsController = Get.find();

  // API endpoint for submitting milestones
  static const String apiUrl = "http://localhost:3000/api/milestones";

  // Function to submit milestone
  Future<void> submitMilestone(int acceptedJobId, String title,
      String description) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.token.value}'
        },
        body: json.encode({
          'accepted_job_id': acceptedJobId,
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        // Success response from the API
        final data = json.decode(response.body);
        final newProgress = data['job_progress'];
        Get.snackbar("Success",
            "Milestone submitted successfully! Progress: $newProgress%");
        myProjectsController.loadProjects();
      } else if (response.statusCode == 400) {
        // Handle if too many milestones are submitted
        final data = json.decode(response.body);
        Get.snackbar("Milestone Submission Limit Reached", data['message']);
        throw Exception('Too many milestones submitted.');
      } else {
        throw Exception('Failed to submit milestone.');
      }
    } catch (e) {
      throw e; // Propagate the error to the caller
    }
  }
}
