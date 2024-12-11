import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/FreelancerProfileController.dart';
import 'FullScreenImageView.dart';

class FreelancerProfilePage extends StatelessWidget {
  final int
      freelancerId; // Use int for consistency if IDs are stored as integers
  final int jobId;
  final FreelancerProfileController controller =
      Get.put(FreelancerProfileController());

  FreelancerProfilePage(
      {Key? key, required this.freelancerId, required this.jobId})
      : super(key: key) {
    // Initialize the controller with the provided IDs
    controller.initialize(freelancerId: freelancerId, jobId: jobId);
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Navigated to FreelancerProfilePage with freelancerId: $freelancerId");

    // Fetch the freelancer profile on page load
    controller.fetchFreelancerProfile(freelancerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OneHive",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.profile.value == null) {
          return Center(child: Text("No profile found."));
        }

        final profile = controller.profile.value!;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Profile --> ", // Static text in black
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: profile.name ?? "No Name",
                            // Dynamic text in orange
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Spacer(), // Pushes the rating to the right
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          // Generate 5 stars with partial fill logic
                          double rating = 4.5; // Placeholder rating
                          if (index + 1 <= rating) {
                            // Full star
                            return Icon(Icons.star,
                                color: Colors.orange, size: 16);
                          } else if (index + 0.5 == rating) {
                            // Half star
                            return Icon(Icons.star_half,
                                color: Colors.orange, size: 16);
                          } else {
                            // Empty star
                            return Icon(Icons.star_border,
                                color: Colors.grey, size: 16);
                          }
                        }),
                        SizedBox(width: 4),
                        // Spacing between stars and the text
                        Text(
                          "4.5", // Display the rating value
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (profile.profileImageUrl != null)
                GestureDetector(
                  onTap: () {
                    // Navigate to the fullscreen image view
                    Get.to(() => FullScreenImageView(
                        imageUrl: profile.profileImageUrl!));
                  },
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width, // Full screen width
                    height: MediaQuery.of(context).size.height *
                        0.2, // 30% of the screen height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profile.profileImageUrl!),
                        fit: BoxFit
                            .cover, // Adjust the image to cover the container
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                // Remove left padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Profile image as a CircleAvatar
                        CircleAvatar(
                          radius: Get.width * 0.1, // Set the radius of the circle
                          backgroundImage: profile.profileImageUrl != null
                              ? NetworkImage(profile.profileImageUrl!)
                              : AssetImage('assets/default_avatar.png') as ImageProvider, // Use default if no image
                        ),
                        SizedBox(width: Get.width * 0.03,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              // Align to the start of the screen
                              child: Text(
                                profile.name ?? "No Name",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red,),
                                Text('${profile.city}, Nepal', style: TextStyle(color: Colors.grey[600]),)
                              ],
                            ),
                            Text('Member since: ${profile.createdAt}', style: TextStyle(color: Colors.grey[600]),)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft, // Align bio to the start
                      child: Text(
                        profile.bio ?? "No Bio",
                        style: TextStyle(
                          fontSize: 16, // Adjust font size for bio if needed
                          color: Colors.black, // Optional: subtle color for bio
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    // Skills Card
                    if (profile.skills != null)
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Skills\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold, // Apply style to the label
                                  color: Colors.black,   // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.skills, // The actual education content
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Experience Card
                    if (profile.experience != null)
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Experience\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold, // Apply style to the label
                                  color: Colors.black,   // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.experience, // The actual education content
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Education Card
                    if (profile.education != null)
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Education\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold, // Apply style to the label
                                  color: Colors.black,   // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.education, // The actual education content
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Portfolio Images Card
                    if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty)
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: SizedBox(
                          width: double.infinity, // Match the width of other cards
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Portfolio Images:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: profile.portfolioImages!.map((portfolio) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => FullScreenImageView(imageUrl: portfolio));
                                      },
                                      child: Image.network(
                                        portfolio,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // Certificates Card
                    if (profile.certificates != null && profile.certificates!.isNotEmpty)
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: SizedBox(
                          width: double.infinity, // Match the width of other cards
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Certificates:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: profile.certificates!.map((cert) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => FullScreenImageView(imageUrl: cert));
                                      },
                                      child: Image.network(
                                        cert,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            ],
          ),
        );
      }),
    );
  }
}
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/FreelancerProfileController.dart';
// import 'FullScreenImageView.dart';
//
// class FreelancerProfilePage extends StatelessWidget {
//   final int freelancerId;
//   final int jobId;
//   final FreelancerProfileController controller = Get.put(FreelancerProfileController());
//
//   FreelancerProfilePage({Key? key, required this.freelancerId, required this.jobId}) : super(key: key) {
//     controller.initialize(freelancerId: freelancerId, jobId: jobId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("Navigated to FreelancerProfilePage with freelancerId: $freelancerId");
//
//     controller.fetchFreelancerProfile(freelancerId);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("OneHive", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.profile.value == null) {
//           return Center(child: Text("No profile found."));
//         }
//
//         final profile = controller.profile.value!;
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile Header
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         text: "Profile --> ",
//                         style: TextStyle(fontSize: 14, color: Colors.black),
//                         children: [
//                           TextSpan(
//                             text: profile.name ?? "No Name",
//                             style: TextStyle(color: Colors.deepOrange),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                     // Rating Stars
//                     Row(
//                       children: [
//                         ...List.generate(5, (index) {
//                           double rating = profile.rating ?? 0;
//                           if (index + 1 <= rating) {
//                             return Icon(Icons.star, color: Colors.orange, size: 16);
//                           } else if (index + 0.5 == rating) {
//                             return Icon(Icons.star_half, color: Colors.orange, size: 16);
//                           } else {
//                             return Icon(Icons.star_border, color: Colors.grey, size: 16);
//                           }
//                         }),
//                         SizedBox(width: 4),
//                         Text(
//                           "${profile.rating?.toStringAsFixed(1) ?? "0"}",
//                           style: TextStyle(fontSize: 14, color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Profile Image
//               if (profile.profileImageUrl != null)
//                 GestureDetector(
//                   onTap: () {
//                     Get.to(() => FullScreenImageView(imageUrl: profile.profileImageUrl!));
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(profile.profileImageUrl!),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 16),
//               Text(profile.name ?? "No Name", style: TextStyle(fontSize: 24)),
//               SizedBox(height: 8),
//               Text(profile.bio ?? "No Bio"),
//               SizedBox(height: 16),
//
//               // Hourly Rate
//               if (profile.hourlyRate != null)
//                 Text("Hourly Rate: \$${profile.hourlyRate}/hour", style: TextStyle(fontSize: 16)),
//
//               // Availability
//               if (profile.availability != null)
//                 Text("Availability: ${profile.availability}", style: TextStyle(fontSize: 16)),
//
//               // Languages
//               if (profile.languages != null && profile.languages!.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Languages:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(profile.languages!.join(", ")),
//                   ],
//                 ),
//
//               SizedBox(height: 16),
//
//               // Experience
//               if (profile.experience != null)
//                 Text("Experience: ${profile.experience}", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 8),
//
//               // Education
//               if (profile.education != null)
//                 Text("Education: ${profile.education}", style: TextStyle(fontSize: 16)),
//               SizedBox(height: 8),
//
//               // Portfolio Images
//               if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Portfolio Images:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 8),
//                     Wrap(
//                       spacing: 8,
//                       children: profile.portfolioImages!.map((portfolio) {
//                         return GestureDetector(
//                           onTap: () {
//                             Get.to(() => FullScreenImageView(imageUrl: portfolio));
//                           },
//                           child: Image.network(
//                             portfolio,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//
//               SizedBox(height: 16),
//
//               // Projects Completed
//               if (profile.projectsCompleted != null)
//                 Text("Projects Completed: ${profile.projectsCompleted}", style: TextStyle(fontSize: 16)),
//
//               // Client Feedback
//               if (profile.clientFeedback != null && profile.clientFeedback!.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Client Feedback:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ...profile.clientFeedback!.map((feedback) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Text("- $feedback"),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               SizedBox(height: 16),
//
//               // Contact Information
//               if (profile.contactInfo != null)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Contact Information:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text(profile.contactInfo!),
//                   ],
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
