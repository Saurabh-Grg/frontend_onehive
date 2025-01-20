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
}
