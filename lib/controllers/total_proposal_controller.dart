// controllers/total_proposals_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import '../models/total_proposal_model.dart';
import 'UserController.dart';

class TotalProposalsController extends GetxController {

  final UserController userController = Get.find();

  var isLoading = false.obs;
  var totalProposals = 0.obs;

  // Fetch total proposals
  Future<void> fetchTotalProposals() async {
    isLoading(true);
    try {
      // Make the API call
      final response = await http.get(
        Uri.parse(ApiEndpoints.getTotalNumberOfProposalForAClient),
        headers: {
          'Authorization': 'Bearer ${userController.token.value}', // Include authentication token if required
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var totalProposalsModel = TotalProposalsModel.fromJson(data);
        totalProposals.value = totalProposalsModel.totalProposals;
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch total proposals",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Future<void> acceptProposal(String proposalId) async {
  //   try {
  //     isLoading(true);
  //     // Debugging: Print the proposalId to check if it's correct
  //     print("Proposal ID: $proposalId");
  //
  //     String apiUrl = "${ApiEndpoints.acceptProposalByClient}/$proposalId";
  //     // Debugging: Print the URI
  //     print("API URL: $apiUrl");
  //
  //
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": 'Bearer ${userController.token.value}',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Get.snackbar("Success", "Proposal accepted successfully.");
  //       return true; // Success
  //     } else {
  //       var errorMessage = json.decode(response.body)['error'] ?? "Error occurred.";
  //       Get.snackbar("Error", errorMessage);
  //       print(errorMessage);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong. Please try again.");
  //     print("Error occurred: $e"); // Print the error for debugging
  //   } finally {
  //     isLoading(false);
  //   }
  // }

// Refactor the acceptProposal method to return a success/failure boolean
  Future<bool> acceptProposal(String proposalId) async {
    try {
      isLoading(true);

      String apiUrl = "${ApiEndpoints.acceptProposalByClient}/$proposalId";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${userController.token.value}',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Proposal accepted successfully.");
        return true; // Success
      } else {
        var errorMessage = json.decode(response.body)['error'] ?? "Error occurred.";
        Get.snackbar("Error", errorMessage);
        return false; // Failure
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
      print("Error occurred: $e");
      return false; // Failure
    } finally {
      isLoading(false);
    }
  }
}
