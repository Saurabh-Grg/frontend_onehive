import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API requests
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:onehive_frontend/screens/job_details_page.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // For JSON decoding

class AllJobPostingsPage extends StatefulWidget {
  @override
  _AllJobPostingsPageState createState() => _AllJobPostingsPageState();
}

class _AllJobPostingsPageState extends State<AllJobPostingsPage> {

  // Example token (you might fetch this from shared preferences or some other state management solution)
  String? token;

  String username = '';

  @override
  void initState() {
    super.initState();
    _getToken();
    _getUserId();// Fetch the token when dashboard initializes;
    _loadUserFullName(); // Load the username from preferences when the screen is initialized
    fetchJobs(); // Fetch jobs when the widget is initialized
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Retrieve the token
    print('Token: $token'); // Print the token for debugging

    // Once the token is fetched, you can load the user profile
    if (token != null) {
      print('token found');
    } else {
      print('No token found. User may not be logged in.');
    }
  }

  // Fetch the user's full name from SharedPreferences
  Future<void> _loadUserFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User'; // Default to 'User' if null
    });
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id'); // Retrieve user ID from Shared Preferences
  }

  // Sample job data (replace this with actual data from your API or state)
  List<Map<String, String>> jobs = [];

  // Function to fetch job postings from the backend
  Future<void> fetchJobs() async {
    String? user_id = await _getUserId();
    final String url = '${ApiEndpoints.getTotalJobsPostedByAClient}/$user_id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jobs = List<Map<String, String>>.from(data['jobs'].map((job) => {
            'job_id': job['job_id'].toString(),  // Include jobId here
            'title': job['title'].toString(),
            'description': job['description'].toString(), // Add description here
            'category': job['category'].toString(),
            'status': job['status'].toString(),
            'payment_status': job['payment_status'].toString()
          }));
        });
      } else {
        print('Failed to load jobs');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    }
  }

  // Function to delete a job
  void _deleteJob(int index) {
    setState(() {
      jobs.removeAt(index); // Remove job from list
    });
    // You can also send a delete request to your backend here
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('All Job Postings'),
      ),
      body: jobs.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
          : _buildActiveJobPostingsList(screenWidth), // Display job postings
    );
  }


  // Job postings widget
  Widget _buildActiveJobPostingsList(double screenWidth) {
    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.02), // Add padding for the ListView
      itemCount: jobs.length, // Show all jobs
      itemBuilder: (context, index) {
        final job = jobs.reversed.toList()[index]; // Reverse the order of jobs
        return Card(
          margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02), // Responsive margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: ListTile(
            title: Text(
              job['title']!,
              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.deepOrange),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${job['description']}'), // Display job description
                Text('Category: ${job['category']}'),
                Text(
                  'Job Status: ${job['status']}',
                  style: TextStyle(
                    color: _getJobStatusColor(job['status']),
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Payment Status: ${job['payment_status']}',
                  style: TextStyle(
                    color: _getPaymentStatusColor(job['payment_status']),
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {
                    // Implement edit functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    // Remove job from the list when delete is pressed
                    _deleteJob(index);
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigate to JobDetailsPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailsPage(jobId: int.parse(job['job_id']!)),
                ),
              );
            },
          ),
        );
      },
    );
  }
  // Helper function to get color based on job status
  Color _getJobStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.amber;
      case 'ongoing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'disputed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper function to get color based on job status
  Color _getPaymentStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'unpaid':
        return Colors.red;
      case 'pending':
        return Colors.amber;
      case 'escrowed':
        return Colors.blue;
      case 'released':
        return Colors.green;
      case 'disputed':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }
}