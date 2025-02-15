import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class AccountSettingController extends GetxController {
  final box = GetStorage();
  final LocalAuthentication auth = LocalAuthentication();

  var isBiometricEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isBiometricEnabled.value = box.read("biometric") ?? false;
  }

  // Toggle biometric authentication
  Future<void> toggleBiometric() async {
    if (isBiometricEnabled.value) {
      // Disable biometric authentication
      isBiometricEnabled.value = false;
    } else {
      // Check if biometric authentication is available
      bool isAvailable = await auth.canCheckBiometrics;
      if (isAvailable) {
        // Authenticate using biometrics
        bool isAuthenticated = await authenticate();
        if (isAuthenticated) {
          isBiometricEnabled.value = true;
        } else {
          isBiometricEnabled.value = false;
        }
      } else {
        // Biometrics not available
        Get.snackbar('Error', 'Biometric authentication is not available');
      }
    }
  }

  // Method to authenticate with biometrics
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  void changeLanguage(String langCode) {
    var locale = Locale(langCode);
    Get.updateLocale(locale);
  }

  void logout() {
    Get.offAllNamed('/login');
  }

  void deleteAccount() {
    Get.snackbar("Account Deleted", "Your account has been successfully deleted.", snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed('/login');
  }
}
