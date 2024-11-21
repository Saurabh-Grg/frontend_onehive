import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UIUXDesignJobPostingForm extends StatefulWidget {
  @override
  _UIUXDesignJobPostingFormState createState() => _UIUXDesignJobPostingFormState();
}

class _UIUXDesignJobPostingFormState extends State<UIUXDesignJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String jobTitle = '';
  String jobDescription = '';
  String projectType = 'Web Application';
  String designFocus = 'UI Design';
  String targetAudience = '';
  String preferredColorScheme = 'Light';
  String platforms = 'Web & Mobile';
  String projectDuration = 'Less than 1 month';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String additionalNotes = '';

  // Project type options
  final List<String> projectTypes = ['Web Application', 'Mobile Application', 'Landing Page', 'E-commerce Website'];

  // Design focus options
  final List<String> designFocusOptions = ['UI Design', 'UX Design', 'UI/UX Design'];

  // Color scheme options
  final List<String> colorSchemes = ['Light', 'Dark', 'Custom'];

  // Platforms options
  final List<String> platformsOptions = ['Web & Mobile', 'Web Only', 'Mobile Only'];

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
      print("Project Type: $projectType");
      print("Design Focus: $designFocus");
      print("Target Audience: $targetAudience");
      print("Preferred Color Scheme: $preferredColorScheme");
      print("Platforms: $platforms");
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
        title: Text('Job Posting Form - UI/UX Design'),
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

              // Project Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project Type'),
                value: projectType,
                items: projectTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    projectType = value!;
                  });
                },
              ),

              // Design Focus
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Design Focus'),
                value: designFocus,
                items: designFocusOptions.map((String focus) {
                  return DropdownMenuItem<String>(
                    value: focus,
                    child: Text(focus),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    designFocus = value!;
                  });
                },
              ),

              // Target Audience
              TextFormField(
                decoration: InputDecoration(labelText: 'Target Audience'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the target audience';
                  }
                  return null;
                },
                onSaved: (value) {
                  targetAudience = value!;
                },
              ),

              // Preferred Color Scheme
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Preferred Color Scheme'),
                value: preferredColorScheme,
                items: colorSchemes.map((String scheme) {
                  return DropdownMenuItem<String>(
                    value: scheme,
                    child: Text(scheme),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    preferredColorScheme = value!;
                  });
                },
              ),

              // Platforms
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Platforms'),
                value: platforms,
                items: platformsOptions.map((String platform) {
                  return DropdownMenuItem<String>(
                    value: platform,
                    child: Text(platform),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    platforms = value!;
                  });
                },
              ),

              // Project Duration
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Project Duration'),
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

              // Budget Range
              TextFormField(
                decoration: InputDecoration(labelText: 'Budget Range (e.g., \$500 - \$1,000)'),
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

              // Required Experience Level
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

              // Submit Button
              SizedBox(height: 20),
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
