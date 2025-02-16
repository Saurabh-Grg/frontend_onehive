import 'package:get/get.dart';

class MyProjectsController extends GetxController {
  var isLoading = true.obs;
  var projects = <ProjectModel>[].obs;
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs; // Search field
  var sortBy = 'Deadline'.obs; // Sorting field

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
        milestones: ["UI Design Completed", "Backend API Integrated"],
        clientName: "John Doe", // Added
        clientContact: "+1 234 567 890", // Added
        progress: 50, // Added
      ),
      ProjectModel(
        title: "E-commerce Website Design",
        status: "Completed",
        budget: 800,
        deadline: "Jan 15, 2025",
        bidAmount: 750,
        paymentStatus: "Paid",
        milestones: ["Prototype Approved", "Final Version Deployed"],
        clientName: "Jane Smith", // Added
        clientContact: "+1 987 654 321", // Added
        progress: 100, // Added
      ),
      ProjectModel(
        title: "Logo & Branding for Startup",
        status: "Pending",
        budget: 150,
        deadline: "Mar 10, 2025",
        bidAmount: 140,
        paymentStatus: "Unpaid",
        milestones: ["Initial Concepts Ready"],
        clientName: "Acme Corp", // Added
        clientContact: "+1 555 123 456", // Added
        progress: 10, // Added
      ),
    ];
    isLoading.value = false;
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
      projects.sort((a, b) => a.deadline.compareTo(b.deadline));
    } else if (criteria == 'Budget') {
      projects.sort((a, b) => b.budget.compareTo(a.budget));
    }
  }
}

class ProjectModel {
  String title;
  String status;
  int budget;
  String deadline;
  int bidAmount;
  String paymentStatus;
  List<String> milestones;
  String clientName; // Added
  String clientContact; // Added
  double progress; // Added (percentage of progress)

  ProjectModel({
    required this.title,
    required this.status,
    required this.budget,
    required this.deadline,
    required this.bidAmount,
    required this.paymentStatus,
    required this.milestones,
    required this.clientName, // Added
    required this.clientContact, // Added
    required this.progress, // Added
  });
}

