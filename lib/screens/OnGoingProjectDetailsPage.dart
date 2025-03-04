import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/MilestoneController.dart';

import '../controllers/AcceptedJobController.dart';
import '../models/AcceptedJobModel.dart';
import '../models/FollowUser.dart';
import 'ChatPage.dart';

class OngoingProjectDetailsPage extends StatelessWidget {
  final AcceptedJob acceptedJob; // Declare the acceptedJob parameter

  // Accepting the job details through constructor
  OngoingProjectDetailsPage({required this.acceptedJob});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final MilestoneController milestoneController = Get.put(MilestoneController());

    // Fetch milestones when this page loads
    milestoneController.fetchMilestones(acceptedJob.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ongoing Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Get.snackbar('Coming soon',
                  'Direct chatting with the freelancer feature will soon be available');
            },
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Direct Call Functionality
              Get.snackbar('Coming soon',
                  'Direct calling the freelancer feature will soon be available');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: (){
                  // display job details
                },
                splashColor: Colors.yellow[100],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${acceptedJob.job.title}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Chip(
                            label: Text(
                              '${acceptedJob.job.paymentStatus}',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                            acceptedJob.job.paymentStatus == 'paid'
                                    ? Colors.green
                                    : Colors.deepOrange,
                          ),
                        ],
                      ),

                      // Project Details
                      Text(
                        'Category: ${acceptedJob.job.category}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),

                      Text(
                        'Description: ${acceptedJob.job.description}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),

            SizedBox(
              height: screenWidth * 0.02,
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Freelancer Details
                    Text(
                      'Freelancer Assigned',
                      style:
                          TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // backgroundImage: projectDetails['freelancer']
                          //                 ?['profile_image'] !=
                          //             null &&
                          //         projectDetails['freelancer']['profile_image']
                          //             .isNotEmpty
                          //     ? NetworkImage(
                          //         projectDetails['freelancer']['profile_image'])
                          //     : AssetImage('assets/images/default_profile.png')
                          //         as ImageProvider,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              acceptedJob.freelancer.username ??
                                  'Freelancer Name',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.036, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '⭐ freelancer rating',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.orange),
                            ),
                            Text(
                              'Experience: ... years',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),

            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Work Progress Section
                      Text(
                        'Work Progress',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Display milestones
                      Obx(() {
                        if (milestoneController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        // Check conditions to show the reminder
                        if (acceptedJob.job.paymentStatus == 'unpaid' && milestoneController.milestones.length == 4) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100], // Light yellow background
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.amber[800]),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Your project is nearing completion. Please ensure the payment is processed soon.",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Continue with milestone list
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: milestoneController.milestones.length,
                                itemBuilder: (context, index) {
                                  var milestone = milestoneController.milestones[index];
                                  double progress = milestone['progress'].toDouble();

                                  // Determine the color based on the progress value
                                  Color progressColor;
                                  if (progress <= 20) {
                                    progressColor = Colors.red;
                                  } else if (progress <= 40) {
                                    progressColor = Colors.orange;
                                  } else if (progress <= 60) {
                                    progressColor = Colors.yellow;
                                  } else if (progress <= 80) {
                                    progressColor = Colors.blue;
                                  } else {
                                    progressColor = Colors.green;
                                  }

                                  return ListTile(
                                    leading: Obx(() {
                                      return SizedBox(
                                        width: Get.width * 0.02,
                                        child: Checkbox(
                                          value: milestoneController.seenMilestones[index],
                                          onChanged: (bool? value) {
                                            milestoneController.toggleSeen(index, value!);
                                          },
                                        ),
                                      );
                                    }),
                                    title: Text(milestone['title'] ?? 'No Title'),
                                    subtitle: Text(milestone['description'] ?? 'No Description'),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("Progress: ${milestone['progress']}%"),
                                        SizedBox(height: 8),
                                        // The colored progress bar
                                        Container(
                                          width: Get.width * 0.2,
                                          child: LinearProgressIndicator(
                                            value: progress / 100,
                                            backgroundColor: Colors.grey[300],
                                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }

                        if (milestoneController.milestones.isEmpty) {
                          return Center(
                            child: Text(
                              'No milestones available for this job.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: milestoneController.milestones.length,
                          itemBuilder: (context, index) {
                            var milestone = milestoneController.milestones[index];
                            double progress = milestone['progress'].toDouble();

                            // Determine the color based on the progress value
                            Color progressColor;
                            if (progress <= 20) {
                              progressColor = Colors.red;
                            } else if (progress <= 40) {
                              progressColor = Colors.orange;
                            } else if (progress <= 60) {
                              progressColor = Colors.yellow;
                            } else if (progress <= 80) {
                              progressColor = Colors.blue;
                            } else {
                              progressColor = Colors.green;
                            }

                            return ListTile(
                              leading: Obx(() {
                                return SizedBox(
                                  // height: 100,
                                  width: Get.width * 0.02,
                                  child: Checkbox(
                                    value: milestoneController.seenMilestones[index],
                                    onChanged: (bool? value) {
                                      milestoneController.toggleSeen(index, value!);
                                    },
                                  ),
                                );
                              }),
                              title: Text(milestone['title'] ?? 'No Title'),
                              subtitle: Text(milestone['description'] ?? 'No Description'),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Progress: ${milestone['progress']}%"),
                                  SizedBox(height: 8),
                                  // The colored progress bar
                                  Container(
                                    width: Get.width * 0.2,
                                    child: LinearProgressIndicator(
                                      value: progress / 100,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.02),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Details
                    Text(
                      'Payment & Escrow Details',
                      style:
                          TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text('Total Budget'),
                      trailing: Text(
                        'Rs. ${acceptedJob.budget}',
                        style: TextStyle(fontSize: 15),  // Set the font size here
                      ),
                    ),
                    ListTile(
                      title: Text('Escrow'),
                      trailing: Text(
                        '${acceptedJob.useEscrow}',
                        style: TextStyle(fontSize: 15),  // Set the font size here
                      ),
                    ),
                    ListTile(
                      title: Text('Escrow amount'),
                      trailing: Text(
                        'Rs. ${acceptedJob.escrowCharge}',
                        style: TextStyle(fontSize: 15),  // Set the font size here
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            Divider(),


            // Client Actions
            Text(
              'Client Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Wrap(
              spacing: 10, // Horizontal spacing between buttons
              runSpacing: 10, // Vertical spacing between buttons
              alignment: WrapAlignment.center,
              children: [
                // Approve Work Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Add functionality for approving work
                  },
                  icon: Icon(Icons.check, size: 20, color: Colors.white),
                  // Icon with consistent size
                  label: Text(
                    'Approve Work',
                    style: TextStyle(fontSize: 16), // Consistent text size
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.green),
                    // Background color
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    // Text and icon color
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // Padding
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    overlayColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors
                              .green.shade700; // Darker green when pressed
                        }
                        return Colors.transparent; // No overlay by default
                      },
                    ),
                  ),
                ),

                // Request Revision Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Add functionality for requesting revision
                  },
                  icon: Icon(
                    Icons.refresh,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Request Revision',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    overlayColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors
                              .blue.shade700; // Darker blue when pressed
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                ),

                // Dispute Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Add functionality for disputing
                  },
                  icon: Icon(Icons.warning, size: 20, color: Colors.white),
                  label: Text(
                    'Dispute',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    overlayColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.red.shade700; // Darker red when pressed
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
