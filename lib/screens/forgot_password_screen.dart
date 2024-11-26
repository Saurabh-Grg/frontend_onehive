import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _isLoading = false;  // Track loading state

  // Validation function for email input
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'\S+@\S+\.\S+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Submit the Forgot Password request
  Future<void> _submitForgotPassword() async {
    // Ensure the email is valid before proceeding
    String? emailValidationError = _validateEmail(_emailController.text);
    if (emailValidationError != null) {
      // Show validation error if email is invalid
      setState(() {
        _message = emailValidationError;
      });
      return; // Don't proceed further if email is invalid
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/request-password-reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _emailController.text}),
    );

    setState(() {
      _isLoading = false; // Hide loading indicator after request completes
    });

    if (response.statusCode == 200) {
      // Show success message in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to your email.')),
      );

      // Clear the email field
      _emailController.clear();

      setState(() {
        _message = '';
      });


    } else {
      // Show error message in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${jsonDecode(response.body)['message']}')),
      );

      setState(() {
        _message = 'Error: ${jsonDecode(response.body)['message']}';
      });
    }
  }

  // Future<void> _submitForgotPassword() async {
  //   if (!_validateEmail(_emailController.text)!.isEmpty) {
  //     setState(() {
  //       _isLoading = true; // Show loading indicator
  //     });
  //
  //     final response = await http.post(
  //       Uri.parse('http://localhost:3000/api/auth/request-password-reset'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'email': _emailController.text}),
  //     );
  //
  //     setState(() {
  //       _isLoading = false; // Hide loading indicator after request completes
  //     });
  //
  //     if (response.statusCode == 200) {
  //       // Show success message in SnackBar
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Password reset link sent to your email.')),
  //       );
  //
  //       // Clear the email field
  //       _emailController.clear();
  //
  //       setState(() {
  //         _message = '';
  //       });
  //     } else {
  //       // Show error message in SnackBar
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: ${jsonDecode(response.body)['message']}')),
  //       );
  //
  //       setState(() {
  //         _message = 'Error: ${jsonDecode(response.body)['message']}';
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        'Forgot Your Password?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),),
      body: Stack(  // Use Stack to overlay the loading indicator
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/passwordReset.png', // Ensure the image is added to assets folder
                  width: 200, // Adjust the width as needed
                  height: 200, // Adjust the height as needed
                ),
                SizedBox(height: 30),

                // Email Input Field
                TextFormField(
                  controller: _emailController,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'example@mail.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 20),

                // Disclaimer Text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'By submitting, you will receive a link to reset your password. Please check your email for further instructions.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Button color
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                // Error Message
                if (_message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _message,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          // Overlay loading indicator on top of the screen
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
