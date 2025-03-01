import 'dart:convert';

import 'package:get/get.dart';
import 'package:onehive_frontend/constants/apis_endpoints.dart';

import '../models/AcceptedJobModel.dart';
import 'UserController.dart';
import 'package:http/http.dart' as http;

class MyProjectsController extends GetxController {
  final UserController userController = Get.find();
  var isLoading = true.obs;
  var acceptedJobs = <AcceptedJob>[].obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs; // Search field
  var sortBy = 'Deadline'.obs; // Sorting field

  @override
  void onInit() {
    fetchProjects();
    super.onInit();
  }

  void fetchProjects() async {
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    try {
      isLoading(true);
      String token = "${userController.token.value}"; // Replace with actual token handling
      final response = await http.get(
        Uri.parse("${ApiEndpoints.getAcceptedJobForFreelancer}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var jobsList = (data['acceptedJobs'] as List)
            .map((job) => AcceptedJob.fromJson(job))
            .toList();

        acceptedJobs.assignAll(jobsList);
      } else {
        Get.snackbar("Error", "Failed to fetch accepted jobs");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void filterProjects(String status) {
    selectedFilter.value = status;
  }

  void searchProjects(String query) {
    searchQuery.value = query;
  }

  void sortProjects(String criteria) {
    sortBy.value = criteria;
    if (criteria == 'Deadline') {
      acceptedJobs.sort((a, b) => a.updatedAt.compareTo(b.updatedAt)); // here updated data should be replaced by end data from job details
    } else if (criteria == 'Budget') {
      acceptedJobs.sort((a, b) => b.budget.compareTo(a.budget));
    }
  }
}


