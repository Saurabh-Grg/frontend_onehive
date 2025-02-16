import 'package:get/get.dart';

class MyProjectsController extends GetxController {
  var isLoading = true.obs;
  var projects = <ProjectModel>[].obs;
  var selectedFilter = 'All'.obs; // To track filter selection

  @override
  void onInit() {
    fetchProjects();
    super.onInit();
  }

  void fetchProjects() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating API delay
    projects.value = [
      ProjectModel(
        title: "Flutter Mobile App Development",
        status: "Active",
        budget: 500,
        deadline: "Feb 28, 2025",
        bidAmount: 450,
        paymentStatus: "Pending",
      ),
      ProjectModel(
        title: "E-commerce Website Design",
        status: "Completed",
        budget: 800,
        deadline: "Jan 15, 2025",
        bidAmount: 750,
        paymentStatus: "Paid",
      ),
      ProjectModel(
        title: "Logo & Branding for Startup",
        status: "Pending",
        budget: 150,
        deadline: "Mar 10, 2025",
        bidAmount: 140,
        paymentStatus: "Unpaid",
      ),
    ];
    isLoading.value = false;
  }

  void filterProjects(String status) {
    selectedFilter.value = status;
  }
}

class ProjectModel {
  String title;
  String status;
  int budget;
  String deadline;
  int bidAmount;
  String paymentStatus;

  ProjectModel({
    required this.title,
    required this.status,
    required this.budget,
    required this.deadline,
    required this.bidAmount,
    required this.paymentStatus,
  });
}
