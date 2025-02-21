import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ApiDevelopmentJobPostingForm extends StatefulWidget {
  @override
  _ApiDevelopmentJobPostingFormState createState() => _ApiDevelopmentJobPostingFormState();
}

class _ApiDevelopmentJobPostingFormState extends State<ApiDevelopmentJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String jobTitle = '';
  String jobDescription = '';
  String selectedTechnology = 'Node.js';
  String apiType = 'REST';
  String authenticationMethod = 'OAuth 2.0';
  List<String> endpoints = [];
  String dataFormat = 'JSON';
  DateTime? startDate;
  DateTime? endDate;
  String paymentType = 'Fixed Price';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String additionalNotes = '';

  // Technology options
  final List<String> technologies = ['Node.js', 'Django', 'Flask', 'Spring Boot', 'Ruby on Rails', 'Other'];

  // API Type options
  final List<String> apiTypes = ['REST', 'GraphQL', 'SOAP'];

  // Authentication methods
  final List<String> authenticationMethods = ['OAuth 2.0', 'API Key', 'Basic Auth', 'JWT'];

  // Experience levels
  final List<String> experienceLevels = ['Entry-Level', 'Intermediate', 'Expert'];

  // Payment types
  final List<String> paymentTypes = ['Fixed Price', 'Hourly'];

  // Budget ranges
  final List<String> fixedBudgets = ['\$500 - \$1,000', '\$1,000 - \$2,500', 'Custom Range'];
  final List<String> hourlyRates = ['\$15 - \$30/hour', '\$30 - \$50/hour', 'Custom Range'];

  // Form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save the form data
      _formKey.currentState!.save();

      // Handle form submission (e.g., send data to server)
      print("Job Title: $jobTitle");
      print("Description: $jobDescription");
      print("Technology: $selectedTechnology");
      print("API Type: $apiType");
      print("Authentication Method: $authenticationMethod");
      print("Endpoints: $endpoints");
      print("Data Format: $dataFormat");
      print("Start Date: $startDate");
      print("End Date: $endDate");
      print("Payment Type: $paymentType");
      print("Budget: $budgetRange");
      print("Experience Level: $experienceLevel");
      print("Additional Notes: $additionalNotes");
    }
  }

  // File picker
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        attachedFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  // Date picker
  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
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

  // Endpoints input
  void _addEndpoint(String endpoint) {
    setState(() {
      if (endpoint.isNotEmpty) {
        endpoints.add(endpoint);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Form - API Development and Integration',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: Colors.deepOrange[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 15),

              // Technology Preferences
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Technology',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: selectedTechnology,
                items: technologies.map((String tech) {
                  return DropdownMenuItem<String>(
                    value: tech,
                    child: Text(tech),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTechnology = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // API Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'API Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: apiType,
                items: apiTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    apiType = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Authentication Method
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Authentication Method',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: authenticationMethod,
                items: authenticationMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    authenticationMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Endpoints
              TextFormField(
                decoration: InputDecoration(labelText: 'API Endpoint (e.g., /users, /products)',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: _addEndpoint,
              ),
              // Display added endpoints
              Column(
                children: endpoints.map((endpoint) => Text(endpoint)).toList(),
              ),
              const SizedBox(height: 15),

              // Data Format
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Data Format',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: dataFormat,
                items: ['JSON', 'XML', 'Other'].map((String format) {
                  return DropdownMenuItem<String>(
                    value: format,
                    child: Text(format),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dataFormat = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Project Start Date
              ListTile(
                title: Text('Start Date: ${startDate != null ? startDate.toString() : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, isStart: true),
              ),

              // Project End Date
              ListTile(
                title: Text('End Date: ${endDate != null ? endDate.toString() : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, isStart: false),
              ),
              const SizedBox(height: 15),

              // Payment Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Payment Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: paymentType,
                items: ['Fixed Price', 'Hourly'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paymentType = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Budget Range
              TextFormField(
                decoration: InputDecoration(labelText: 'Budget Range (e.g., \$500 - \$1,000)',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the budget range';
                  }
                  return null;
                },
                onSaved: (value) {
                  budgetRange = value!;
                },
              ),
              const SizedBox(height: 15),

              // Required Experience Level
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Experience Level',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: experienceLevel,
                items: experienceLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    experienceLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Additional Notes
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Notes',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) {
                  additionalNotes = value!;
                },
              ),
              const SizedBox(height: 15),

              // Attach Files
              ElevatedButton(
                onPressed: _pickFiles,
                child: Text('Attach Files'),
              ),
              const SizedBox(height: 15),

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
