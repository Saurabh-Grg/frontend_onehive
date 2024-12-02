import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProposalForm extends StatefulWidget {
  final int jobId;

  const ProposalForm({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  _ProposalFormState createState() => _ProposalFormState();
}

class _ProposalFormState extends State<ProposalForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  bool _useEscrow = false; // Variable to track escrow selection

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  // Example token (you might fetch this from shared preferences or some other state management solution)
  String? token;

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Retrieve the token
  }

  Future<void> _submitProposal() async {
    String name = _nameController.text.trim();
    double? budget = double.tryParse(_budgetController.text.trim());

    if (name.isNotEmpty && budget != null) {
      // Calculate escrow charge if selected
      double escrowCharge = _useEscrow ? budget * 0.05 : 0.0;
      double finalBudget = budget - escrowCharge;

      // Prepare proposal data
      final proposalData = {
        'job_id': widget.jobId,
        'name': name,
        'budget': budget,
        'use_escrow': _useEscrow,
      };

      // Send proposal data to the backend
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/proposals/submit'),
          // Replace with your API endpoint
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(proposalData),
        );

        if (response.statusCode == 201) {
          // Handle successful submission
          final proposal = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Proposal submitted successfully!')),
          );
          Navigator.pop(context); // Close the modal after submission
        } else {
          // Handle error response
          final error = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error['error']}')),
          );
        }
      } catch (e) {
        // Handle network or other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
      // Show error if fields are invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Proposal',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          // Freelancer Name Field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12.0),
          // Budget Field within client’s budget range
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Your Budget ',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12.0),
          // Escrow Option with Description
          Row(
            children: [
              Checkbox(
                value: _useEscrow,
                onChanged: (value) {
                  setState(() {
                    _useEscrow = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  'Use escrow for security (5% of your budget will be deducted as escrow charge).',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Confirm Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: _submitProposal,
              child: Text(
                'Confirm',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
