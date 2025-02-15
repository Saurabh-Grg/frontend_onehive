import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('About App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAppInfoCard(),
            const SizedBox(height: 20),
            _buildFeatureList(),
            const SizedBox(height: 20),
            _buildDeveloperInfo(),
            const SizedBox(height: 20),
            _buildLicenseInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/OneHive.png',
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            const Text(
              "OneHive",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Version 1.0.0",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              "OneHive is a powerful app designed to streamline team collaboration and project management, ensuring a seamless and efficient workflow.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Key Features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildFeatureItem("🛠 Task Management"),
            _buildFeatureItem("📅 Smart Scheduling"),
            _buildFeatureItem("🔔 Real-time Notifications"),
            _buildFeatureItem("🔒 Secure Data Protection"),
            _buildFeatureItem("🌍 Multi-language Support"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Text(feature, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Developer Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.deepOrange),
              title: Text("Developed by"),
              subtitle: Text("Saurabh Gurung"),
            ),
            const ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text("Contact Email"),
              subtitle: Text("saurabhgurung20@gmail.com"),
            ),
            const ListTile(
              leading: Icon(Icons.language, color: Colors.purple),
              title: Text("Website"),
              subtitle: Text("www.onehiveapp.com"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "License & Terms",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text(
              "By using this app, you agree to our Terms of Service and Privacy Policy.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Get.toNamed('/privacy-policy');
              },
              child: const Text(
                "View Privacy Policy",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
