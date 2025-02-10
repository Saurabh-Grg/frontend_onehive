import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  // Managing password visibility
  var isOldPasswordObscured = true.obs;
  var isNewPasswordObscured = true.obs;
  var isConfirmPasswordObscured = true.obs;

  // Method to change the password
  Future<void> changePassword() async {
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'New passwords do not match');
      return;
    }

    // Password change logic, such as API call
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // On success
    isLoading.value = false;
    Get.snackbar('Success', 'Password changed successfully');

    // Optionally navigate away from this screen
    Get.back();
  }
}
