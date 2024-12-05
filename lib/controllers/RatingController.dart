import 'package:get/get.dart';

import '../models/Review.dart';

class RatingsController extends GetxController {
  var overallRating = 4.5.obs;
  var filters = ['All', '5 stars', '4 stars', '3 stars', '2 stars', '1 star'];
  var selectedFilter = 'All'.obs;
  var reviews = [
    // Dummy reviews
    Review('John Doe', 5, 'Great work!', '2024-12-01', 'https://...'),
    Review('Jane Smith', 4, 'Good job!', '2024-11-30', 'https://...'),
  ].obs;

  List<Review> get filteredReviews {
    if (selectedFilter.value == 'All') {
      return reviews;
    } else {
      int stars = int.parse(selectedFilter.value.split(' ')[0]);
      return reviews.where((review) => review.rating == stars).toList();
    }
  }

  void updateFilter(String? value) {
    if (value != null) {
      selectedFilter.value = value;
    }
  }
}