import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:onehive_frontend/controllers/MyProjectController.dart';
import 'package:onehive_frontend/controllers/UserController.dart';

class MilestoneController extends GetxController {

  final UserController userController = Get.find();
  // Check if MyProjectsController is available before accessing it
  MyProjectsController? myProjectsController;

  // List to hold fetched milestones
  var milestones = <Map<String, dynamic>>[].obs;
  var seenMilestones = <bool>[].obs; // Track seen milestones

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Ensure MyProjectsController is registered before trying to access it
    if (!Get.isRegistered<MyProjectsController>()) {
      Get.put(MyProjectsController());
    }

    myProjectsController = Get.find<MyProjectsController>();
  }

  // Function to submit milestone
  Future<void> submitMilestone(int acceptedJobId, String title,
      String description) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.submitMilestones),
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
        myProjectsController?.loadProjects();
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

  // Function to fetch milestones for a specific accepted job
  Future<void> fetchMilestones(int acceptedJobId) async {
    try {
      final String url = '${ApiEndpoints.submitMilestones}/$acceptedJobId';
      print("Fetching milestones from API: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.token.value}'
        },
      );


      if (response.statusCode == 200) {
        // Success response from the API
        final data = json.decode(response.body);
        milestones.value = List<Map<String, dynamic>>.from(data);

        // Initialize seenMilestones list based on milestones count
        seenMilestones.value = List.generate(milestones.length, (index) => false);

        // Print the fetched milestones for debugging
        print("Fetched milestones: ${milestones.value}");
      } else {
        throw Exception('Failed to load milestones.');
      }
    } catch (e) {
      print("Error fetching milestones: $e");
    }
  }
  // Function to toggle seen status
  void toggleSeen(int index, bool value) {
    seenMilestones[index] = value;
  }
}
