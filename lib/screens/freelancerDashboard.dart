import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreelancerDashboardScreen extends StatefulWidget {
  const FreelancerDashboardScreen({super.key});

  @override
  State<FreelancerDashboardScreen> createState() => _FreelancerDashboardScreenState();
}

class _FreelancerDashboardScreenState extends State<FreelancerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi! username')
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('light theme'),
              onTap: (){
                Get.changeTheme(ThemeData.light());
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark theme'),
              onTap: (){
                Get.changeTheme(ThemeData.dark());
              },
            ),
          ],
        ),
      ),
    );
  }
}
