import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable to track the theme mode
  var isDarkTheme = false.obs;

  // Function to toggle the theme
  void toggleTheme() {
    if (isDarkTheme.value) {
      Get.changeTheme(ThemeData.light());
    } else {
      Get.changeTheme(ThemeData.dark());
    }
    isDarkTheme.toggle(); // Toggle the boolean value
  }
}