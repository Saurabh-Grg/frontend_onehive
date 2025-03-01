import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/models/AcceptedJobModel.dart';
import '../controllers/MyProjectController.dart';

class MyProjectsScreen extends StatelessWidget {
  final MyProjectsController controller = Get.put(MyProjectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) => controller.sortProjects(value),
            itemBuilder: (context) => [
              PopupMenuItem(value: "Deadline", child: Text("Sort by Deadline")),
              PopupMenuItem(value: "Budget", child: Text("Sort by Budget")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search projects...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: controller.searchProjects,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              var filteredProjects = controller.acceptedJobs.where((p) =>
              (controller.selectedFilter.value == "All" ||
                  p.status == controller.selectedFilter.value) &&
                  p.job.title.toLowerCase().contains(controller.searchQuery.value.toLowerCase())).toList();

              if (filteredProjects.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_off, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No projects found!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Keep going! Every great freelancer starts somewhere. Stay proactive, keep refining your skills, and new opportunities will come your way!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredProjects.length,
                itemBuilder: (context, index) {
                  final project = filteredProjects[index];
                  return ProjectCard(project);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final AcceptedJob project;

  ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.job.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildStatusRow(),
            SizedBox(height: 8),
            _buildBudgetAndPaymentInfo(),
            SizedBox(height: 8),
            Divider(),
            _buildClientInfo(),
            SizedBox(height: 8),
            _buildProgressBar(),
            SizedBox(height: 8),
            _buildActionsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        _buildChip(project.status),
        Spacer(),
        Text("Deadline: ${project.updatedAt}", // get from job details, this is only for showing
            style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildBudgetAndPaymentInfo() {
    Color getPaymentStatusColor(String status) {
      switch (status.toLowerCase()) {
        case "unpaid":
          return Colors.red;
        case "pending":
          return Colors.orange;
        case "escrowed":
          return Colors.blue;
        case "released":
          return Colors.green;
        case "disputed":
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    return Row(
      children: [
        Icon(Icons.currency_rupee, color: Colors.green),
        SizedBox(width: 4),
        Text("Rs. ${project.budget}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Spacer(),
        Text(
          "Payment Status: ${project.job.paymentStatus}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: getPaymentStatusColor(project.job.paymentStatus),
          ),
        ),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Client Details:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Client Name: ${project.client.username}",
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 4),
        Text("Contact: ${project.client.email}",
            style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Project Progress", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        LinearProgressIndicator(
          // value: project.progress / 100,
          value: 50 / 100,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        SizedBox(height: 8),
        Text("50% completed", style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chat, color: Colors.blue),
          onPressed: () {
            Get.snackbar("Chat", "Messaging feature coming soon!");
          },
        ),
        IconButton(
          icon: Icon(Icons.upload_file, color: Colors.orange),
          onPressed: () {
            Get.snackbar("File Upload", "Upload feature coming soon!");
          },
        ),
        IconButton(
          icon: Icon(Icons.assignment_turned_in, color: Colors.green),
          onPressed: () {
            Get.snackbar("Project Submission", "Submit your work here!");
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            Get.defaultDialog(
              title: "Delete Project",
              content: Text("Are you sure you want to delete this project?"),
              confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar("Deleted", "Project deleted successfully.");
                },
                child: Text("Yes"),
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                child: Text("No"),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChip(String status) {
    Color color;
    switch (status) {
      case "ongoing":
        color = Colors.blue;
        break;
      case "completed":
        color = Colors.green;
        break;
      case "disputed":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(label: Text(status, style: TextStyle(color: Colors.white)), backgroundColor: color);
  }
}
