import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // Private field to store the current user object
  User? _currentUser;

  // Private field to store the current user's ID
  String _currentUserId = '';
  String? _token; // Add a field to store the token


  // Getter for the current user
  User? get currentUser => _currentUser;
  String? get token => _token; // Add a getter to retrieve the token

  // Getter for currentUserId
  String get currentUserId => _currentUserId;

  // void setUser(User user, String token) {
  //   _user = user;
  //   _token = token; // Store the token
  //   notifyListeners();
  // }

  // Method to set the current user ID and notify listeners
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners(); // Notifies listeners that a change has occurred
  }




  // Method to set the current user and notify listeners
  void setUser(User user, String token) {
    _currentUser = user;
    _token = token; // Store the token
    notifyListeners(); // Notifies listeners of the change
  }

  // Method to clear the current user
  void clearUser() {
    _currentUser = null;
    notifyListeners(); // Notifies listeners of the change
  }
}