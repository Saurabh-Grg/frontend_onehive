import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DatabaseDesignAndManagementJobPostingForm extends StatefulWidget {
  @override
  _DatabaseDesignAndManagementJobPostingFormState createState() => _DatabaseDesignAndManagementJobPostingFormState();
}

class _DatabaseDesignAndManagementJobPostingFormState extends State<DatabaseDesignAndManagementJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String jobTitle = '';
  String jobDescription = '';
  String databaseType = 'SQL';
  String designType = 'Normalized';
  String performanceRequirement = 'High';
  String securityRequirement = 'Required';
  String dataVolume = 'Less than 1GB';
  String projectDuration = 'Less than 1 month';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String additionalNotes = '';

  // Database type options
  final List<String> databaseTypes = ['SQL', 'NoSQL', 'NewSQL'];

  // Design type options
  final List<String> designTypes = ['Normalized', 'Denormalized', 'Hybrid'];

  // Performance requirements
  final List<String> performanceRequirements = ['Low', 'Medium', 'High'];

  // Security requirements
  final List<String> securityRequirements = ['Required', 'Preferred', 'Not Required'];

  // Data volume options
  final List<String> dataVolumes = ['Less than 1GB', '1GB - 10GB', '10GB - 100GB', 'More than 100GB'];

  // Project duration options
  final List<String> projectDurations = ['Less than 1 month', '1 - 3 months', '3 - 6 months', 'More than 6 months'];

  // Experience levels
  final List<String> experienceLevels = ['Entry-Level', 'Intermediate', 'Expert'];

  // Form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save the form data
      _formKey.currentState!.save();

      // Handle form submission (e.g., send data to server)
      print("Job Title: $jobTitle");
      print("Description: $jobDescription");
      print("Database Type: $databaseType");
      print("Design Type: $designType");
      print("Performance Requirement: $performanceRequirement");
      print("Security Requirement: $securityRequirement");
      print("Data Volume: $dataVolume");
      print("Project Duration: $projectDuration");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Form - Database Design and Management',
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
              // Database Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Database Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: databaseType,
                items: databaseTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    databaseType = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Design Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Design Type',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: designType,
                items: designTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    designType = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Performance Requirement
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Performance Requirement',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: performanceRequirement,
                items: performanceRequirements.map((String requirement) {
                  return DropdownMenuItem<String>(
                    value: requirement,
                    child: Text(requirement),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    performanceRequirement = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Security Requirement
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Security Requirement',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: securityRequirement,
                items: securityRequirements.map((String requirement) {
                  return DropdownMenuItem<String>(
                    value: requirement,
                    child: Text(requirement),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    securityRequirement = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Data Volume
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Data Volume',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: dataVolume,
                items: dataVolumes.map((String volume) {
                  return DropdownMenuItem<String>(
                    value: volume,
                    child: Text(volume),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dataVolume = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Project Duration
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project Duration',
                  filled: true,
                  fillColor: Colors.teal[50],
                  border: OutlineInputBorder(),
                ),
                value: projectDuration,
                items: projectDurations.map((String duration) {
                  return DropdownMenuItem<String>(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    projectDuration = value!;
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
