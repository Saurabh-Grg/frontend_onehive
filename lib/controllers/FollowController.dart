import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/FollowUser.dart';
import 'UserController.dart';

class FollowController extends GetxController {
  final UserController userController = Get.find();

  var following = <FollowUser>[].obs;
  var followers = <FollowUser>[].obs;
  var isLoading = true.obs;
  var isShowingFollowing = true.obs; // Track toggle state
  var filteredUsers = <FollowUser>[].obs;


  @override
  void onInit() {
    fetchFollowLists();
    super.onInit();
  }

  void toggleList(bool showFollowing) {
    isShowingFollowing.value = showFollowing;
  }

  void filterUsers(String query) {
    final lowerQuery = query.toLowerCase();
    filteredUsers.value = (isShowingFollowing.value ? following : followers)
        .where((user) => user.username.toLowerCase().contains(lowerQuery))
        .toList();
  }


  Future<void> fetchFollowLists() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/follow/follow-lists'),
        headers: {'Authorization': 'Bearer ${userController.token.value}'}, // Add token if needed
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        following.value = (data['following'] as List)
            .map((item) => FollowUser.fromJson(item))
            .toList();
        followers.value = (data['followers'] as List)
            .map((item) => FollowUser.fromJson(item))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load follow lists');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
