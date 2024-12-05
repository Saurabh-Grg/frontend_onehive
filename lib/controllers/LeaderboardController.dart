import 'package:get/get.dart';
import '../models/user.dart';

class LeaderboardController extends GetxController {
  // Leaderboard criteria
  var criteria = ['Ratings', 'Earnings', 'Projects Completed'].obs;
  var selectedCriterion = 'Ratings'.obs;

  // Simulated leaderboard data
  var leaderboardUsers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboardData();
  }

  void updateCriterion(String? criterion) {
    if (criterion != null) {
      selectedCriterion.value = criterion;
      fetchLeaderboardData();
    }
  }

  // Fetch leaderboard data based on the selected criterion
  void fetchLeaderboardData() {
    // Simulated data fetch (replace with API call to backend)
    leaderboardUsers.value = [
      User(
        userId: 1,
        username: 'JohnDoe',
        password: '',
        email: 'john@example.com',
        role: 'Freelancer',
        city: 'New York',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 2,
        username: 'JaneSmith',
        password: '',
        email: 'jane@example.com',
        role: 'Freelancer',
        city: 'Los Angeles',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      // Add more users as needed
    ];

    // Simulate sorting by the selected criterion
    leaderboardUsers.sort((a, b) => getCriterionValue(b)
        .compareTo(getCriterionValue(a))); // Sort in descending order
  }

  // Get the criterion value for sorting
  double getCriterionValue(User user) {
    switch (selectedCriterion.value) {
      case 'Ratings':
        return user.userId * 1.2; // Simulated ratings
      case 'Earnings':
        return user.userId * 200.0; // Simulated earnings
      case 'Projects Completed':
        return user.userId * 5; // Simulated projects
      default:
        return 0.0;
    }
  }

  // Get the label to display for each user
  String getCriterionLabel(User user) {
    switch (selectedCriterion.value) {
      case 'Ratings':
        return 'Rating: ${(user.userId * 1.2).toStringAsFixed(1)}';
      case 'Earnings':
        return 'Earnings: \$${(user.userId * 200.0).toStringAsFixed(2)}';
      case 'Projects Completed':
        return 'Projects: ${(user.userId * 5).toInt()}';
      default:
        return '';
    }
  }
}
