import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'dart:convert';
import '../models/AcceptedJobModel.dart';
import 'UserController.dart';

class AcceptedJobsController extends GetxController {
  final UserController userController = Get.find();

  var acceptedJobs = <AcceptedJob>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedJobs();
  }

  Future<void> fetchAcceptedJobs() async {
    try {
      isLoading(true);

      var response = await http.get(
        Uri.parse("${ApiEndpoints.getAcceptedJobForClient}"),
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('acceptedJobs')) {
          acceptedJobs.value = (jsonData['acceptedJobs'] as List)
              .map((job) => AcceptedJob.fromJson(job))
              .toList();
        } else {
          Get.snackbar("Error", "Invalid response format");
        }
      } else {
        Get.snackbar("Error", "Failed to load accepted jobs");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  // To force a reload of projects, useful if you want to call it explicitly
  void loadProjects() async {
    fetchAcceptedJobs();
  }
}
