import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/ReviewController.dart';

class SubmitReviewScreen extends StatelessWidget {
  final ReviewController controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Review',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.1,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150',
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Freelancer Name',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Project: Mobile App Development',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Rating Section
              Text('Rate the Freelancer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              RatingSection(controller: controller, title: 'Communication', ratingType: 'communication'),
              RatingSection(controller: controller, title: 'Skill Level', ratingType: 'skill'),
              RatingSection(controller: controller, title: 'Timeliness', ratingType: 'timeliness'),
              RatingSection(controller: controller, title: 'Professionalism', ratingType: 'professionalism'),
              RatingSection(controller: controller, title: 'Creativity', ratingType: 'creativity'),
              SizedBox(height: 16),

              // Display Numeric Rating Details
              Text('Rating Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Obx(() {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        RatingDetailRow('Communication', controller.communicationRating.value),
                        RatingDetailRow('Skill Level', controller.skillRating.value),
                        RatingDetailRow('Timeliness', controller.timelinessRating.value),
                        RatingDetailRow('Professionalism', controller.professionalismRating.value),
                        RatingDetailRow('Creativity', controller.creativityRating.value),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        RatingDetailRow('Overall', controller.overallRating.value, isOverall: true),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(height: 24),

              // Review Input
              Text('Write a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe your experience...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
                onChanged: (value) => controller.updateReviewText(value),
              ),
              SizedBox(height: 24),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller.submitReview();
                    Get.snackbar(
                      'Review Submitted',
                      'Your feedback has been recorded successfully.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.3, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widget for Displaying Rating Details
class RatingDetailRow extends StatelessWidget {
  final String title;
  final double rating;
  final bool isOverall;

  RatingDetailRow(this.title, this.rating, {this.isOverall = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: isOverall ? 18 : 16, fontWeight: isOverall ? FontWeight.bold : FontWeight.normal),
          ),
          Row(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: isOverall ? 18 : 16,
                  color: isOverall ? Colors.deepOrange : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.star,
                color: Colors.deepOrange,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Rating Section Widget
class RatingSection extends StatelessWidget {
  final ReviewController controller;
  final String title;
  final String ratingType;

  RatingSection({
    required this.controller,
    required this.title,
    required this.ratingType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(() {
          double initialRating = 0.0;
          switch (ratingType) {
            case 'communication':
              initialRating = controller.communicationRating.value;
              break;
            case 'skill':
              initialRating = controller.skillRating.value;
              break;
            case 'timeliness':
              initialRating = controller.timelinessRating.value;
              break;
            case 'professionalism':
              initialRating = controller.professionalismRating.value;
              break;
            case 'creativity':
              initialRating = controller.creativityRating.value;
              break;
          }
          return RatingBar.builder(
            initialRating: initialRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: MediaQuery.of(context).size.width * 0.1,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.deepOrange,
            ),
            onRatingUpdate: (rating) {
              switch (ratingType) {
                case 'communication':
                  controller.updateCommunicationRating(rating);
                  break;
                case 'skill':
                  controller.updateSkillRating(rating);
                  break;
                case 'timeliness':
                  controller.updateTimelinessRating(rating);
                  break;
                case 'professionalism':
                  controller.updateProfessionalismRating(rating);
                  break;
                case 'creativity':
                  controller.updateCreativityRating(rating);
                  break;
              }
            },
          );
        }),
      ],
    );
  }
}
