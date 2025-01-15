import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/FreelancerProfileController.dart';
import '../controllers/UserController.dart';
import 'freelancer_dashboard.dart';
import 'package:http/http.dart' as http;

class FreelancerProfileUpdate extends StatefulWidget {
  final int profileID; // Required parameter for profile ID
  final FreelancerProfileController controller =
      Get.put(FreelancerProfileController());

  FreelancerProfileUpdate({required this.profileID}); // Proper constructor

  @override
  _FreelancerProfileUpdateState createState() =>
      _FreelancerProfileUpdateState();
}

class _FreelancerProfileUpdateState extends State<FreelancerProfileUpdate> {
  int _currentStep = 0; // Track the current step in the form
  String _availabilityStatus = 'Available'; // Default value
  // Define the boolean variable to track the dropdown state
  bool _isDropdownOpen = false;

  // New boolean variable to track edit mode
  bool _isEditing = false;

  // Controllers for different sections
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  // Profile Image, Portfolio Images, and Certificate Images
  XFile? _profileImage;
  String? _profileImageUrl;
  List<XFile> _portfolioImages = [];
  List<XFile> _certificateImages = []; // Added for certificates

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  final UserController userController = Get.find();

  Future<void> _fetchProfileData() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/api/freelancerProfile/my-profile'),
        headers: {
          'Authorization': 'Bearer ${userController.token.value}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        if (data is Map<String, dynamic>) {
          setState(() {
            // Populate Freelancer profile fields
            _nameController.text = data['name'] ?? '';
            _bioController.text = data['bio'] ?? '';
            _skillsController.text = data['skills'] ?? '';
            _educationController.text = data['education'] ?? '';
            _experienceController.text = data['experience'] ?? '';
            _profileImageUrl = data['profileImageUrl'] ?? '';
            // Populate portfolio and certificate images
            var portfolioImageUrls =
                List<String>.from(data['portfolioImages'] ?? []);
            var certificateImageUrls =
                List<String>.from(data['certificates'] ?? []);

            _portfolioImages = portfolioImageUrls
                .map((url) =>
                    XFile(url)) // Convert URLs to XFile for consistency
                .toList();
            _certificateImages = certificateImageUrls
                .map((url) =>
                    XFile(url)) // Convert URLs to XFile for consistency
                .toList();
          });
        } else {
          print('Data is not in the expected format');
        }
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  // Function to pick profile image
  Future<void> _pickProfileImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
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

  // Function to pick multiple portfolio images
  Future<void> _pickPortfolioImages() async {
    final pickedImages =
        await ImagePicker().pickMultiImage(); // Allow multiple images
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _portfolioImages.addAll(pickedImages);
      });
    } else {
      _showSnackBar('No images selected');
    }
  }

  // Function to pick multiple certificate images
  Future<void> _pickCertificateImages() async {
    final pickedImages =
        await ImagePicker().pickMultiImage(); // Allow multiple images
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _certificateImages.addAll(pickedImages);
      });
    } else {
      _showSnackBar('No images selected');
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  // Method to show SnackBar messages
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Function to build the steps
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Personal Information'),
        content: Column(
          children: [
            // Profile Picture with an option to change
            Stack(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!
                            .path)) // Display the selected image from the file picker
                        : (_profileImageUrl != null &&
                                _profileImageUrl!.isNotEmpty)
                            ? NetworkImage(
                                _profileImageUrl!) // Display the fetched image from the server
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                    // Display the default image
                    child: _profileImage == null &&
                            (_profileImageUrl == null ||
                                _profileImageUrl!.isEmpty)
                        ? Icon(Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[
                                700]) // Show camera icon if no image is available
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
            // Input fields for Name and Bio
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter the full name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                  labelText: 'Bio', border: OutlineInputBorder()),
              enabled: _isEditing,
              // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter your bio';
                }
                return null;
              },
              maxLines: 3,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Skills'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Add vertical space between title and content
            TextFormField(
              controller: _skillsController,
              decoration: InputDecoration(
                labelText: 'Skills (comma separated)',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter your skills';
                }
                return null;
              },
              maxLines: 3,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Experience'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: _experienceController,
              decoration: InputDecoration(
                labelText: 'Work Experience',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,
              // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter your experiences';
                }
                return null;
              },
              maxLines: 3,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text('Portfolio'),
        content: Column(
          children: [
            // Display selected portfolio images with a remove icon
            _portfolioImages.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _portfolioImages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 images per row
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          // Image container with rounded borders
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: _portfolioImages[index]
                                        .path
                                        .startsWith('http')
                                    ? NetworkImage(_portfolioImages[index].path)
                                    : FileImage(
                                            File(_portfolioImages[index].path))
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: double.infinity,
                          ),
                          // Positioned cancel icon
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _portfolioImages.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Text('No portfolio images added'),
            SizedBox(height: 10),
            // Button to select multiple portfolio images
            ElevatedButton.icon(
              onPressed: _pickPortfolioImages,
              icon: Icon(Icons.image),
              label: Text('Add Portfolio Images'),
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: Text('Education'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: _educationController,
              decoration: InputDecoration(
                labelText: 'Education',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing, // Enable based on edit mode
              validator: (value) {
                if (_isEditing && (value == null || value.isEmpty)) {
                  return 'Please enter educations';
                }
                return null;
              },
              maxLines: 3,
            ),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
      Step(
        title: Text('Certificates'),
        content: Column(
          children: [
            _certificateImages.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // Disable scrolling for GridView
                    itemCount: _certificateImages.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 images per row
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          // Certificate image with rounded corners
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: _certificateImages[index]
                                        .path
                                        .startsWith('http')
                                    ? NetworkImage(
                                        _certificateImages[index].path)
                                    : FileImage(File(
                                            _certificateImages[index].path))
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            width: double.infinity,
                          ),
                          // Positioned cancel icon
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _certificateImages.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // Background color for better visibility
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Text('No certificate images added'),
            SizedBox(height: 10),
            // Button to select multiple certificate images
            ElevatedButton.icon(
              onPressed: _pickCertificateImages,
              icon: Icon(Icons.image),
              label: Text('Add Certificate Images'),
            ),
          ],
        ),
        isActive: _currentStep >= 5,
      )
    ];
  }

  // Method to handle form submission
  void _submitProfile() {
    // // Display a SnackBar message indicating profile is saved
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Profile Saved!'),
    //     duration: Duration(seconds: 2),
    //   ),
    // );

    // Optionally, you can reset the form or navigate to another screen
    setState(() {
      _currentStep = 0; // Reset to the first step
      _nameController.clear();
      _bioController.clear();
      _skillsController.clear();
      _experienceController.clear();
      _educationController.clear();
      _profileImage = null;
      _portfolioImages.clear();
      _certificateImages.clear(); // Clear certificate images
    });

    // Navigate to the Dashboard screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FreelancerDashboard()),
    );
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
        title: Text(
          'Update Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < _buildSteps().length - 1) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  _submitProfile(); // Final submit when the user completes all steps
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
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
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
                      child: Text(
                        _currentStep < _buildSteps().length - 1
                            ? 'Next'
                            : 'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: Text('Back'),
                      ),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.edit_off : Icons.edit,
                        color: Colors.deepOrange,
                      ),
                      onPressed: _toggleEditMode,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
