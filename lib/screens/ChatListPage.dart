import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/FollowController.dart';
import '../models/FollowUser.dart';
import 'ChatPage.dart';

class FollowListsScreen extends StatelessWidget {
  final FollowController followController = Get.put(FollowController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Lists', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                followController.filterUsers(query);
              },
              decoration: InputDecoration(
                hintText: 'Search by username...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Obx(() {
            return ToggleButtons(
              isSelected: [
                followController.isShowingFollowing.value,
                !followController.isShowingFollowing.value,
              ],
              onPressed: (index) {
                followController.toggleList(index == 0);
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white, // Text color when selected
              fillColor: Colors.deepOrange, // Background color when selected
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Following'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Followers'),
                ),
              ],
            );
          }),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (followController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final listToShow = followController.isShowingFollowing.value
                  ? followController.following
                  : followController.followers;

              if (listToShow.isEmpty) {
                return const Center(
                  child: Text('You are not following anyone or you are not being followed by anyone.'),
                );
              }

              return ListView.builder(
                itemCount: listToShow.length,
                itemBuilder: (context, index) {
                  final user = listToShow[index];
                  return UserCard(user: user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final FollowUser user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ChatScreen(
          user: user,
          userId: user.userId,
          profileImageUrl: user.profileImageUrl, // Pass profileImageUrl
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profileImageUrl),
            onBackgroundImageError: (_, __) => const Icon(Icons.person),
          ),
          title: Text(user.username, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
