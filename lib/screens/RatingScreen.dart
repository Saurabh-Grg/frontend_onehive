import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/RatingController.dart';

class RatingsScreen extends StatelessWidget {
  final RatingsController controller = Get.put(RatingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Ratings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular progress bar for overall ratings
            Center(
              child: Obx(() {
                return Column(
                  children: [
                    CircularProgressIndicator(
                      value: controller.overallRating.value / 5.0,
                      strokeWidth: 8.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${controller.overallRating.value.toStringAsFixed(1)} / 5',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 16),
            // Filter dropdown
            DropdownButton<String>(
              value: controller.selectedFilter.value,
              items: controller.filters
                  .map((filter) => DropdownMenuItem<String>(
                value: filter,
                child: Text(filter),
              ))
                  .toList(),
              onChanged: controller.updateFilter,
            ),
            SizedBox(height: 16),
            // Reviews list
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = controller.filteredReviews[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(review.avatarUrl),
                        ),
                        title: Text(review.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                  5,
                                      (i) => Icon(
                                    Icons.star,
                                    size: 16,
                                    color: i < review.rating
                                        ? Colors.amber
                                        : Colors.grey,
                                  )),
                            ),
                            SizedBox(height: 4),
                            Text(review.comment),
                          ],
                        ),
                        trailing: Text(review.date),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}