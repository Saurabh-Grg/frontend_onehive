import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:onehive_frontend/services/job_posting_service.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullStackJobPostingForm extends StatefulWidget {
  @override
  _FullStackJobPostingFormState createState() =>
      _FullStackJobPostingFormState();
}

class _FullStackJobPostingFormState extends State<FullStackJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String selectedFrontendFramework = 'Flutter';
  String selectedBackendFramework = 'Node.js';
  String databaseType = 'MySQL';
  String complexity = 'Simple';
  DateTime? startDate;
  DateTime? endDate;
  String paymentType = 'Fixed Price';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String communicationChannel = 'Email';
  String communicationFrequency = 'Daily Updates';
  String additionalNotes = '';

  // Frontend Framework options
  final List<String> frontendFrameworks = [
    'Flutter',
    'React',
    'Angular',
    'Vue.js',
    'Other'
  ];

  // Backend Framework options
  final List<String> backendFrameworks = [
    'Node.js',
    'Django',
    'Laravel',
    'Spring Boot',
    'Other'
  ];

  // Database options
  final List<String> databases = [
    'MySQL',
    'PostgreSQL',
    'MongoDB',
    'SQLite',
    'Other'
  ];

  // Experience levels
  final List<String> experienceLevels = [
    'Entry-Level',
    'Intermediate',
    'Expert'
  ];

  // Payment types
  final List<String> paymentTypes = ['Fixed Price', 'Hourly'];

  // Budget ranges
  // final List<String> fixedBudgets = ['\$500 - \$1,000', '\$1,000 - \$2,500', 'Custom Range'];
  // final List<String> hourlyRates = ['\$15 - \$30/hour', '\$30 - \$50/hour', 'Custom Range'];

  // Form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Retrieve common job details from JobPostingService
      final jobPostingService =
          Provider.of<JobPostingService>(context, listen: false);
      final commonJobDetails =
          jobPostingService.getJobPostingData(); // Fetch common details

      // Log common job details for debugging
      print('Common Job Details: $commonJobDetails');

      // Ensure common job details are not null or empty
      if (commonJobDetails.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Common job details are missing!')),
        );
        return;
      }

      // Store common job details temporarily
      try {
        await jobPostingService
            .storeTempJob(); // Call to store common job details
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error storing common job details: $error')),
        );
        return;
      }

      // Merge common job details with backend job details
      final jobPostingData = {
        'commonDetails': commonJobDetails,
        'fullStackDetails': {
          'selected_frontend_framework': selectedFrontendFramework,
          'selected_backend_framework': selectedBackendFramework,
          'database_type': databaseType,
          'complexity': complexity,
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'payment_type': paymentType,
          'budget_range': budgetRange,
          'experience_level': experienceLevel,
          'communication_channel': communicationChannel,
          'communication_frequency': communicationFrequency,
          'additional_notes': additionalNotes,
        },
      };

      // Log the complete job posting data before submission
      print('Complete Job Posting Data: $jobPostingData');

      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('job_token');

      // Send the complete job posting data to the server
      try {
        await _sendJobPostingToServer(
            jobPostingData, token); // Pass the token to the server
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting job posting: $error')),
        );
      }
    } else {
      print('Form validation failed');
    }
  }

  // Function to send job posting data to the backend
  Future<void> _sendJobPostingToServer(
      Map<String, dynamic> jobPostingData, String? token) async {
    final url = Uri.parse(
        'http://localhost:3000/api/jobPosting/submit-fullStack-job'); // Replace with your actual endpoint

    // Prepare the data for submission
    print('Preparing to send Job Posting Data to Server: $jobPostingData');

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
          // Include the token in the Authorization header
        },
        body: json.encode(jobPostingData), // Convert the data to JSON
        // Ensure credentials are included
      );

      // Log the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check for success
      if (response.statusCode == 201) {
        print('Submission successful, navigating back...');
        // Navigate back to the previous screen
        Navigator.pop(context); // This will take the user back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job posting submitted successfully!')),
        );
        // Optionally clear the form or navigate to another page
      } else {
        throw Exception('Failed to submit job posting: ${response.body}');
      }
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting job posting: $error')),
      );
    }
  }

  // File picker
  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        attachedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  // Date picker
  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Posting Form - Full-Stack Development',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Frontend Framework/Technology Preferences
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Frontend Framework/Technology',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: selectedFrontendFramework,
                items: frontendFrameworks.map((String framework) {
                  return DropdownMenuItem<String>(
                    value: framework,
                    child: Text(framework),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFrontendFramework = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Backend Framework
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Backend Framework/Technology',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: selectedBackendFramework,
                items: backendFrameworks.map((framework) {
                  return DropdownMenuItem<String>(
                    value: framework,
                    child: Text(framework),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => selectedBackendFramework = value!),
              ),
              const SizedBox(height: 15),

              // Database Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Database Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: databaseType,
                items: databases.map((db) {
                  return DropdownMenuItem<String>(
                    value: db,
                    child: Text(db),
                  );
                }).toList(),
                onChanged: (value) => setState(() => databaseType = value!),
              ),
              const SizedBox(height: 15),

              // Complexity
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Complexity Level',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: complexity,
                items: ['Simple', 'Moderate', 'Complex'].map((complexity) {
                  return DropdownMenuItem<String>(
                    value: complexity,
                    child: Text(complexity),
                  );
                }).toList(),
                onChanged: (value) => setState(() => complexity = value!),
              ),
              const SizedBox(height: 15),

              // Start Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Start Date: ${startDate != null ? startDate.toString() : 'Select'}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.teal),
                onTap: () => _selectDate(context, isStart: true),
              ),

              // End Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'End Date: ${endDate != null ? endDate.toString() : 'Select'}',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                trailing: Icon(Icons.calendar_today, color: Colors.teal),
                onTap: () => _selectDate(context, isStart: false),
              ),
              const SizedBox(height: 15),

              // Payment Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Payment Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: paymentType,
                items: paymentTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => setState(() => paymentType = value!),
              ),
              const SizedBox(height: 15),

              // Budget Range
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Budget Range (e.g., Rs.5000 - Rs.10,000)',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the budget range' : null,
                onSaved: (value) => budgetRange = value!,
              ),
              const SizedBox(height: 15),

              // Experience Level
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Experience Level',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: experienceLevel,
                items: experienceLevels.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) => setState(() => experienceLevel = value!),
              ),
              const SizedBox(height: 15),

              // Communication Preferences
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Preferred Communication Channel',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: communicationChannel,
                items: ['Email', 'Slack', 'Zoom', 'Other'].map((channel) {
                  return DropdownMenuItem<String>(
                    value: channel,
                    child: Text(channel),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => communicationChannel = value!),
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Communication Frequency',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: communicationFrequency,
                items: ['Daily Updates', 'Weekly Updates', 'On Completion']
                    .map((frequency) {
                  return DropdownMenuItem<String>(
                    value: frequency,
                    child: Text(frequency),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => communicationFrequency = value!),
              ),
              const SizedBox(height: 15),

              // Additional Notes
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Additional Notes',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => additionalNotes = value!,
              ),
              const SizedBox(height: 15),

              // File Upload
              SizedBox(
                width: double.infinity,
                // This makes the button take the full width of the device
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _pickFiles,
                      child: Text('Attach Additional Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent[600],
                      ),
                    ),
                    // Display attached files
                    if (attachedFiles != null && attachedFiles!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: attachedFiles!.map((file) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    file.path.split('/').last,
                                    // Get the file name from the path
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      // Remove the file from the list
                                      attachedFiles!.remove(file);
                                    });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Submit Job Posting',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent[700],
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
