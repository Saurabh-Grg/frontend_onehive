import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class GraphicDesignBrandingJobPostingForm extends StatefulWidget {
  @override
  _GraphicDesignBrandingJobPostingFormState createState() => _GraphicDesignBrandingJobPostingFormState();
}

class _GraphicDesignBrandingJobPostingFormState extends State<GraphicDesignBrandingJobPostingForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String jobTitle = '';
  String jobDescription = '';
  String designType = 'Logo Design';
  String brandingGoals = 'Brand Identity';
  String targetAudience = '';
  String colorPreferences = 'No Preference';
  String styleGuidelines = 'Modern';
  String projectDuration = 'Less than 1 month';
  String budgetRange = '';
  String experienceLevel = 'Entry-Level';
  List<File>? attachedFiles = [];
  String additionalNotes = '';

  // Design type options
  final List<String> designTypes = ['Logo Design', 'Business Card Design', 'Brochure Design', 'Social Media Graphics', 'Brand Identity'];

  // Branding goals options
  final List<String> brandingGoalsOptions = ['Brand Identity', 'Rebranding', 'Marketing Materials', 'Social Media Presence'];

  // Color preferences options
  final List<String> colorPreferencesOptions = ['No Preference', 'Specific Colors', 'Pastel Colors', 'Bold Colors'];

  // Style guidelines options
  final List<String> styleGuidelinesOptions = ['Modern', 'Classic', 'Minimalist', 'Playful'];

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
      print("Design Type: $designType");
      print("Branding Goals: $brandingGoals");
      print("Target Audience: $targetAudience");
      print("Color Preferences: $colorPreferences");
      print("Style Guidelines: $styleGuidelines");
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
        title: Text('Job Posting Form - Graphic Design and Branding'),
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

              // Design Type
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Design Type'),
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

              // Branding Goals
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Branding Goals'),
                value: brandingGoals,
                items: brandingGoalsOptions.map((String goal) {
                  return DropdownMenuItem<String>(
                    value: goal,
                    child: Text(goal),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    brandingGoals = value!;
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

              // Color Preferences
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Color Preferences'),
                value: colorPreferences,
                items: colorPreferencesOptions.map((String preference) {
                  return DropdownMenuItem<String>(
                    value: preference,
                    child: Text(preference),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    colorPreferences = value!;
                  });
                },
              ),

              // Style Guidelines
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Style Guidelines'),
                value: styleGuidelines,
                items: styleGuidelinesOptions.map((String guideline) {
                  return DropdownMenuItem<String>(
                    value: guideline,
                    child: Text(guideline),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    styleGuidelines = value!;
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
