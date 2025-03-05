import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/FinalSubmissionController.dart';
import 'package:onehive_frontend/controllers/MilestoneController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/AcceptedJobModel.dart';

class OngoingProjectDetailsPage extends StatelessWidget {
  final AcceptedJob acceptedJob; // Declare the acceptedJob parameter

  // Accepting the job details through constructor
  OngoingProjectDetailsPage({required this.acceptedJob});

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final MilestoneController milestoneController =
        Get.put(MilestoneController());

    // Fetch milestones when this page loads
    milestoneController.fetchMilestones(acceptedJob.id);

    final FinalSubmissionController finalSubmissionController =
        Get.put(FinalSubmissionController());
    finalSubmissionController.fetchFinalSubmissions(acceptedJob.id);

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
            Obx(() {
              if (finalSubmissionController.finalSubmissions.isEmpty) {
                return SizedBox();
              }
              return Container(
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
                        "You have received the final submission for your project. Please review the submission and complete the payment to finalize the process.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {
                  // display job details
                },
                splashColor: Colors.yellow[100],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            backgroundColor: _getPaymentStatusColor(
                                acceptedJob.job.paymentStatus),
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
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: acceptedJob
                                  .freelancer.profileImageUrl.isNotEmpty
                              ? NetworkImage(
                                  acceptedJob.freelancer.profileImageUrl)
                              : AssetImage('assets/images/default_profile.png'),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              acceptedJob.freelancer.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.036,
                              ),
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
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Display milestones
                      Obx(() {
                        if (milestoneController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        // Check conditions to show the reminder
                        if (acceptedJob.job.paymentStatus == 'unpaid' &&
                            milestoneController.milestones.length == 4) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  // Light yellow background
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.amber, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        color: Colors.amber[800]),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Your project is nearing completion. Please ensure the payment is processed soon.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Continue with milestone list
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    milestoneController.milestones.length,
                                itemBuilder: (context, index) {
                                  var milestone =
                                      milestoneController.milestones[index];
                                  double progress =
                                      milestone['progress'].toDouble();

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
                                          value: milestoneController
                                              .seenMilestones[index],
                                          onChanged: (bool? value) {
                                            milestoneController.toggleSeen(
                                                index, value!);
                                          },
                                        ),
                                      );
                                    }),
                                    title:
                                        Text(milestone['title'] ?? 'No Title'),
                                    subtitle: Text(milestone['description'] ??
                                        'No Description'),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            "Progress: ${milestone['progress']}%"),
                                        SizedBox(height: 8),
                                        // The colored progress bar
                                        Container(
                                          width: Get.width * 0.2,
                                          child: LinearProgressIndicator(
                                            value: progress / 100,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    progressColor),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: milestoneController.milestones.length,
                          itemBuilder: (context, index) {
                            var milestone =
                                milestoneController.milestones[index];
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
                                    value: milestoneController
                                        .seenMilestones[index],
                                    onChanged: (bool? value) {
                                      milestoneController.toggleSeen(
                                          index, value!);
                                    },
                                  ),
                                );
                              }),
                              title: Text(milestone['title'] ?? 'No Title'),
                              subtitle: Text(
                                  milestone['description'] ?? 'No Description'),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          progressColor),
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
            // Display Final Submissions only if there are any
            Obx(() {
              if (finalSubmissionController.finalSubmissions.isEmpty) {
                return SizedBox(); // Don't show anything if no submissions
              }
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        'Final Submission',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // List of submissions
                      Column(
                        children: finalSubmissionController.finalSubmissions
                            .map((submission) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  submission.submissionType == "drive_link"
                                      ? "Google Drive Submission"
                                      : "Other Submission",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Link: ${submission.submissionValue}"),
                                Text(
                                  "Remarks: ${submission.remark}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: submission.submissionType == "drive_link"
                                ? IconButton(
                                    icon: Icon(Icons.open_in_new,
                                        color: Colors.blue),
                                    onPressed: () {
                                      // Open the submission link
                                      launchURL(submission.submissionValue);
                                    },
                                  )
                                : null,
                          );
                        }).toList(),
                      ),
                      if (finalSubmissionController.finalSubmissions
                          .any((submission) => submission.status == "pending"))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Approve action
                                // finalSubmissionController.approveSubmission();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.hand_thumbsup_fill,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  Text(
                                    'Approve',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // finalSubmissionController.rejectSubmission();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.hand_thumbsdown_fill,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            "${finalSubmissionController.finalSubmissions.first.status.toUpperCase()}!!!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getSubmissionStatusColor(
                                  finalSubmissionController
                                      .finalSubmissions.first.status),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),

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
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Budget'),
                              Text('Rs. ${acceptedJob.budget}')
                            ],
                          ),
                          SizedBox(height: Get.height * 0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Escrow'),
                              Text('${acceptedJob.useEscrow}')
                            ],
                          ),
                          SizedBox(height: Get.height * 0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Escrow amount'),
                              Text('Rs. ${acceptedJob.escrowCharge}')
                            ],
                          ),
                        ],
                      ),
                    ),
                    acceptedJob.job.paymentStatus == 'unpaid'
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/esewa_logo.png',
                                  width: 30, // Adjust size as needed
                                  height: 30,
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle payment action here
                                  },
                                  child: Text(
                                    'Pay now!',
                                    style: TextStyle(
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              '${acceptedJob.job.paymentStatus.toUpperCase()}!!!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
          ],
        ),
      ),
    );
  }

  Color _getSubmissionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  // Function to get color based on payment status
  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      case 'escrowed':
        return Colors.blue;
      case 'released':
        return Colors.purple;
      case 'pending':
        return Colors.orange;
      case 'disputed':
        return Colors.grey;
      default:
        return Colors.black; // Default color if status is unknown
    }
  }
}
