import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AccountSettingController.dart';
import '../controllers/UserController.dart';

class AccountSetting extends StatelessWidget {
  AccountSetting({super.key});

  final AccountSettingController controller =
      Get.put(AccountSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildSettingsOption("Change Password", "Keep your account secure",
                Icons.lock_outline, () {
              Get.toNamed('/change-password');
            }),
            _buildSettingsOption(
                "Notification Settings",
                "Manage app notifications",
                Icons.notifications_active_outlined, () {
              Get.toNamed('/notifications');
            }),
            _buildSettingsOption("Language Selection",
                "Choose your preferred language", Icons.language, () {
              Get.toNamed('/language-settings');
            }),
            _buildSettingsOption("Privacy Settings",
                "Manage data and permissions", Icons.privacy_tip_outlined, () {
              Get.toNamed('/privacy-settings');
            }),
            ListTile(
              leading: const Icon(Icons.fingerprint, color: Colors.deepOrange),
              title: const Text("Biometric Authentication",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: const Text("Use Face ID or Fingerprint",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              trailing: Obx(() => Switch(
                value: controller.isBiometricEnabled.value,
                onChanged: (value) => controller.toggleBiometric(),
              )),
            ),
            // const Divider(),
            _buildSettingsOption(
                "Help & Support", "Get assistance or FAQs", Icons.help_outline,
                () {
              Get.toNamed('/help-support');
            }),
            _buildSettingsOption(
                "About App", "Learn more about this app", Icons.info_outline,
                () {
              Get.toNamed('/about-app');
            }),
            const SizedBox(height: 20),
            _buildDeleteAccountButton(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.deepOrange),
          title: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    final UserController userController = Get.find();

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage('https://placekitten.com/200/200'),
              ),
              const SizedBox(width: 15), // Spacing between avatar and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text('${userController.username.value}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Obx(
                      () => Text('${userController.email.value}',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/edit-profile');
                },
                child: const Icon(Icons.edit, color: Colors.deepOrange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Get.defaultDialog(
            title: "Delete Account",
            middleText:
                "Are you sure you want to delete your account? This action cannot be undone.",
            confirm: ElevatedButton(
              onPressed: () {
                controller.deleteAccount();
              },
              child: const Text("Yes, Delete"),
            ),
            cancel: TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          );
        },
        icon: const Icon(Icons.delete_outline, color: Colors.white),
        label: const Text("Delete Account",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Get.defaultDialog(
            title: "Logout",
            middleText: "Are you sure you want to logout?",
            confirm: ElevatedButton(
              onPressed: () {
                controller.logout();
              },
              child: const Text("Logout"),
            ),
            cancel: TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text("Logout",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
