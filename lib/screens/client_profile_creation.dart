import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_profile_provider.dart';
import 'client_dashboard.dart';

class ClientProfileCreation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Client Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<ClientProfileProvider>(
        builder: (context, profileProvider, child) {
          return Form(
            child: Stepper(
              currentStep: profileProvider.currentStep,
              onStepContinue: () {
                if (profileProvider.currentStep < 2) {
                  profileProvider.nextStep();
                } else {
                  profileProvider.submitProfile(context);
                  profileProvider.resetForm();

                  // Navigate to dashboard after successful profile creation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ClientDashboard()),
                  );
                }
              },
              onStepCancel: profileProvider.previousStep,
              steps: _buildSteps(profileProvider),
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
                          profileProvider.currentStep < 2 ? 'Next' : 'Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                    if (profileProvider.currentStep > 0)
                      TextButton(
                        onPressed: controls.onStepCancel,
                        child: Text('Back'),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Step> _buildSteps(ClientProfileProvider profileProvider) {
    return [
      Step(
        title: Text('Company Information'),
        content: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: profileProvider.pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileProvider.profileImage != null
                        ? FileImage(File(profileProvider.profileImage!.path))
                        : AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                    child: profileProvider.profileImage == null
                        ? Icon(Icons.camera_alt,
                            size: 40, color: Colors.grey[700])
                        : null,
                  ),
                ),
                if (profileProvider.profileImage != null)
                  Positioned(
                    right: -12,
                    top: -12,
                    child: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: profileProvider.removeImage,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: profileProvider.companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: profileProvider.contactPersonController,
              decoration: InputDecoration(
                labelText: 'Contact Person',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: profileProvider.emailController,
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
              controller: profileProvider.phoneNumberController,
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
            // Continue with other fields...
          ],
        ),
        isActive: profileProvider.currentStep >= 0,
      ),
      Step(
        title: Text('Location & Industry'),
        content: Column(
          children: [
            TextFormField(
              controller: profileProvider.locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: profileProvider.industryController,
              decoration: InputDecoration(
                labelText: 'Industry',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        isActive: profileProvider.currentStep >= 1,
      ),
      Step(
        title: Text('Website & Description'),
        content: Column(
          children: [
            TextFormField(
              controller: profileProvider.websiteController,
              decoration: InputDecoration(
                labelText: 'Company Website',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: profileProvider.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        isActive: profileProvider.currentStep >= 2,
      ),
    ];
  }
}
