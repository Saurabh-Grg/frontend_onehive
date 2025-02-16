import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            icon: Icon(Icons.sort, color: Colors.white),
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

              var filteredProjects = controller.projects.where((p) =>
              (controller.selectedFilter.value == "All" ||
                  p.status == controller.selectedFilter.value) &&
                  p.title.toLowerCase().contains(controller.searchQuery.value.toLowerCase())).toList();

              if (filteredProjects.isEmpty) {
                return Center(child: Text("No projects found."));
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
  final ProjectModel project;

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
            Text(project.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        Text("Deadline: ${project.deadline}",
            style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildBudgetAndPaymentInfo() {
    return Row(
      children: [
        Icon(Icons.attach_money, color: Colors.green),
        SizedBox(width: 4),
        Text("\$${project.budget}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Spacer(),
        Text("Payment Status: ${project.paymentStatus}",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: project.paymentStatus == "Paid" ? Colors.green : Colors.red)),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Client Details:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Client Name: ${project.clientName}",
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 4),
        Text("Contact: ${project.clientContact}",
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
          value: project.progress / 100,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        SizedBox(height: 8),
        Text("${project.progress}% completed", style: TextStyle(color: Colors.blue)),
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
      case "Active":
        color = Colors.blue;
        break;
      case "Completed":
        color = Colors.green;
        break;
      case "Pending":
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(label: Text(status, style: TextStyle(color: Colors.white)), backgroundColor: color);
  }
}
