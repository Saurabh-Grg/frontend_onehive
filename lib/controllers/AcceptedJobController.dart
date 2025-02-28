import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/AcceptedJobModel.dart';
import 'UserController.dart';

class AcceptedJobsController extends GetxController {
  final UserController userController = Get.find();

  var acceptedJobs = <AcceptedJob>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAcceptedJobs();
    super.onInit();
  }

  Future<void> fetchAcceptedJobs() async {
    try {
      isLoading(true);
      print("Fetching accepted jobs...");

      var response = await http.get(
        Uri.parse("http://localhost:3000/api/acceptedJobs/fetch"),
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      print("Response Status Code: ${response.statusCode}");
      print("Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print("Parsed JSON Data: $jsonData");

        if (jsonData.containsKey('acceptedJobs')) {
          acceptedJobs.value = (jsonData['acceptedJobs'] as List)
              .map((job) => AcceptedJob.fromJson(job))
              .toList();
          print("Accepted Jobs List Updated: ${acceptedJobs.length} items");
        } else {
          print("Error: 'acceptedJobs' key not found in response");
          Get.snackbar("Error", "Invalid response format");
        }
      } else {
        print("Failed to fetch jobs. Status: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load accepted jobs");
      }
    } catch (e) {
      print("Exception occurred: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
      print("Fetching completed. isLoading: ${isLoading.value}");
    }
  }
}
