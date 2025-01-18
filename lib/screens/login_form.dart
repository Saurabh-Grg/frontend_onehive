import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/screens/registration_form.dart';
import '../controllers/UserController.dart';
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
  final UserController _userController = Get.put(UserController());
  bool _isPasswordVisible = false; // Track password visibility


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
                          prefixIcon: Icon(Icons.email),
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
                Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  // onPressed: () async {
                  //   if (_formKey.currentState!.validate()) {
                  //     // Call login method
                  //     await _userController.login(
                  //       _emailController.text.trim(),
                  //       _passwordController.text.trim(),
                  //     );
                  //
                  //     // Navigate only if login is successful
                  //     if (_userController.isLoggedIn.value) {
                  //       bool isFreelancer =
                  //           _userController.role.value.toLowerCase() == 'freelancer'; // Check role correctly
                  //
                  //       Get.off(() => HomePage(
                  //         username: _userController.username.value,
                  //         email: _emailController.text, // Fetch from the controller
                  //         isFreelancer: isFreelancer,
                  //       ));
                  //     }
                  //   }
                  // },
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _userController.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    }
                  },
                  child: _userController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )),
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