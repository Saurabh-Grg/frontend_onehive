import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Colors.white), // Close icon color
      // ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true, // Allow panning
                minScale: 1.0,
                maxScale: 4.0, // Allow zooming
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain, // Contain the image within the screen
                ),
              ),
              Positioned(
                top: 16, // Position the icon from the top
                right: 16, // Position the icon from the right
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30), // Cross icon
                  onPressed: () {
                    // Action to close the viewer
                    Get.back(); // Example action to close the screen
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
