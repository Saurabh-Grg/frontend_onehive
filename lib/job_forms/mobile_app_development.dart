import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MobileAppDevelopmentJobPostingForm extends StatefulWidget {
  @override
  _MobileAppDevelopmentJobPostingFormState createState() => _MobileAppDevelopmentJobPostingFormState();
}

class _MobileAppDevelopmentJobPostingFormState extends State<MobileAppDevelopmentJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String jobTitle = '';
  String jobDescription = '';
  String selectedPlatform = 'iOS';
  String appType = 'Native';
  String designPreference = 'Material Design';
  String backendIntegration = 'Yes';
  List<String> features = [];
  DateTime? startDate;
  DateTime? endDate;
  String paymentType = 'Fixed Price';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String additionalNotes = '';

  // Platform options
  final List<String> platforms = ['iOS', 'Android', 'Cross-Platform'];

  // App type options
  final List<String> appTypes = ['Native', 'Hybrid', 'Web'];

  // Design preferences
  final List<String> designPreferences = ['Material Design', 'Flat Design', 'Custom'];

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
      _formKey.currentState!.save();
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
          if (picked.isBefore(startDate ?? picked)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('End date must be after start date.')));
          } else {
            endDate = picked;
          }
        }
      });
    }
  }

  // Features input
  final TextEditingController featureController = TextEditingController();
  void _addFeature() {
    if (featureController.text.isNotEmpty) {
      setState(() {
        features.add(featureController.text);
        featureController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Posting Form - Mobile App Development'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Job Title
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  jobTitle = value!;
                },
              ),

              // Job Description
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job description';
                  }
                  return null;
                },
                onSaved: (value) {
                  jobDescription = value!;
                },
              ),

              // Platform Preferences
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Platform'),
                value: selectedPlatform,
                items: platforms.map((String platform) {
                  return DropdownMenuItem<String>(
                    value: platform,
                    child: Text(platform),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPlatform = value!;
                  });
                },
              ),

              // App Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'App Type'),
                value: appType,
                items: appTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    appType = value!;
                  });
                },
              ),

              // Design Preference
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Design Preference'),
                value: designPreference,
                items: designPreferences.map((String design) {
                  return DropdownMenuItem<String>(
                    value: design,
                    child: Text(design),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    designPreference = value!;
                  });
                },
              ),

              // Backend Integration
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Backend Integration'),
                value: backendIntegration,
                items: ['Yes', 'No'].map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    backendIntegration = value!;
                  });
                },
              ),

              // Features
              TextFormField(
                controller: featureController,
                decoration: InputDecoration(labelText: 'Feature (e.g., Push Notifications)'),
              ),
              ElevatedButton(
                onPressed: _addFeature,
                child: Text('Add Feature'),
              ),
              // Display added features
              Column(
                children: features.map((feature) => Text(feature)).toList(),
              ),

              // Project Start Date
              ListTile(
                title: Text('Start Date: ${startDate != null ? "${startDate!.month}/${startDate!.day}/${startDate!.year}" : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, isStart: true),
              ),

              // Project End Date
              ListTile(
                title: Text('End Date: ${endDate != null ? "${endDate!.month}/${endDate!.day}/${endDate!.year}" : 'Select'}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, isStart: false),
              ),

              // Payment Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Payment Type'),
                value: paymentType,
                items: paymentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paymentType = value!;
                    // Update budget range options if necessary
                  });
                },
              ),

              // Budget Range
              TextFormField(
                decoration: InputDecoration(labelText: 'Budget Range (e.g., \$500 - \$1,000)'),
                onSaved: (value) {
                  budgetRange = value!;
                },
              ),

              // Experience Level
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Experience Level'),
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

              // Additional Notes
              TextFormField(
                decoration: InputDecoration(labelText: 'Additional Notes'),
                maxLines: 3,
                onSaved: (value) {
                  additionalNotes = value!;
                },
              ),

              // Attach Files
              ElevatedButton(
                onPressed: _pickFiles,
                child: Text('Attach Files'),
              ),
              // Display attached files
              Column(
                children: attachedFiles!.map((file) => Text(file.path.split('/').last)).toList(),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Job Posting'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}