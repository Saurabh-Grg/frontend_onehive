import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/providers/client_profile_provider.dart';
import 'package:onehive_frontend/providers/jobProvider.dart';
import 'package:onehive_frontend/providers/user_provider.dart';
import 'package:onehive_frontend/screens/ChatListPage.dart';
import 'package:onehive_frontend/screens/EarningsPage.dart';
import 'package:onehive_frontend/screens/LeaderboardScreen.dart';
import 'package:onehive_frontend/screens/RatingScreen.dart';
import 'package:onehive_frontend/screens/SubmitReviewScreen.dart';
import 'package:onehive_frontend/screens/accountSetting.dart';
import 'package:onehive_frontend/screens/client_dashboard.dart';
import 'package:onehive_frontend/screens/freelancer_dashboard.dart';
import 'package:onehive_frontend/screens/login_form.dart';
import 'package:onehive_frontend/screens/total_proposal_view.dart';
import 'package:onehive_frontend/screens/welcome_screen.dart';
import 'package:onehive_frontend/services/job_posting_service.dart';
import 'package:provider/provider.dart';

class OneHive extends StatelessWidget {
  OneHive({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneHive',

      theme: ThemeData(
          primarySwatch: Colors.orange
      ),
      getPages: [
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/login', page: () => LoginForm()),
        GetPage(name: '/freelancer-dashboard', page: () => FreelancerDashboard()),
        GetPage(name: '/dashboard', page: () => ClientDashboard()),
        GetPage(name: '/rating', page: () => RatingsScreen()),
        GetPage(name: '/leaderboard', page: () => LeaderboardScreen()),
        GetPage(name: '/SubmitReviewScreen', page: () => SubmitReviewScreen()),
        GetPage(name: '/totalProposal', page: () => TotalProposalsView()),
        GetPage(name: '/chatListPage', page: () => FollowListsScreen()),
        GetPage(name: '/earnings', page: () => EarningsPage()),
        GetPage(name: '/accountSetting', page: () => Accountsetting())
      ],
    );
  }
}

void main() {
  runApp(
    MultiProvider( // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Initialize UserProvider
        ChangeNotifierProvider(create: (context) => JobProvider()),
        ChangeNotifierProvider(create: (context) => JobPostingService()), // Use ChangeNotifierProvider for JobPostingService
        ChangeNotifierProvider(create: (context) => ClientProfileProvider()),
      ],
      child: OneHive(),
    ),
  );
}