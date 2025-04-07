import 'dart:io';
import 'package:flutter/material.dart';

// Open the image in full screen
class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(File(imagePath)),
          ),
          Positioned(
            top: 40, // Adjust for notch devices
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context), // Go back
            ),
          ),
        ],
      ),
    );
  }
}