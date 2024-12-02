import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ClientProfileProvider with ChangeNotifier {

  // Controllers for input fields
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  XFile? profileImage;
  int currentStep = 0;

  // Method to pick profile image
  Future<void> pickProfileImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        profileImage = pickedImage;
        notifyListeners();
      } else {
        throw 'No image selected';
      }
    } catch (e) {
      throw 'Error picking image: $e';
    }
  }

  // Method to remove profile image
  void removeImage() {
    profileImage = null;
    notifyListeners();
  }

  // Method to submit the profile
  Future<void> submitProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to save profile: Missing token')));
      return;
    }

    var uri = Uri.parse(ApiEndpoints.createClientProfile);
    var request = http.MultipartRequest('POST', uri);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add profile data fields
    request.fields['companyName'] = companyNameController.text;
    request.fields['contactPerson'] = contactPersonController.text;
    request.fields['email'] = emailController.text;
    request.fields['phoneNumber'] = phoneNumberController.text;
    request.fields['location'] = locationController.text;
    request.fields['industry'] = industryController.text;
    request.fields['website'] = websiteController.text;
    request.fields['description'] = descriptionController.text;

    // Add image if available
    if (profileImage != null) {
      var imageFile = await http.MultipartFile.fromPath('profileImage', profileImage!.path);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save profile. Try again.')));
    }
  }

  // Method to reset the form data
  void resetForm() {
    companyNameController.clear();
    contactPersonController.clear();
    emailController.clear();
    phoneNumberController.clear();
    locationController.clear();
    industryController.clear();
    websiteController.clear();
    descriptionController.clear();
    profileImage = null;
    currentStep = 0;
    notifyListeners();
  }

  // Stepper logic for step navigation
  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }
}
