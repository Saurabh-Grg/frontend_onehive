import 'package:flutter/material.dart';
import '../models/proposal_model.dart';

class EscrowPaymentPage extends StatelessWidget {
  final Proposal proposal;

  EscrowPaymentPage({required this.proposal});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escrow Payment Details',
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Freelancer and Job Information
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Freelancer: ${proposal.name}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text('Project: ${proposal.title}', style: TextStyle(fontSize: screenWidth * 0.04)),
                    SizedBox(height: screenHeight * 0.01),
                    Text('Proposed Budget: \$${proposal.budget}', style: TextStyle(fontSize: screenWidth * 0.04)),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Escrow Payment Details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escrow Payment Breakdown',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Freelancer Payment:', style: TextStyle(fontSize: screenWidth * 0.045)),
                        Text('\$${proposal.budget}', style: TextStyle(fontSize: screenWidth * 0.045)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('System Commission (5%):', style: TextStyle(fontSize: screenWidth * 0.045)),
                        Text('\$${(proposal.budget * 0.05).toStringAsFixed(2)}', style: TextStyle(fontSize: screenWidth * 0.045)),
                      ],
                    ),
                    Divider(height: screenHeight * 0.03, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount:', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                        Text('\$${(proposal.budget * 1.05).toStringAsFixed(2)}', style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Agreement Checkbox
            Row(
              children: [
                Checkbox(
                  value: true, // Bind this to track state if needed
                  onChanged: (value) {
                    // Handle checkbox change
                  },
                ),
                Expanded(
                  child: Text(
                    'I understand that my payment will be held in escrow until the project is completed and approved.',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // Payment Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.3,
                  ),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Proceed to eSewa payment or backend call to create escrow
                },
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
