import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final void Function(BuildContext) onCameraPressed;
  final void Function (BuildContext) onGalleryPressed;
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
          const Text("Open Camera"),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => onCameraPressed(context),
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),
          const Text("Open Gallery"),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => onGalleryPressed(context),
            child: const Icon(Icons.photo_library),
          ),
          // Show the image if available
          if(cameraImagePath != null) ...[
            const SizedBox(height: 16),
            Image.file(
              File(cameraImagePath!),
              width: 200,
              height: 200,
            ),
          ],
        ],
      ),
    );
  }
}
