import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AccountSettingController extends GetxController {
  final box = GetStorage();

  var isBiometricEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isBiometricEnabled.value = box.read("biometric") ?? false;
  }

  void toggleBiometric() {
    isBiometricEnabled.toggle();
    box.write("biometric", isBiometricEnabled.value);
  }

  void logout() {
    Get.offAllNamed('/login');
  }

  void deleteAccount() {
    Get.snackbar("Account Deleted", "Your account has been successfully deleted.", snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed('/login');
  }
}
