import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/FreelancerProfileController.dart';

class FreelancerProfilePage extends StatelessWidget {
  final int freelancerId; // Use int for consistency if IDs are stored as integers
  final int jobId;
  final FreelancerProfileController controller = Get.put(FreelancerProfileController());

  FreelancerProfilePage({Key? key, required this.freelancerId, required this.jobId}) : super(key: key) {
    // Initialize the controller with the provided IDs
    controller.initialize(freelancerId: freelancerId, jobId: jobId);
  }

  @override
  Widget build(BuildContext context) {
    print("Navigated to FreelancerProfilePage with freelancerId: $freelancerId");

    // Fetch the freelancer profile on page load
    controller.fetchFreelancerProfile(freelancerId);


    return Scaffold(
      appBar: AppBar(
        title: Text("Freelancer Profile"),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (profile.profileImageUrl != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.profileImageUrl!),
                  ),
                SizedBox(height: 16),
                Text(profile.name ?? "No Name", style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text(profile.bio ?? "No Bio"),
                SizedBox(height: 16),
                if (profile.skills != null)
                  Text("Skills: ${profile.skills}"),
                SizedBox(height: 8),
                if (profile.experience != null)
                  Text("Experience: ${profile.experience}"),
                SizedBox(height: 8),
                if (profile.education != null)
                  Text("Education: ${profile.education}"),
                SizedBox(height: 16),
                if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Portfolio Images:"),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: profile.portfolioImages!
                            .map((image) => Image.network(image, width: 100, height: 100))
                            .toList(),
                      ),
                    ],
                  ),
                if (profile.certificates != null && profile.certificates!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Certificates:"),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: profile.certificates!
                            .map((cert) => Image.network(cert, width: 100, height: 100))
                            .toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

