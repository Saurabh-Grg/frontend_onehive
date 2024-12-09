import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/FreelancerProfile.dart';
import 'UserController.dart';

class FreelancerProfileController extends GetxController {
  final UserController userController = Get.find();

  // State variables
  var isLoading = false.obs;
  var profile = Rxn<FreelancerProfile>();
  int? freelancerId;
  int? jobId;

  // Initialize the controller with necessary IDs
  void initialize({required int freelancerId, required int jobId}) {
    this.freelancerId = freelancerId;
    this.jobId = jobId;
    print("Controller initialized with freelancerId: $freelancerId, jobId: $jobId");
  }

  Future<void> fetchFreelancerProfile(int userId) async {
    if (freelancerId == null || jobId == null) {
      print("Error: freelancerId or jobId is null. Cannot fetch profile.");
      Get.snackbar("Error", "Freelancer ID or Job ID is missing.");
      return;
    }
    isLoading(true);
    try {
      // Check the freelancerId and jobId values before making the API request
      print("Fetching profile for freelancerId: $freelancerId and jobId: $jobId");

      final checkProfileUri = Uri.parse('http://localhost:3000/api/freelancerProfile/check-profile/$userId');
      print("Check profile URI: $checkProfileUri");

      final response = await http.get(
        checkProfileUri,
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
        },
      );

      print("Check profile response status: ${response.statusCode}");
      print("Check profile response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['profileExists'] == true) {
          print("Profile exists. Fetching detailed profile...");

          // Build the profile details URI
          final profileDetailsUri = Uri.parse('http://localhost:3000/api/freelancerProfile/freelancer-profile/$freelancerId/$jobId');
          print("Profile details URI: $profileDetailsUri");

          final profileResponse = await http.get(
            profileDetailsUri,
            headers: {
              'Authorization': 'Bearer ${userController.token.value}',
            },
          );

          print("Profile details response status: ${profileResponse.statusCode}");
          print("Profile details response body: ${profileResponse.body}");

          if (profileResponse.statusCode == 200) {
            final profileData = json.decode(profileResponse.body);
            if (profileData != null && profileData['profile'] != null) {
              profile.value = FreelancerProfile.fromJson(profileData['profile']);
              print("Parsed Freelancer Profile: ${profile.value?.toJson()}");
              print("Freelancer profile fetched successfully.");
            } else {
              print("Profile data is null or missing in the response.");
              Get.snackbar("Error", "Profile data not found.");
            }
          } else {
            print("Failed to fetch profile details. Status: ${profileResponse.statusCode}");
            Get.snackbar("Error", "Failed to fetch profile details. Status: ${profileResponse.statusCode}");
          }
        } else {
          print("Profile does not exist for userId: $userId");
          Get.snackbar("Profile Not Found", "Please create a profile.");
        }
      } else {
        print("Failed to check profile existence. Status: ${response.statusCode}");
        Get.snackbar("Error", "Failed to check profile existence. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching profile: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}