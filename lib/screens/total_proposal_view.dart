// views/total_proposals_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/total_proposal_controller.dart';

class TotalProposalsView extends StatelessWidget {
  final TotalProposalsController controller = Get.put(TotalProposalsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Proposals Received'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Text(
            "Total Proposals: ${controller.totalProposals.value}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.fetchTotalProposals();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
