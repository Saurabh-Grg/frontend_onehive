import 'dart:convert'; // For json decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';

class JobDetailsPage extends StatefulWidget {
  final int jobId;

  JobDetailsPage({required this.jobId});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  Map<String, dynamic>? jobDetails; // To store the job details
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchJobDetails(); // Fetch the job details when the page loads
  }

  Future<void> fetchJobDetails() async {
    final url = '${ApiEndpoints.jobDetails}/${widget.jobId}'; // Replace with your actual API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          jobDetails = json.decode(response.body)['jobDetails'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load job details');
      }
    } catch (error) {
      print('Error fetching job details: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(jobDetails?['title'] ?? 'Job Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        title: Text('Job Details', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),),
        // backgroundColor: Colors.deepOrange,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      ) // Show a loading spinner while fetching data
          : jobDetails == null
          ? Center(child: Text('Failed to load job details'))
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard(
              title: 'Title',
              value: jobDetails!['title'],
              icon: Icons.work,
            ),
            _buildDetailCard(
              title: 'Description',
              value: jobDetails!['description'],
              icon: Icons.description,
            ),
            _buildDetailCard(
              title: 'Category',
              value: jobDetails!['category'],
              icon: Icons.category,
            ),
            SizedBox(height: 16.0),
            // Display category-specific details based on the job category
            if (jobDetails!['categoryDetails'] != null)
              ..._buildCategorySpecificDetails(jobDetails!['categoryDetails']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required String value, required IconData icon}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
        ),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  List<Widget> _buildCategorySpecificDetails(Map<String, dynamic> categoryDetails) {
    // Filter out keys that contain any identifiers like 'id', 'job_id', or 'frontend_job_id'
    final filteredDetails = Map<String, dynamic>.from(categoryDetails)
      ..removeWhere((key, value) => key.contains('id')); // This will filter any key that has 'id' in its name

    // Create a single card to hold all details
    return [
      Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for the details section
              Text(
                'Category Specific Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              SizedBox(height: 16.0), // Spacing between title and details
              // Create a list of detail widgets
              ...filteredDetails.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key.replaceAll('_', ' ').capitalize(),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      // Optionally, you can use a flexible widget here if you want to limit the text width
                      Flexible(
                        child: Text(
                          entry.value.toString(),
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis, // Add this to truncate long text
                          maxLines: 1, // Limits the text to one line
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    ];
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
