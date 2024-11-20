
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;
  final String email;
  final bool isFreelancer;

  HomePage({required this.username, required this.email, required this.isFreelancer});

  @override
  Widget build(BuildContext context) {
    print('User Email: $email');
    print('Is Freelancer: $isFreelancer');
    print('Role value: ${isFreelancer ? 'freelancer' : 'client'}');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Start alignment for better space distribution
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome text
              Text(
                'Welcome, $username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
              ),
              SizedBox(height: 25),

              // Profile creation option for freelancer
              Card(
                color: Colors.white,
                child: Column(
                  children: [
                    // The image inside the card
                    Image.asset('assets/images/freelancer.png', height: 250, width: double.infinity), // Adjust image width to fill
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.deepOrange, // Button color
                        ),
                        onPressed: isFreelancer
                            ? () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => FreelancerProfileCreation()),
                          // );
                        }
                            : null, // Disabled if not a freelancer
                        child: Text(
                          'Profile Creation as Freelancer',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

// Profile creation option for client
              Card(
                color: Colors.white,
                child: Column(
                  children: [
                    // The image inside the card
                    Image.asset('assets/images/client.png', height: 250, width: double.infinity), // Adjust image width to fill
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.deepOrange, // Button color
                        ),
                        onPressed: !isFreelancer
                            ? () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ClientProfileCreation()),
                          // );
                        }
                            : null, // Disabled if a freelancer
                        child: Text(
                          'Profile Creation as Client',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Spacer(), // This takes up remaining space to push the button to the bottom

              // Skip Now Button at the bottom right
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.deepOrange, // Button color
                  ),
                  onPressed: () {
                    // Navigate to the appropriate dashboard based on the user's role
                    if (isFreelancer) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => FreelancerDashboard()), // Navigate to Freelancer Dashboard
                      // );
                    } else {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ClientDashboard()), // Navigate to Client Dashboard
                      // );
                    }
                  },
                  child: Text(
                    'Skip Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
