import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/RatingController.dart';
import 'package:timeago/timeago.dart' as timeago;

class RatingsScreen extends StatelessWidget {
  final RatingsController controller = Get.put(RatingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Ratings',
          style:
              TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular progress bar with additional details
            Center(
              child: Obx(() {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Use 1/3 of the smallest screen dimension for a dynamic size
                            double size =
                                (constraints.maxWidth < constraints.maxHeight
                                        ? constraints.maxWidth
                                        : constraints.maxHeight) /
                                    3;

                            return SizedBox(
                              width: size,
                              height: size,
                              child: CircularProgressIndicator(
                                value: controller.overallRating.value / 5.0,
                                strokeWidth: 12.0,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepOrangeAccent),
                              ),
                            );
                          },
                        ),
                        Text(
                          '${controller.overallRating.value.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 40,
                            // Adjust as needed for the dynamic size
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Based on ${controller.reviews.length} reviews',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 15),
            // Detailed Statistics
            Text(
              'Rating Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true, // Prevent infinite height issues
              physics: NeverScrollableScrollPhysics(), // Disable scroll within the ListView
              itemCount: 5,
              itemBuilder: (context, i) {
                int stars = 5 - i;
                int count = controller.reviews.where((review) => review.rating == stars).length;
                double percentage = controller.reviews.isEmpty ? 0 : count / controller.reviews.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Star Icon and Count
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text('$stars', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(width: 16),

                      // Progress Bar with percentage
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  color: Colors.amber,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${(percentage * 100).toStringAsFixed(1)}%',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Review Count
                      Text(
                        '$count reviews',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
            Text(
              'Filter Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            SizedBox(height: 8),
            Obx(() {
              return Wrap(
                spacing: 8.0, // Horizontal spacing between chips
                runSpacing: 8.0, // Vertical spacing between lines of chips
                alignment: WrapAlignment.start,
                children: controller.filters.map((filter) {
                  bool isSelected = filter == controller.selectedFilter.value;
                  return ChoiceChip(
                    avatar: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : Icon(Icons.filter_alt_outlined, color: Colors.deepOrangeAccent, size: 16),
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.deepOrangeAccent,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) controller.updateFilter(filter);
                    },
                    selectedColor: Colors.deepOrange,
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    shadowColor: Colors.deepOrangeAccent.withOpacity(0.3),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 16),
            // Reviews list
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = controller.filteredReviews[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(review.avatarUrl),
                        ),
                        title: Text(
                          review.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                  5,
                                  (i) => Icon(
                                        Icons.star,
                                        size: 18,
                                        color: i < review.rating
                                            ? Colors.amber
                                            : Colors.grey,
                                      )),
                            ),
                            SizedBox(height: 8),
                            Text(
                              review.comment,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                if (index % 2 ==
                                    0) // Dummy badge for illustration
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Verified Purchase',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12),
                                    ),
                                  ),
                                Spacer(),
                                Text(
                                  timeago.format(DateTime.parse(review.date)),
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.thumb_up, color: Colors.grey),
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
