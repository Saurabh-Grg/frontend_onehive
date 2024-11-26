import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'freelancer_dashboard.dart';

class FreelancerProfileUpdate extends StatefulWidget {
  final int profileID; // Required parameter for profile ID

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


  // Controllers for different sections
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  // Profile Image, Portfolio Images, and Certificate Images
  XFile? _profileImage;
  List<XFile> _portfolioImages = [];
  List<XFile> _certificateImages = []; // Added for certificates

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
                        ? FileImage(File(_profileImage!.path))
                        : AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                    child: _profileImage == null
                        ? Icon(Icons.camera_alt,
                            size: 40, color: Colors.grey[700])
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                  labelText: 'Bio', border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Skills'),
        content: TextField(
          controller: _skillsController,
          decoration: InputDecoration(
            labelText: 'Skills (comma separated)',
            border: OutlineInputBorder(),
          ),
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Experience'),
        content: TextField(
          controller: _experienceController,
          decoration: InputDecoration(
            labelText: 'Work Experience',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
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
                                image: FileImage(
                                    File(_portfolioImages[index].path)),
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
                                  // Background color for visibility
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
        content: TextField(
          controller: _educationController,
          decoration: InputDecoration(
            labelText: 'Education',
            border: OutlineInputBorder(),
          ),
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
                                image: FileImage(
                                    File(_certificateImages[index].path)),
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
    // Display a SnackBar message indicating profile is saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile Saved!'),
        duration: Duration(seconds: 2),
      ),
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // GestureDetector to trigger the dialog from the right corner of the AppBar
          GestureDetector(
            onTap: () {
              _showAvailabilityDialog(context);  // Show the availability status dialog
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getStatusIcon(),  // Show the icon based on the selected status
            ),
          ),
        ],
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
                      child: Text(
                        _currentStep < _buildSteps().length - 1 ? 'Next' : 'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
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
        ],
      ),
    );
  }

// This method displays the dialog for availability status selection
  void _showAvailabilityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Availability Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Available'),
                onTap: () {
                  setState(() {
                    _availabilityStatus = 'Available';
                  });
                  Navigator.pop(context);  // Close the dialog
                },
              ),
              ListTile(
                leading: Icon(Icons.work, color: Colors.orange),
                title: Text('Busy'),
                onTap: () {
                  setState(() {
                    _availabilityStatus = 'Busy';
                  });
                  Navigator.pop(context);  // Close the dialog
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('Not Available'),
                onTap: () {
                  setState(() {
                    _availabilityStatus = 'Not Available';
                  });
                  Navigator.pop(context);  // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

// This method returns the correct icon based on the selected status
  Widget _getStatusIcon() {
    switch (_availabilityStatus) {
      case 'Available':
        return Icon(Icons.check_circle, color: Colors.green, size: 24);
      case 'Busy':
        return Icon(Icons.work, color: Colors.orange, size: 24);
      case 'Not Available':
        return Icon(Icons.cancel, color: Colors.red, size: 24);
      default:
        return Icon(Icons.event_available, color: Colors.blue, size: 24);  // Default icon
    }
  }


}
