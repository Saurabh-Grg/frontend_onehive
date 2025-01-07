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
    // Simulated data for leaderboard
    leaderboardUsers.value = [
      User(
        userId: 1,
        username: 'Freelancer 1',
        password: '',
        email: 'freelancer1@example.com',
        role: 'Freelancer',
        city: 'Kathmandu',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 2,
        username: 'Freelancer 2',
        password: '',
        email: 'freelancer2@example.com',
        role: 'Pokhara',
        city: 'Los Angeles',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 3,
        username: 'Freelancer 3',
        password: '',
        email: 'freelancer3@example.com',
        role: 'Freelancer',
        city: 'Pokhara',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 4,
        username: 'Freelancer 4',
        password: '',
        email: 'freelancer4@example.com',
        role: 'Freelancer',
        city: 'Pokhara',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 5,
        username: 'Freelancer 5',
        password: '',
        email: 'freelancer5@example.com',
        role: 'Freelancer',
        city: 'Birgunj',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 6,
        username: 'Freelancer 6',
        password: '',
        email: 'freelancer6@example.com',
        role: 'Freelancer',
        city: 'Lumbini',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 17,
        username: 'Freelancer 7',
        password: '',
        email: 'freelancer7@example.com',
        role: 'Freelancer',
        city: 'Kathmandu',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 8,
        username: 'Freelancer 8',
        password: '',
        email: 'freelancer8@example.com',
        role: 'Freelancer',
        city: 'Chitwan',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 9,
        username: 'Freelancer 9',
        password: '',
        email: 'freelancer9@example.com',
        role: 'Freelancer',
        city: 'Atlanta',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
      User(
        userId: 14,
        username: 'Freelancer 10',
        password: '',
        email: 'freelancer10@example.com',
        role: 'Freelancer',
        city: 'Pokhara',
        resetPasswordToken: null,
        resetPasswordExpires: null,
      ),
    ];

    // Simulate sorting by the selected criterion
    leaderboardUsers.sort((a, b) => getCriterionValue(b)
        .compareTo(getCriterionValue(a))); // Sort in descending order
  }

  // Get the criterion value for sorting
  double getCriterionValue(User user) {
    switch (selectedCriterion.value) {
      case 'Ratings':
        return user.userId * 1.5; // Simulated ratings
      case 'Earnings':
        return user.userId * 250.0; // Simulated earnings
      case 'Projects Completed':
        return user.userId * 6; // Simulated projects
      default:
        return 0.0;
    }
  }

  // Get the label to display for each user
  String getCriterionLabel(User user) {
    switch (selectedCriterion.value) {
      case 'Ratings':
        return 'Rating: ${(user.userId * 1.5).toStringAsFixed(1)}';
      case 'Earnings':
        return 'Earnings: Rs. ${(user.userId * 250.0).toStringAsFixed(2)}';
      case 'Projects Completed':
        return 'Projects: ${(user.userId * 6).toInt()}';
      default:
        return '';
    }
  }
}
