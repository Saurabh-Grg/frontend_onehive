import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/FreelancerProfile.dart';
import 'UserController.dart';

class FreelancerProfileController extends GetxController {
  final UserController userController = Get.find();

  // Map to store follow status for each freelancer
  var followStatuses = <int, bool>{}.obs; // Using a map to store follow status

  // State variables
  var isLoading = false.obs;
  var profile = Rxn<FreelancerProfile>();  // i am using this to view freelancer profile in client screen
  var isFollowing = false.obs; // Track follow status
  int? freelancerId;
  int? jobId;
  // var profileData = Rxn<FreelancerProfile>();  // i am using this to view freelancer profile in freelancer screen


  // Initialize the controller with necessary IDs
  void initialize({required int freelancerId, required int jobId}) {
    this.freelancerId = freelancerId;
    this.jobId = jobId;
    print("Controller initialized with freelancerId: $freelancerId, jobId: $jobId");
  }

  // In FreelancerProfileController:
  Future<void> fetchFollowStatus() async {
    if (freelancerId == null) {
      print("Error: freelancerId is null.");
      return;
    }

    try {
      final Uri followStatusUri = Uri.parse(
          'http://localhost:3000/api/follow/status/${userController.userId.value}/$freelancerId');

      final response = await http.get(
        followStatusUri,
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        isFollowing.value = data['isFollowing'];

        // Save the follow status to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFollowing_$freelancerId', isFollowing.value);

      } else {
        print("Failed to fetch follow status. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while fetching follow status: $e");
    }
  }

// Call fetchFollowStatus() on initialization
  @override
  void onInit() {
    super.onInit();
    // fetchProfileData();
    fetchFollowStatus(); // Make sure this is called when the page is loaded
  }

  // void fetchProfileData() async {
  //   try {
  //     isLoading(true);
  //     print('Fetching freelancer profile data...');
  //     print('API URL: http://localhost:3000/api/freelancerProfile/my-profile');
  //     print('Authorization Token: Bearer ${userController.token.value}');
  //
  //     final response = await http.get(
  //       Uri.parse('http://localhost:3000/api/freelancerProfile/my-profile'),
  //       headers: {
  //         'Authorization': 'Bearer ${userController.token.value}', // Add authentication token
  //       },
  //     );
  //
  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(response.body);
  //       print('Parsed JSON Data: $jsonData');
  //       profileData.value = FreelancerProfile.fromJson(jsonData['data']);
  //       print('Profile data successfully updated.');
  //     } else {
  //       print('Error: Failed to fetch profile data, Status Code: ${response.statusCode}');
  //       Get.snackbar('Error', 'Failed to fetch profile data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception occurred while fetching profile data: $e');
  //     Get.snackbar('Error', 'An error occurred: $e');
  //   } finally {
  //     print('Fetch profile data process completed.');
  //     isLoading(false);
  //   }
  // }

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
  Future<void> followFreelancer(int followerId, int followedId) async {
    try {
      final followUri = Uri.parse('http://localhost:3000/api/follow/follow');
      final response = await http.post(
        followUri,
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'followerId': followerId,
          'followedId': followedId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar("Success", data['message']);
        fetchFollowStatus(); // Update the follow status
      } else {
        Get.snackbar("Error", "Failed to follow freelancer");
      }
    } catch (e) {
      print("Error following freelancer: $e");
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> unfollowFreelancer(int followerId, int followedId) async {
    try {
      final unfollowUri = Uri.parse('http://localhost:3000/api/follow/unfollow');
      final response = await http.post(
        unfollowUri,
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'followerId': followerId,
          'followedId': followedId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.snackbar("Success", data['message']);
        fetchFollowStatus(); // Update the follow status
      } else {
        Get.snackbar("Error", "Failed to unfollow freelancer");
      }
    } catch (e) {
      print("Error unfollowing freelancer: $e");
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}