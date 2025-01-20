// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserController extends GetxController {
//   var isLoading = false.obs; // Observing the loading state
//   var token = ''.obs; // Observing the token
//   var userId = ''.obs; // Observing the user ID
//   var role = ''.obs; // Observing the role
//   var username = ''.obs; // Observing the username
//   var email = ''.obs; // Observing the email
//   var city = ''.obs; // Observing the city
//   var isLoggedIn = false.obs; // Observing the login status
//
//   Future<void> login(String emailInput, String password) async {
//     isLoading(true);
//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/api/auth/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': emailInput, 'password': password}),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         // Extract token and user data
//         token.value = responseData['token']; // Store token in reactive variable
//         userId.value = responseData['user']['user_id'].toString(); // Convert user ID to string
//         role.value = responseData['user']['role'] ?? ''; // Fetch role
//         username.value = responseData['user']['username'] ?? ''; // Fetch username
//         email.value = responseData['user']['email'] ?? ''; // Fetch email
//         city.value = responseData['user']['city'] ?? ''; // Fetch city
//         isLoggedIn(true);
//
//         // Save token and other data to SharedPreferences for persistence
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', token.value);
//         await prefs.setString('user_id', userId.value);
//         await prefs.setString('role', role.value);
//         await prefs.setString('username', username.value);
//         await prefs.setString('email', email.value);
//         await prefs.setString('city', city.value);
//
//         Get.snackbar("Success", "Logged in successfully");
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred: $e");
//       print("$e");
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> loadUserFromPrefs() async {
//     // Load user data from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token.value = prefs.getString('token') ?? '';
//     userId.value = prefs.getString('user_id') ?? '';
//     role.value = prefs.getString('role') ?? '';
//     username.value = prefs.getString('username') ?? '';
//     email.value = prefs.getString('email') ?? '';
//     city.value = prefs.getString('city') ?? '';
//     isLoggedIn(token.isNotEmpty); // Set login status based on token presence
//   }
//
//   Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // Clear saved data
//     token.value = '';
//     userId.value = '';
//     role.value = '';
//     username.value = '';
//     email.value = '';
//     city.value = '';
//     isLoggedIn(false);
//     Get.snackbar("Success", "Logged out successfully");
//   }
//
//   Future<void> navigateBasedOnRole() async {
//     bool isFreelancer = role.value.trim().toLowerCase() == 'freelancer';
//     if (isFreelancer) {
//       Get.offAllNamed('/freelancer-dashboard'); // Navigate to freelancer dashboard
//     } else {
//       Get.offAllNamed('/dashboard'); // Navigate to client dashboard
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUserFromPrefs(); // Load user data when the controller is initialized
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:onehive_frontend/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  // Observed variables
  var isLoading = false.obs;
  var token = ''.obs;
  var userId = ''.obs;
  var role = ''.obs;
  var username = ''.obs;
  var email = ''.obs;
  var city = ''.obs;
  var profileImage = ''.obs; // Added variable for profile image
  var isLoggedIn = false.obs;

  Future<void> login(String emailInput, String password) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailInput, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract token and user data
        token.value = responseData['token'];
        userId.value = responseData['user']['user_id'].toString();
        role.value = responseData['user']['role'] ?? '';
        username.value = responseData['user']['username'] ?? '';
        email.value = responseData['user']['email'] ?? '';
        city.value = responseData['user']['city'] ?? '';
        profileImage.value = responseData['user']['profile_image'] ?? ''; // Fetch profile image URL
        isLoggedIn(true);

        // Save token and other data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token.value);
        await prefs.setString('user_id', userId.value);
        await prefs.setString('role', role.value);
        await prefs.setString('username', username.value);
        await prefs.setString('email', email.value);
        await prefs.setString('city', city.value);
        await prefs.setString('profile_image', profileImage.value); // Save profile image URL

        Get.snackbar("Success", "Logged in successfully");

        // Navigate to appropriate dashboard
        navigateBasedOnRole();
      } else {
        isLoggedIn(false);
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      isLoggedIn(false);
      Get.snackbar("Error", "Connection failed: $e");
      print("$e");
    } finally {
      isLoading(false);
    }
  }

  void navigateBasedOnRole() {
    if (isLoggedIn.value) {
      bool isFreelancer = role.value.trim().toLowerCase() == 'freelancer';
      Get.off(() => HomePage(
        username: username.value,
        email: email.value,
        isFreelancer: isFreelancer,
      ));
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs(); // Load user data when the controller is initialized
  }

  Future<void> loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
    userId.value = prefs.getString('user_id') ?? '';
    role.value = prefs.getString('role') ?? '';
    username.value = prefs.getString('username') ?? '';
    email.value = prefs.getString('email') ?? '';
    city.value = prefs.getString('city') ?? '';
    profileImage.value = prefs.getString('profile_image') ?? ''; // Load profile image from SharedPreferences
    isLoggedIn(token.isNotEmpty);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token.value = '';
    userId.value = '';
    role.value = '';
    username.value = '';
    email.value = '';
    city.value = '';
    profileImage.value = ''; // Clear profile image on logout
    isLoggedIn(false);
    Get.snackbar("Success", "Logged out successfully");
  }
}
