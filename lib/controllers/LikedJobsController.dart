import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';

import 'UserController.dart';

class LikedJobsController extends GetxController {
  // Observable list to track liked jobs
  var likedJobs = <int>[].obs;

  final UserController userController = Get.put(UserController());

  // Toggle like/unlike job
  Future<void> toggleLikeJob(int jobId) async {
    // Check if the job is already liked
    if (likedJobs.contains(jobId)) {
      likedJobs.remove(jobId); // Unlike the job if it's already liked
      await unlikeJob(jobId);  // Call API to unlike the job
    } else {
      likedJobs.add(jobId); // Add job to liked jobs list
      await likeJob(jobId);  // Call API to like the job
    }
  }

  // Call backend API to like the job
  Future<void> likeJob(int jobId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.likeOrUnlikeJobs),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${userController.token.value}',
        },
        body: jsonEncode({
          'freelancerId': userController.userId.value,
          'jobId': jobId,
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Liked", "Job successfully added to your liked list.");
      } else {
        Get.snackbar("Error", "Failed to like the job.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server.");
    }
  }

  // Call backend API to unlike the job
  Future<void> unlikeJob(int jobId) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiEndpoints.likeOrUnlikeJobs),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${userController.token.value}',
        },
        body: jsonEncode({
          'freelancerId': userController.userId.value,
          'jobId': jobId,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Unliked", "Job successfully removed from your liked list.");
      } else {
        Get.snackbar("Error", "Failed to unlike the job.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server.");
    }
  }

  // Fetch liked jobs from backend
  Future<void> fetchLikedJobs() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.getLikedJobs}/${userController.userId.value}'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        likedJobs.value = List<int>.from(data.map((job) => job['job_id']));
      } else {
        Get.snackbar("Error", "Failed to load liked jobs.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to the server.");
    }
  }
}
