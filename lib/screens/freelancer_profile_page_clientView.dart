import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/FreelancerProfileController.dart';
import 'FullScreenImageView.dart';

class FreelancerProfilePage extends StatefulWidget {
  final int freelancerId;
  final int jobId;

  FreelancerProfilePage({Key? key, required this.freelancerId, required this.jobId})
      : super(key: key);

  @override
  _FreelancerProfilePageState createState() => _FreelancerProfilePageState();
}

class _FreelancerProfilePageState extends State<FreelancerProfilePage> {
  final FreelancerProfileController controller = Get.put(FreelancerProfileController());

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the provided IDs
    controller.initialize(freelancerId: widget.freelancerId, jobId: widget.jobId);
    // Fetch the follow status from SharedPreferences when the page is loaded
    _loadFollowStatus();
  }

  Future<void> _loadFollowStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('isFollowing_${widget.freelancerId}');

    if (status != null) {
      controller.isFollowing.value = status;
    } else {
      controller.fetchFollowStatus(); // Fallback to fetching from API if not found
    }
  }

  // Show a confirmation dialog
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(
            controller.isFollowing.value
                ? "Are you sure you want to unfollow?"
                : "Are you sure you want to follow?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Navigated to FreelancerProfilePage with freelancerId: ${widget.freelancerId}");

    // Fetch the freelancer profile on page load
    controller.fetchFreelancerProfile(widget.freelancerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OneHive",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Show confirmation dialog
                  bool confirm = await _showConfirmationDialog(context);

                  if (confirm) {
                    int userIdInt = int.parse(controller.userController.userId.value); // Convert String to int

                    if (controller.isFollowing.value) {
                      controller.unfollowFreelancer(
                        userIdInt,
                        widget.freelancerId, // Use freelancerId to unfollow
                      );
                    } else {
                      controller.followFreelancer(
                        userIdInt,
                        widget.freelancerId, // Use freelancerId to follow
                      );
                    }
                  }
                },
                child: Text(
                  controller.isFollowing.value ? "Unfollow" : "Follow",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isFollowing.value ? Colors.grey[200] : Colors.deepOrange,
                  foregroundColor: controller.isFollowing.value ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }),
        ],
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
                  child: Stack(
                    alignment: Alignment.center,
                    // Align children at the center of the Stack
                    children: [
                      Container(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Full screen width
                        height: MediaQuery.of(context).size.height *
                            0.2, // 20% of the screen height
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profile.profileImageUrl!),
                            fit: BoxFit
                                .cover, // Adjust the image to cover the container
                          ),
                        ),
                      ),
                      // Play icon button at the center
                      IconButton(
                        onPressed: () {
                          // You can define what happens when the play button is clicked
                        },
                        icon: Icon(
                          Icons.play_circle_filled,
                          size: 50.0, // Size of the play icon
                          color: Colors.white, // Color of the play icon
                        ),
                      ),
                    ],
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
                        GestureDetector(
                          onTap: () {
                            // Navigate to the fullscreen image view
                            Get.to(() => FullScreenImageView(
                                imageUrl: profile.profileImageUrl!));
                          },
                          child: CircleAvatar(
                            radius: Get.width * 0.1,
                            // Set the radius of the circle
                            backgroundImage: profile.profileImageUrl != null
                                ? NetworkImage(profile.profileImageUrl!)
                                : AssetImage('assets/default_avatar.png')
                                    as ImageProvider, // Use default if no image
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
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
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                Text(
                                  '${profile.city}, Nepal',
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                            Text(
                              'Member since: ${profile.createdAt}',
                              style: TextStyle(color: Colors.grey[600]),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
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
                color: Colors.grey[300],
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    // Skills Card
                    if (profile.skills != null)
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Skills\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // Apply style to the label
                                  color:
                                      Colors.black, // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.skills,
                                    // The actual education content
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
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Experience\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // Apply style to the label
                                  color:
                                      Colors.black, // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.experience,
                                    // The actual education content
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
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: "Education\n", // The label part
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // Apply style to the label
                                  color:
                                      Colors.black, // Apply color to the label
                                ),
                                children: [
                                  TextSpan(
                                    text: profile.education,
                                    // The actual education content
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
                    if (profile.portfolioImages != null &&
                        profile.portfolioImages!.isNotEmpty)
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          // Match the width of other cards
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
                                  children:
                                      profile.portfolioImages!.map((portfolio) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(() => FullScreenImageView(
                                            imageUrl: portfolio));
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
                    if (profile.certificates != null &&
                        profile.certificates!.isNotEmpty)
                      Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          // Match the width of other cards
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
                                        Get.to(() => FullScreenImageView(
                                            imageUrl: cert));
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

