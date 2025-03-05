import 'dart:convert';
import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/UserController.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/models/FinalSubmissionModel.dart';

class FinalSubmissionController extends GetxController {
  final UserController userController = Get.find();

  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;

  var finalSubmissions = <FinalSubmissionModel>[].obs;

  // Submit the final project submission
  Future<void> submitFinalProject(int acceptedJobId, String type, String value, String remarks) async {
    try {
      // Set the loading state to true before making the request
      isLoading.value = true;
      errorMessage.value = ''; // Reset error message on new attempt

      // Make the POST request to submit the final project
      final response = await http.post(
        Uri.parse("http://localhost:3000/api/final-submissions/submit"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.token.value}' // Include token for authorization
        },
        body: json.encode({
          'accepted_job_id': acceptedJobId,
          'submission_type': type,
          'submission_value': value,
          'remarks': remarks,
        }),
      );
      // Handle the response based on the status code
      if (response.statusCode == 201) {
        successMessage.value = 'Final submission uploaded successfully!';
        Get.snackbar("Project Submitted", successMessage.value);
      } else {
        // If the server returns an error, handle the error accordingly
        var responseBody = json.decode(response.body);
        errorMessage.value = responseBody['message'] ?? 'An error occurred';
        print("API Error: ${responseBody['message']}");
      }
    } catch (error) {
      errorMessage.value = 'Server error: ${error.toString()}';
      print("Error Details: $error");
    } finally {
      // Set the loading state back to false after request completion
      isLoading.value = false;
    }
  }

  // Fetch final submissions for a job
  Future<void> fetchFinalSubmissions(int acceptedJobId) async {
    try {
      print("Fetching final submissions for job ID: $acceptedJobId");

      isLoading.value = true;
      errorMessage.value = '';

      final url = "http://localhost:3000/api/final-submissions/job/$acceptedJobId";
      print("API URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${userController.token.value}'
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print("Decoded Response: $responseBody");

        if (responseBody.containsKey('data')) {
          List submissionsData = responseBody['data'];
          print("Submissions Data: $submissionsData");

          finalSubmissions.value = submissionsData.map((json) => FinalSubmissionModel.fromJson(json)).toList();
          print("Parsed Final Submissions: $finalSubmissions");
        } else {
          print("API response does not contain 'data' key.");
          errorMessage.value = "Invalid API response format.";
        }
      } else {
        var responseBody = json.decode(response.body);
        errorMessage.value = responseBody['message'] ?? 'Failed to fetch submissions';
        print("API Error Message: ${responseBody['message']}");
      }
    } catch (error, stackTrace) {
      errorMessage.value = 'Server error: ${error.toString()}';
      print("Error Details: $error");
      print("Stack Trace: $stackTrace");
    } finally {
      isLoading.value = false;
      print("Fetching process completed. isLoading: ${isLoading.value}");
    }
  }

  Future<void> updateFinalSubmissionStatus(int submissionId, String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Make PUT request to update submission status
      final response = await http.put(
        Uri.parse("http://localhost:3000/api/final-submissions/$submissionId/status"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.token.value}'
        },
        body: json.encode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        successMessage.value = 'Final submission ${status}.';
        Get.snackbar("Submission Status Updated", successMessage.value);
        // Optionally, fetch the final submissions again to refresh the data
        fetchFinalSubmissions(submissionId);
      } else {
        var responseBody = json.decode(response.body);
        errorMessage.value = responseBody['message'] ?? 'Failed to update submission status';
      }
    } catch (error) {
      errorMessage.value = 'Server error: ${error.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

}
