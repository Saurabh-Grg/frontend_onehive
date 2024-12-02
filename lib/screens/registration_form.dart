import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login_form.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _userRole = 'Client';
  String? _selectedCity;
  bool _termsAccepted = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final List<String> _cities = [
    // Province No. 1
    'Biratnagar', 'Dharan', 'Itahari', 'Damak', 'Birtamod', 'Mechinagar', 'Ilam', 'Dhankuta',
    // Madhesh Province
    'Janakpur', 'Birgunj', 'Rajbiraj', 'Gaur', 'Kalaiya', 'Malangwa', 'Siraha',
    // Bagmati Province
    'Kathmandu', 'Lalitpur', 'Bhaktapur', 'Hetauda', 'Bidur', 'Banepa', 'Dhulikhel',
    // Gandaki Province
    'Pokhara', 'Baglung', 'Beni', 'Tansen', 'Waling', 'Putalibazar', 'Gorkha',
    // Lumbini Province
    'Lumbini', 'Butwal', 'Bhairahawa', 'Dang', 'Tulsipur', 'Kapilvastu', 'Nepalgunj',
    // Karnali Province
    'Birendranagar', 'Jumla', 'Dailekh', 'Manma', 'Rukumkot', 'Chaurjahari',
    // Sudurpashchim Province
    'Dhangadhi', 'Amargadhi', 'Tikapur', 'Dadeldhura', 'Baitadi', 'Dipayal', 'Mahendranagar',
    // Miscellaneous
    'Chitwan' // Can also be split into Bharatpur and surrounding areas
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_termsAccepted) {
        final registrationData = {
          'username': _fullNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': _userRole,
          'city': _selectedCity,
        };

        final response = await http.post(
          Uri.parse('http://localhost:3000/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(registrationData),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful')));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginForm()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Failed: ${response.body}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please accept the terms and conditions')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height to apply responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.08, left: screenWidth * 0.04, right: screenWidth * 0.04), // Use percentage of screen size for padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/OneHive.png',
                          height: screenWidth * 0.25, // Adjust image size based on screen width
                          width: screenWidth * 0.25,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'ONEHIVE',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          Text('काम र क्षमताको संगम।')
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Welcome!',
                    style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your user name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Email Address
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_confirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible = !_confirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // User Role (Client or Freelancer)
                        DropdownButtonFormField<String>(
                          value: _userRole,
                          decoration: InputDecoration(
                            labelText: 'User Role',
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: ['Client', 'Freelancer'].map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _userRole = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        // City/Province Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCity,
                          decoration: InputDecoration(
                            labelText: 'City/Province',
                            prefixIcon: Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _cities.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCity = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a city or province';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        // Terms and Conditions Checkbox
                        CheckboxListTile(
                          title: Text("I accept the Terms and Conditions"),
                          value: _termsAccepted,
                          onChanged: (newValue) {
                            setState(() {
                              _termsAccepted = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 15),

                        // Register Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.deepOrange,
                          ),
                          onPressed: _submitForm,
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Navigate to Login
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm()));
                          },
                          child: Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
