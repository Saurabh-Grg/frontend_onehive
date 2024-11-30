import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onehive_frontend/screens/registration_form.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'forgot_password_screen.dart';
import 'home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Track password visibility

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      final loginData = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Store the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Store the user ID in SharedPreferences
        dynamic userIdValue = responseData['user']['user_id']; // Fetch the user ID
        String user_id = userIdValue.toString(); // Convert to String if it's not already

        await prefs.setString('user_id', user_id);

        // Fetch user data and handle potential null values
        final userData = responseData['user'];

        // Use null-aware operators to prevent null errors
        String userId = userData['user_id']?.toString() ?? '';
        String role = userData['role'] ?? '';
        String userEmail = userData['email'] ?? '';
        String userFullName = userData['username'] ?? '';
        String city = userData['city'] ?? '';

        // Ensure userId is not empty before parsing
        if (userId.isEmpty) {
          // Handle error: User ID is not available
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ID not found')));
          return;
        }

        await prefs.setString('username', userFullName);

        // Create the User instance
        User user = User(
          userId: int.parse(userId), // Ensure userId is an int
          username: userFullName,
          password: password, // Keep password here for any future needs (not advised in production)
          email: userEmail,
          role: role,
          city: city,
        );

        // Access the userProvider using Provider.of in the BuildContext
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Set the user in the provider
        userProvider.setUser(User(
          userId: user.userId,
          username: user.username,
          password: '', // Empty or null since you may not need this after login
          email: user.email,
          role: user.role,
          city: user.city,
        ), token);

        bool isFreelancer = role.trim().toLowerCase() == 'freelancer';

        // Navigate to HomePage and pass the user's email and role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(username: userFullName, email: userEmail, isFreelancer: isFreelancer)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Space between items
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
                      child: Image.asset(
                        'assets/images/OneHive.png', // Path to your logo image
                        height: 100, // Adjust the height as needed
                        width: 100,  // Optional: Set width if you want a square aspect ratio
                        fit: BoxFit.cover, // Ensures the image fills the container while keeping aspect ratio
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text(
                          'ONEHIVE',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        Text('काम र क्षमताको संगम।')
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60), // Space between logo and welcome text
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,),
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggle password visibility
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationForm()));
                  },
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(color: Colors.deepOrangeAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
