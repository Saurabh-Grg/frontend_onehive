import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/models/AcceptedJobModel.dart';

class PaymentScreen extends StatelessWidget {
  final AcceptedJob acceptedJob;

  // Reactive variable to store the selected payment method
  final RxString selectedPaymentMethod = 'esewa'.obs;

  PaymentScreen({required this.acceptedJob});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Accepted job at: ${acceptedJob.createdAt}"),
              Text("Accepted job status: ${acceptedJob.status}"),
              Text("Accepted job budget: ${acceptedJob.budget.toString()}"),
              Text(
                  "Accepted job escrow charge: ${acceptedJob.escrowCharge.toString()}"),
              Text("Escrow enabled: ${acceptedJob.useEscrow.toString()}"),
              Text("Accepted job Id: ${acceptedJob.id.toString()}"),
              Image.network(acceptedJob.freelancer.profileImageUrl),
              Text("Freelancer name: ${acceptedJob.freelancer.name}"),
              Text("Client name: ${acceptedJob.client.username}"),
              Text("Freelancer id: ${acceptedJob.freelancer.id.toString()}"),
              Text("Job ID: ${acceptedJob.job.jobId.toString()}"),
              Text("Job title: ${acceptedJob.job.title}"),
              Text("Job category: ${acceptedJob.job.category}"),
              Text("Job description: ${acceptedJob.job.description}"),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/images/img.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(
                          'eSewa',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                    value: 'esewa',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                    },
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/images/img1.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Khalti',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    value: 'img2',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                      // Show snackbar for coming soon
                      if (value != 'esewa') {
                        Get.snackbar(
                            'Coming Soon', 'This payment method is coming soon!');
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/images/img2.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Bank Transfer',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    value: 'bank_transfer',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                      // Show snackbar for coming soon
                      if (value != 'esewa') {
                        Get.snackbar(
                            'Coming Soon', 'This payment method is coming soon!');
                      }
                    },
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.greenAccent],
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Get the necessary details (like amount, transaction UUID, and signature)
                        // double amount = purchasedItemData['totalPrice']?.toDouble() ?? 0.0;  // Null check and default value
                        // String transactionUuid = purchasedItemData['purchasedItemId'] ?? '';  // Null check
                        // String signature = paymentData['signature'] ?? '';  // Null check
                        //
                        // // Make sure no field is null before proceeding
                        // if (amount == 0.0 || transactionUuid.isEmpty || signature.isEmpty) {
                        //   // Handle the error case where the values are missing
                        //   print('Error: Missing data for payment');
                        //   return;
                        // }
                        //
                        // // Call the function to initiate payment
                        // paymentController.initiateEsewaPayment(amount, transactionUuid, signature);
                      },
                      child: Text(
                        'Pay with ${selectedPaymentMethod.value.toUpperCase()}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
