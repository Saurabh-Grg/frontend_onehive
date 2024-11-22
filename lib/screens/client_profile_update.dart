import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClientProfileUpdate extends StatefulWidget {
  final String profileID; // Required parameter for profile ID

  ClientProfileUpdate({Key? key, required this.profileID}) : super(key: key);

  @override
  _ClientProfileUpdateState createState() => _ClientProfileUpdateState();
}

class _ClientProfileUpdateState extends State<ClientProfileUpdate> {
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
  String? _profileImageUrl; // Variable to store the fetched profile image URL

  // New boolean variable to track edit mode
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData(widget.profileID);
  }

  Future<void> _fetchProfileData(String profileId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var response = await http.get(
      Uri.parse('http://localhost:3000/api/clientProfile/client-profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',},

    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      if (data is Map<String, dynamic>) {
        // Print the entire response data for debugging
        print(data); // Add this line to check the response structure
        // Populate the text controllers with existing profile data
        setState(() {
          _companyNameController.text = data['companyName'] ?? '';
          _contactPersonController.text = data['contactPerson'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _locationController.text = data['location'] ?? '';
          _industryController.text = data['industry'] ?? '';
          _websiteController.text = data['website'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _profileImageUrl = data['profileImageUrl'] ?? '';
        });
      } else {
        print('Data is not in the expected format');
      }
    } else {
      print('Failed to fetch profile data: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log response for debugging
    }
  }

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
    }
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
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!.path)) // Display the selected image from the file picker
                    : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                    ? NetworkImage(_profileImageUrl!) // Display the fetched image from the server
                    : AssetImage('assets/images/default_profile.png') as ImageProvider, // Display the default image
                child: _profileImage == null && (_profileImageUrl == null || _profileImageUrl!.isEmpty)
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[700]) // Show camera icon if no image is available
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty || !value.contains('@'))) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
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


  // Submit profile update
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

        // Debugging: Print the profile ID and form data
        print('Profile ID: ${widget.profileID}'); // Log the profileId
        print('Profile Data: $profileData'); // Log the profile data
        await updateClientProfile(widget.profileID, profileData, _profileImage);

      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Future<void> updateClientProfile(String profileId, Map<String, dynamic> profileData, XFile? profileImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var uri = Uri.parse('http://localhost:3000/api/clientProfile/client-profile/update/$profileId');
    print('Updating profile at: $uri'); // Add this line
    var request = http.MultipartRequest('PUT', uri);

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

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      // Redirect to the dashboard after successful update
      Navigator.pushReplacementNamed(context, '/dashboard'); // Adjust this to your actual route
      print('Profile updated successfully: $responseData');
    } else {
      var responseData = await response.stream.bytesToString();
      print('Failed to update profile: $responseData');
      _showSnackBar('Failed to update profile. Try again.');

    }
  }

  // New method to toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing; // Toggle edit mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Client Profile'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
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
                    backgroundColor: Colors.orangeAccent,
                  ),
                  onPressed: controls.onStepContinue,
                  child: Text(_currentStep < _buildSteps().length - 1 ? 'Next' : 'Submit'),
                ),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: controls.onStepCancel,
                    child: Text('Back'),
                  ),
                // New button to toggle edit mode
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.edit_off : Icons.edit,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: _toggleEditMode,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}