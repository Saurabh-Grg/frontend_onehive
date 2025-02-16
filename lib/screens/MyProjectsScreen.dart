import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/MyProjectController.dart';

class MyProjectsScreen extends StatelessWidget {
  final MyProjectsController controller = Get.put(MyProjectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) => controller.filterProjects(value),
            itemBuilder: (context) => [
              PopupMenuItem(value: "All", child: Text("All Projects")),
              PopupMenuItem(value: "Active", child: Text("Active")),
              PopupMenuItem(value: "Completed", child: Text("Completed")),
              PopupMenuItem(value: "Pending", child: Text("Pending")),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredProjects = controller.projects.where((p) =>
        controller.selectedFilter.value == "All" ||
            p.status == controller.selectedFilter.value).toList();

        if (filteredProjects.isEmpty) {
          return Center(child: Text("No projects available."));
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
            Text(
              project.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildChip(project.status),
                Spacer(),
                Icon(Icons.attach_money, color: Colors.green),
                SizedBox(width: 4),
                Text("\$${project.budget}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Deadline: ${project.deadline}",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Bid: \$${project.bidAmount}",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment: ${project.paymentStatus}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: project.paymentStatus == "Paid" ? Colors.green : Colors.red,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Get.snackbar("Project Action", "Feature Coming Soon!");
                  },
                  child: Text("Manage"),
                ),
              ],
            ),
          ],
        ),
      ),
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

    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }
}
