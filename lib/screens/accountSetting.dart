import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AccountSettingController.dart';
class AccountSetting extends StatelessWidget {
  AccountSetting({super.key});  // Remove 'const' because controller needs to be initialized

  final AccountSettingController controller = Get.put(AccountSettingController()); // Add this

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildSettingsCard(
              title: "Change Password",
              subtitle: "Keep your account secure",
              icon: Icons.lock_outline,
              onTap: () {
                Get.toNamed('/change-password');
              },
            ),
            _buildSettingsCard(
              title: "Notification Settings",
              subtitle: "Manage app notifications",
              icon: Icons.notifications_active_outlined,
              onTap: () {
                Get.toNamed('/notifications');
              },
            ),
            _buildSettingsCard(
              title: "Language Selection",
              subtitle: "Choose your preferred language",
              icon: Icons.language,
              onTap: () {
                Get.toNamed('/language-settings');
              },
            ),
            _buildSettingsCard(
              title: "Privacy Settings",
              subtitle: "Manage data and permissions",
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                Get.toNamed('/privacy-settings');
              },
            ),
            _buildSettingsCard(
              title: "Biometric Authentication",
              subtitle: "Use Face ID or Fingerprint",
              icon: Icons.fingerprint,
              trailing: Obx(() => Switch(
                value: controller.isBiometricEnabled.value,
                onChanged: (value) => controller.toggleBiometric(),
              )),
            ),
            _buildSettingsCard(
              title: "Help & Support",
              subtitle: "Get assistance or FAQs",
              icon: Icons.help_outline,
              onTap: () {
                Get.toNamed('/help-support');
              },
            ),
            _buildSettingsCard(
              title: "About App",
              subtitle: "Learn more about this app",
              icon: Icons.info_outline,
              onTap: () {
                Get.toNamed('/about-app');
              },
            ),
            const SizedBox(height: 20),
            _buildDeleteAccountButton(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required String subtitle, required IconData icon, VoidCallback? onTap, Widget? trailing}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }


  // Profile Section
  Widget _buildProfileSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://placekitten.com/200/200'),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('john.doe@email.com', style: TextStyle(fontSize: 14, color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/edit-profile');
                  },
                  child: const Text("Edit Profile", style: TextStyle(color: Colors.deepOrange)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Delete Account Button
  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Get.defaultDialog(
            title: "Delete Account",
            middleText: "Are you sure you want to delete your account? This action cannot be undone.",
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
        label: const Text("Delete Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // Logout Button with Confirmation Dialog
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        label: const Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
