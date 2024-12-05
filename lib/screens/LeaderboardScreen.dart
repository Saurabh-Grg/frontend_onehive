import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/LeaderboardController.dart';
import '../models/user.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardController controller = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Column(
        children: [
          // Dropdown to switch leaderboard criterion
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              return DropdownButton<String>(
                value: controller.selectedCriterion.value,
                items: controller.criteria
                    .map((criterion) => DropdownMenuItem<String>(
                  value: criterion,
                  child: Text(criterion),
                ))
                    .toList(),
                onChanged: controller.updateCriterion,
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.leaderboardUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.leaderboardUsers[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user.username),
                      subtitle: Text('${controller.getCriterionLabel(user)}'),
                      trailing: Icon(Icons.star, color: Colors.amber),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
