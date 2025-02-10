import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ChangePasswordController.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password Field
              _buildPasswordField('Current Password', controller.oldPassword, controller.isOldPasswordObscured),
              const SizedBox(height: 16),

              // New Password Field
              _buildPasswordField('New Password', controller.newPassword, controller.isNewPasswordObscured),
              const SizedBox(height: 16),

              // Confirm New Password Field
              _buildPasswordField('Confirm New Password', controller.confirmPassword, controller.isConfirmPasswordObscured),
              const SizedBox(height: 16),

              // Validation message for matching passwords
              Obx(() => controller.newPassword.value != controller.confirmPassword.value
                  ? const Text('Passwords do not match', style: TextStyle(color: Colors.red))
                  : const SizedBox.shrink()),

              const SizedBox(height: 20),

              // Loading button or normal button
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildChangePasswordButton()),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build password fields with a show/hide toggle
  Widget _buildPasswordField(String label, RxString password, RxBool isObscured) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() => TextField(
          obscureText: isObscured.value,
          onChanged: (value) {
            password.value = value;
          },
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            filled: true,
            fillColor: Colors.white,  // Set text field background color to white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black),  // Black border color
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.deepOrange,
              ),
              onPressed: () {
                isObscured.value = !isObscured.value;
              },
            ),
          ),
        )),
      ],
    );
  }

  // Button to submit password change request
  Widget _buildChangePasswordButton() {
    return GestureDetector(
      onTap: () {
        controller.changePassword();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Change Password',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
