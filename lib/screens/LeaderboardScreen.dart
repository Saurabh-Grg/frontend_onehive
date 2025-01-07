import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/LeaderboardController.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardController controller = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Add help or information modal here
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Category Switcher
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: controller.criteria.map((criterion) {
                  bool isSelected = controller.selectedCriterion.value == criterion;
                  return GestureDetector(
                    onTap: () => controller.updateCriterion(criterion),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrange : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        criterion,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.leaderboardUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.leaderboardUsers[index];

                  // Assign colors based on rank
                  Color cardColor;
                  switch (index) {
                    case 0:
                      cardColor = Colors.amber[300]!;
                      break;
                    case 1:
                      cardColor = Colors.grey[400]!;
                      break;
                    case 2:
                      cardColor = Colors.brown[300]!;
                      break;
                    default:
                      cardColor = Colors.white;
                      break;
                  }

                  // Badge logic for top 3 freelancers
                  String badgeText = '';
                  IconData badgeIcon;
                  Color badgeColor;
                  switch (index) {
                    case 0:
                      badgeText = controller.selectedCriterion.value == 'Earnings'
                          ? 'Top Earner'
                          : controller.selectedCriterion.value == 'Ratings'
                          ? 'Master Performer'
                          : 'Project Star';
                      badgeIcon = Icons.emoji_events;
                      badgeColor = Colors.amber;
                      break;
                    case 1:
                      badgeText = controller.selectedCriterion.value == 'Earnings'
                          ? 'High Achiever'
                          : controller.selectedCriterion.value == 'Ratings'
                          ? 'Rising Star'
                          : 'Steady Performer';
                      badgeIcon = Icons.trending_up;
                      badgeColor = Colors.grey;
                      break;
                    case 2:
                      badgeText = controller.selectedCriterion.value == 'Earnings'
                          ? 'Reliable Contributor'
                          : controller.selectedCriterion.value == 'Ratings'
                          ? 'Promising Talent'
                          : 'Hard Worker';
                      badgeIcon = Icons.handshake;
                      badgeColor = Colors.brown;
                      break;
                    default:
                      badgeText = '';
                      badgeIcon = Icons.star;
                      badgeColor = Colors.white;
                      break;
                  }

                  return Card(
                    color: cardColor, // Use rank-based color here
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.deepOrange,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user.username,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (index < 3)
                                          SizedBox(width: 8),
                                        if (index < 3)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: badgeColor,
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  badgeIcon,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  badgeText,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      controller.getCriterionLabel(user),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'City: ${user.city}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.shade400, thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.money, color: Colors.green, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'Earnings: Rs ${(user.userId * 2500).toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: Colors.blue, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    'Projects: ${(user.userId * 7)}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
