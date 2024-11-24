import 'package:flutter/material.dart';

class FreelancerProfilePage extends StatelessWidget {
  final String freelancerId;

  const FreelancerProfilePage({Key? key, required this.freelancerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use freelancerId to fetch freelancer details
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelancer Profile'),
      ),
      body: Center(
        child: Text('Displaying profile for Freelancer ID: $freelancerId'),
      ),
    );
  }
}
