import 'package:get/get.dart';

class ReviewController extends GetxController {
  var communicationRating = 0.0.obs;
  var skillRating = 0.0.obs;
  var timelinessRating = 0.0.obs;
  var professionalismRating = 0.0.obs;
  var creativityRating = 0.0.obs;
  var overallRating = 0.0.obs;
  var reviewText = ''.obs;

  void updateCommunicationRating(double rating) {
    communicationRating.value = rating;
    updateOverallRating();
  }

  void updateSkillRating(double rating) {
    skillRating.value = rating;
    updateOverallRating();
  }

  void updateTimelinessRating(double rating) {
    timelinessRating.value = rating;
    updateOverallRating();
  }

  void updateProfessionalismRating(double rating) {
    professionalismRating.value = rating;
    updateOverallRating();
  }

  void updateCreativityRating(double rating) {
    creativityRating.value = rating;
    updateOverallRating();
  }

  void updateOverallRating() {
    overallRating.value = (communicationRating.value +
        skillRating.value +
        timelinessRating.value +
        professionalismRating.value +
        creativityRating.value) / 5;
  }

  void updateReviewText(String text) {
    reviewText.value = text;
  }

  void submitReview() {
    // Submit review logic (e.g., send to backend)
  }
}
