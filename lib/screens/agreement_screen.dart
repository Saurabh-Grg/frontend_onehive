import 'package:flutter/material.dart';

class AgreementScreen extends StatelessWidget {
  final String clientName;
  final String clientEmail;
  final String freelancerName;
  final String freelancerEmail;
  final String jobTitle;
  final double budget;
  final bool useEscrow;

  AgreementScreen({
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Agreement'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Freelance Project Agreement',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section: Parties
            _buildSectionTitle('Parties Involved'),
            Text(
              'Client:\n$clientName\nEmail: $clientEmail\n\n'
                  'Freelancer:\n$freelancerName\nEmail: $freelancerEmail',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Section: Project Overview
            _buildSectionTitle('Project Overview'),
            Text(
              'Job Title: $jobTitle\n\nAgreed Budget: Rs. $budget\n\n'
                  'Payment Method: ${useEscrow ? 'Escrow (5% fee applies)' : 'Direct Transfer'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Section: Terms
            _buildSectionTitle('Terms of Agreement'),
            Text(
              '- The freelancer agrees to complete the project as per the agreed scope and timeline.\n'
                  '- Upon full payment, ownership of deliverables transfers to the client.\n'
                  '- Revisions will be provided if within the initially agreed scope.\n'
                  '- Both parties agree to maintain confidentiality.\n'
                  '- Quality standards and delivery timelines must be met.\n'
                  '- Client commission: 5% of the total budget.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Section: Confidentiality and Dispute
            _buildSectionTitle('Confidentiality and Dispute Resolution'),
            Text(
              '- Both parties agree to keep all project information confidential.\n'
                  '- Any disputes will be resolved amicably or through mediation if needed.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // Signature and Date
            Divider(),
            Text(
              'Agreement Date: ${DateTime.now().toLocal()}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),

            // Agree Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _confirmAgreement(context);
                },
                child: Text('I Agree', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // Confirmation Dialog for Agreement
  void _confirmAgreement(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agreement Confirmed'),
          content: Text(
              'The agreement has been confirmed.\nWould you like to print a copy for your records?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigate back to the dashboard with a parameter indicating proposal acceptance
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/clientDashboard',
                      (route) => false,
                  arguments: {'proposalAccepted': true},
                );
              },
              child: Text('No, Thanks', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the dashboard with the proposal accepted parameter
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/clientDashboard',
                      (route) => false,
                  arguments: {'proposalAccepted': true},
                );
                print('Print agreement'); // Placeholder for printing functionality
              },
              child: Text('Print', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}