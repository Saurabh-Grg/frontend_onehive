import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'client_dashboard.dart';

class ClientProfileCreation extends StatefulWidget {
  @override
  _ClientProfileCreationState createState() => _ClientProfileCreationState();
}

class _ClientProfileCreationState extends State<ClientProfileCreation> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Profile Image
  XFile? _profileImage;

  // Pick profile image function
  Future<void> _pickProfileImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _profileImage = pickedImage;
        });
      } else {
        _showSnackBar('No image selected');
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
      print('Error picking image: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  // Display a SnackBar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

// Function to build the form steps
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Company Information'),
        content: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : AssetImage('assets/images/default_profile.png') as ImageProvider,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[700])
                        : null,
                  ),
                ),
                if (_profileImage != null)
                  Positioned(
                    right: -12,
                    top: -12,
                    child: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: _removeImage,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the company name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _contactPersonController,
              decoration: InputDecoration(
                labelText: 'Contact Person',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the contact person\'s name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Location & Industry'),
        content: Column(
          children: [
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the company\'s location';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _industryController,
              decoration: InputDecoration(
                labelText: 'Industry',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the industry';
                }
                return null;
              },
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Website & Description'),
        content: Column(
          children: [
            TextFormField(
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Company Website',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the website URL';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  // Function to submit the form data to the backend
  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> profileData = {
          'companyName': _companyNameController.text,
          'contactPerson': _contactPersonController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
          'location': _locationController.text,
          'industry': _industryController.text,
          'website': _websiteController.text,
          'description': _descriptionController.text,
        };

        await createClientProfile(profileData, _profileImage);

        // Clear form and navigate to the dashboard
        setState(() {
          _currentStep = 0;
          _companyNameController.clear();
          _contactPersonController.clear();
          _emailController.clear();
          _phoneNumberController.clear();
          _locationController.clear();
          _industryController.clear();
          _websiteController.clear();
          _descriptionController.clear();
          _profileImage = null;
        });

        // Show confirmation message
        _showSnackBar('Profile created successfully! Redirecting to dashboard...');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientDashboard()),
        );
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Future<void> createClientProfile(Map<String, dynamic> profileData, XFile? profileImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var uri = Uri.parse('http://localhost:3000/api/clientProfile/client-profile');
    var request = http.MultipartRequest('POST', uri);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add profile data fields
    profileData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add image if available
    if (profileImage != null) {
      var imageFile = await http.MultipartFile.fromPath('profileImage', profileImage.path);
      request.files.add(imageFile);
    }

    // Send request
    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      print('Profile created successfully: $responseData');
    } else {
      var responseData = await response.stream.bytesToString();
      print('Failed to create profile: $responseData');
      _showSnackBar('Failed to save profile. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Client Profile', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < _buildSteps().length - 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _submitProfile();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          steps: _buildSteps(),
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            return Row(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.deepOrange,
                  ),
                  onPressed: controls.onStepContinue,
                  child: Text(_currentStep < _buildSteps().length - 1 ? 'Next' : 'Submit', style: TextStyle(color: Colors.white),),
                ),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: controls.onStepCancel,
                    child: Text('Back'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}