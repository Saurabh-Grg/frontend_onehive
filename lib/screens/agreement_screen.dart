import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/total_proposal_controller.dart';

class AgreementScreen extends StatelessWidget {
  final int proposalId;
  final String clientName;
  final String clientEmail;
  final String freelancerName;
  final String freelancerEmail;
  final String jobTitle;
  final double budget;
  final bool useEscrow;

  AgreementScreen({
    required this.proposalId, // Accept the proposal ID
    required this.clientName,
    required this.clientEmail,
    required this.freelancerName,
    required this.freelancerEmail,
    required this.jobTitle,
    required this.budget,
    this.useEscrow = false,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('OneHive Agreement',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildSection('Parties Involved', Icons.people, [
              'Client: $clientName',
              'Email: $clientEmail',
              'Freelancer: $freelancerName',
              'Email: $freelancerEmail',
            ]),
            SizedBox(height: 20),
            _buildSection('Project Overview', Icons.work, [
              'Job Title: $jobTitle',
              'Budget: Rs. ${budget.toStringAsFixed(2)}',
              'Deadline: ',
              'Payment Method: ${useEscrow ? 'Escrow (5% fee applies)' : 'Direct Transfer'}',
            ]),
            SizedBox(height: 20),
            _buildSection('Terms & Conditions', Icons.description, [
              'Freelancer agrees to complete the project within the deadline.',
              'Ownership transfers to the client upon full payment.',
              'Confidentiality must be maintained.',
              'Client commission: 5% of the total budget.',
            ]),
            SizedBox(height: 20),
            _buildSection('Signatures', Icons.edit, [
              'Agreement Date: $formattedDate',
            ]),
            SizedBox(height: Get.height * 0.02),
            _buildConfirmationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/OneHive.png', height: 80)),
            SizedBox(height: 10),
            Flexible(
              child: Text(
                'OneHive Freelance Project Agreement',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              ),
            ),
          ],
        ),
        Divider(thickness: 2, color: Colors.deepOrange),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<String> content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepOrange),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            ...content
                .map((text) => Text('• $text', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.6, // 80% of screen width for responsiveness
        child: ElevatedButton(
          onPressed: () => _confirmAgreement(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            overlayColor: MaterialStateProperty.all(Colors.orange.withOpacity(0.2)), // Click effect
            elevation: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) return 2; // Lower elevation on press
              return 6; // Default elevation
            }),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              vertical: screenWidth * 0.03, // Scales padding based on screen width
            )),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded button
              ),
            ),
          ),
          child: Text(
            'Agree & Continue',
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Dynamic font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _confirmAgreement(BuildContext context) {
    // Step 1: Ask for confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Agreement'),
          content: Text('Are you sure you want to agree to the terms and conditions?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                // Call acceptProposal method and await result
                bool isAccepted = await Get.find<TotalProposalsController>().acceptProposal(proposalId.toString());

                // If proposal acceptance is successful, ask to download the agreement
                if (isAccepted) {
                  _askToDownloadAgreement(context); // Proceed to download prompt
                }
              },
              child: Text('Confirm', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  void _askToDownloadAgreement(BuildContext context) {
    // Step 2: Ask to download the agreement
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agreement Confirmed'),
          content: Text('The agreement has been signed. Would you like to download a copy?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No, Thanks', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                print('Download agreement'); // Placeholder for PDF download functionality
                Navigator.of(context).pop();
              },
              child: Text('Download', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }
}