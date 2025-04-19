import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final void Function(BuildContext) onCameraPressed;
  final void Function(BuildContext) onGalleryPressed;
  final String? cameraImagePath;

  const HomeScreen({
    required this.onCameraPressed,
    required this.onGalleryPressed,
    this.cameraImagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onCameraPressed(context),
            child: Container(
              width: 120, // change to desired diameter
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4FC3F7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, color: Colors.white, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => onGalleryPressed(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB0BEC5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.photo_library, color: Colors.white, size: 20),
              ),
            ),
          ),

          // Show the image if available
          if (cameraImagePath != null) ...[
            const SizedBox(height: 16),
            Image.file(File(cameraImagePath!), width: 200, height: 200),
          ],
        ],
      ),
    );
  }
}
