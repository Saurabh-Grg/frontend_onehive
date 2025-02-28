import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              // Get.to(() => ChatScreen(
              //   user: FollowUser(
              //     userId: projectDetails['freelancer']?['id'] ?? 0,
              //     username: projectDetails['freelancer']?['name'] ?? 'Freelancer Name',
              //     profileImageUrl: projectDetails['freelancer']?['profile_image'] ?? '',
              //   ),
              //   userId: projectDetails['freelancer']?['id'] ?? 0,
              //   profileImageUrl: projectDetails['freelancer']?['profile_image'] ?? '',
              // ));
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
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Ti
                    // Project Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${acceptedJob.job.title}',
                            style: TextStyle(
                              fontSize: 20,
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
                    SizedBox(height: 4),

                    Text(
                      'Start Date:  ',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),

                    Text(
                      'Deadline: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // if (projectDetails['milestones'] != null &&
                      //     projectDetails['milestones'] is List)
                      //   Column(
                      //     children: projectDetails['milestones']
                      //         .map<Widget>((milestone) => ListTile(
                      //               title:
                      //                   Text(milestone['title'] ?? 'No Title'),
                      //               subtitle: Text(
                      //                   milestone['status'] ?? 'No Status'),
                      //               trailing: Icon(
                      //                 milestone['status'] == 'Completed'
                      //                     ? Icons.check_circle
                      //                     : Icons.timelapse,
                      //                 color: milestone['status'] == 'Completed'
                      //                     ? Colors.green
                      //                     : Colors.orange,
                      //               ),
                      //             ))
                      //         .toList(),
                      //   )
                      // else
                      //   Text('No milestones available',
                      //       style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
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
                    // Payment Details
                    Text(
                      'Payment & Escrow Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            // Text(
            //   'Client Actions',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            //
            // SizedBox(height: 10),

            // Wrap(
            //   spacing: 10, // Horizontal spacing between buttons
            //   runSpacing: 10, // Vertical spacing between buttons
            //   alignment: WrapAlignment.center,
            //   children: [
            //     // Approve Work Button
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         // Add functionality for approving work
            //       },
            //       icon: Icon(Icons.check, size: 20, color: Colors.white),
            //       // Icon with consistent size
            //       label: Text(
            //         'Approve Work',
            //         style: TextStyle(fontSize: 16), // Consistent text size
            //       ),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             WidgetStateProperty.all<Color>(Colors.green),
            //         // Background color
            //         foregroundColor:
            //             WidgetStateProperty.all<Color>(Colors.white),
            //         // Text and icon color
            //         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            //           EdgeInsets.symmetric(
            //               horizontal: 20, vertical: 12), // Padding
            //         ),
            //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            //           RoundedRectangleBorder(
            //             borderRadius:
            //                 BorderRadius.circular(10), // Rounded corners
            //           ),
            //         ),
            //         overlayColor: WidgetStateProperty.resolveWith<Color>(
            //           (Set<WidgetState> states) {
            //             if (states.contains(WidgetState.pressed)) {
            //               return Colors
            //                   .green.shade700; // Darker green when pressed
            //             }
            //             return Colors.transparent; // No overlay by default
            //           },
            //         ),
            //       ),
            //     ),
            //
            //     // Request Revision Button
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         // Add functionality for requesting revision
            //       },
            //       icon: Icon(
            //         Icons.refresh,
            //         size: 20,
            //         color: Colors.white,
            //       ),
            //       label: Text(
            //         'Request Revision',
            //         style: TextStyle(fontSize: 16),
            //       ),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             WidgetStateProperty.all<Color>(Colors.blue),
            //         foregroundColor:
            //             WidgetStateProperty.all<Color>(Colors.white),
            //         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            //           EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //         ),
            //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //         overlayColor: WidgetStateProperty.resolveWith<Color>(
            //           (Set<WidgetState> states) {
            //             if (states.contains(WidgetState.pressed)) {
            //               return Colors
            //                   .blue.shade700; // Darker blue when pressed
            //             }
            //             return Colors.transparent;
            //           },
            //         ),
            //       ),
            //     ),
            //
            //     // Dispute Button
            //     ElevatedButton.icon(
            //       onPressed: () {
            //         // Add functionality for disputing
            //       },
            //       icon: Icon(Icons.warning, size: 20, color: Colors.white),
            //       label: Text(
            //         'Dispute',
            //         style: TextStyle(fontSize: 16),
            //       ),
            //       style: ButtonStyle(
            //         backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
            //         foregroundColor:
            //             WidgetStateProperty.all<Color>(Colors.white),
            //         padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            //           EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //         ),
            //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //         ),
            //         overlayColor: WidgetStateProperty.resolveWith<Color>(
            //           (Set<WidgetState> states) {
            //             if (states.contains(WidgetState.pressed)) {
            //               return Colors.red.shade700; // Darker red when pressed
            //             }
            //             return Colors.transparent;
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
