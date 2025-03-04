import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/FinalSubmissionController.dart';
import 'package:onehive_frontend/models/AcceptedJobModel.dart';
import '../controllers/MilestoneController.dart';
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
        Text("Deadline: coming soon!", // get from job details, this is only for showing
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
          onPressed: (){

          }
        ),
        IconButton(
          icon: Icon(Icons.check_circle, color: Colors.purple), // New icon for milestone submission
          onPressed: () {
            _showMilestoneDialog(context, project.id);  // Pass the project id here
          },
        ),
        IconButton(
          icon: Icon(Icons.assignment_turned_in, color: Colors.green),
          onPressed: () {
            showFinalSubmissionDialog(context, project.id);

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

  void _showMilestoneDialog(BuildContext context, int acceptedJobId) {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      "Submit Milestone",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Milestone Title Input
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Milestone Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.title),
                          ),
                          onSaved: (value) {
                            title = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a milestone title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),

                        // Milestone Description Input
                        TextFormField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Milestone Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 3,
                          onSaved: (value) {
                            description = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a milestone description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                        ),
                        child: Text("Cancel"),
                      ),

                      // Submit Button
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _submitMilestone(acceptedJobId, title, description);
                            Get.back(); // Close the dialog
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange, // Button color
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitMilestone(int acceptedJobId, String title, String description) async {
    final milestoneController = Get.put(MilestoneController());

    // Call the API to submit the milestone
    try {
      await milestoneController.submitMilestone(acceptedJobId, title, description);

      // Show success message in the UI
      Get.snackbar("Milestone Submitted", "Your milestone has been submitted successfully!");
      Get.back();  // Close the dialog after successful submission
    } catch (e) {
      // Handle failure (e.g., show an error message)
      print("Error, Failed to submit milestone. Please try again.");
    }
  }

  void showFinalSubmissionDialog(BuildContext context, int acceptedJobId) {
    final _formKey = GlobalKey<FormState>();
    String submissionType = 'zip(max 50MB)'; // Default selection
    String submissionValue = '';
    String remarks = '';

    Future<void> pickZipFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'], // Only allow ZIP files
      );

      if (result != null && result.files.isNotEmpty) {
        submissionValue = result.files.single.path ?? '';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // ✅ Wrap in StatefulBuilder to update UI
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Final Project Submission",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "You're ready to submit your project—great job! Review your work, add any final remarks or attachments, and take pride in reaching this milestone. You're one step closer to your goal—keep it up!",
                            ),
                            SizedBox(height:  Get.height * 0.02),

                            // ✅ Dropdown to select submission type
                            DropdownButtonFormField<String>(
                              value: submissionType,
                              decoration: InputDecoration(
                                hintText: "Submission Type",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: ["zip(max 50MB)", "drive_link", "other_link"]
                                  .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    submissionType = value; // ✅ Update UI
                                  });
                                }
                              },
                            ),
                            SizedBox(height:  Get.height * 0.01),

                            // ✅ ZIP File Picker
                            if (submissionType == "zip(max 50MB)")
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black, // Border color
                                    width: 0.9, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(10), // Rounded corners
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3), // Padding inside the container
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.attach_file),
                                      onPressed: pickZipFile,
                                    ),
                                    Expanded(
                                      child: Text(
                                        submissionValue.isNotEmpty
                                            ? submissionValue.split('/').last
                                            : 'No file selected',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                            // ✅ Show TextFormField when submission type is a link
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Submission Link',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  prefixIcon: Icon(Icons.link),
                                ),
                                onSaved: (value) {
                                  submissionValue = value ?? '';
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please provide a valid submission';
                                  }
                                  return null;
                                },
                              ),

                            SizedBox(height:  Get.height * 0.01),
                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Remarks (Optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.comment),
                              ),
                              maxLines: 3,
                              onSaved: (value) {
                                remarks = value ?? '';
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:  Get.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepOrange,
                            ),
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                _submitFinalSubmission(acceptedJobId, submissionType, submissionValue, remarks);
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitFinalSubmission(int acceptedJobId, String type, String value, String remarks) async {
    final finalSubmissionController = Get.put(FinalSubmissionController());
    // Call the API to submit the final project
    try {
      await finalSubmissionController.submitFinalProject(acceptedJobId, type, value, remarks);
      // Show success message in the UI
      Get.snackbar("Project Submitted", "Your project has been submitted successfully!");
      Get.back();

    } catch (e) {
      // Handle failure (e.g., show an error message)
      print("Error, Failed to submit the project. Please try again.");
      print("Error Details: $e"); // Debugging line
    }
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
