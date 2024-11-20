import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // Private field to store the current user's ID
  String _currentUserId = '';

  // Getter for currentUserId
  String get currentUserId => _currentUserId;

  // Method to set the current user ID and notify listeners
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners(); // Notifies listeners that a change has occurred
  }

  // Private field to store the current user object
  User? _currentUser;

  // Getter for the current user
  User? get currentUser => _currentUser;

  // Method to set the current user and notify listeners
  void setUser(User user) {
    _currentUser = user;
    notifyListeners(); // Notifies listeners of the change
  }

  // Method to clear the current user
  void clearUser() {
    _currentUser = null;
    notifyListeners(); // Notifies listeners of the change
  }
}