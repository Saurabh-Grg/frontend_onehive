import 'package:flutter/material.dart';

class FreelancerProfileUpdate extends StatefulWidget {
  final String profileID; // Required parameter for profile ID

  const FreelancerProfileUpdate({super.key, required this.profileID});

  @override
  State<FreelancerProfileUpdate> createState() => _FreelancerProfileUpdateState();
}

class _FreelancerProfileUpdateState extends State<FreelancerProfileUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Update your profile here")),
    );
  }
}
