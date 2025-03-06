import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const HomeScreen({
    required this.onCameraPressed,
    required this.onGalleryPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Open Camera"),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: onCameraPressed,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),
          const Text("Open Gallery"),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: onGalleryPressed,
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
