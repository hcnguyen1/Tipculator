import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onCameraPressed;

  const HomeScreen({super.key, required this.onCameraPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page"),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: onCameraPressed,
              child: const Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
    );
  }
}
