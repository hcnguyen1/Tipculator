import 'dart:io';
import 'package:flutter/material.dart';

// Display the scan history
class ScanHistory extends StatelessWidget {
  final List<String> scanHistory;
  const ScanHistory(this.scanHistory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body: scanHistory.isEmpty
          ? const Center(child: Text("No scans yet"))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: scanHistory.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Open full-screen image viewer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(scanHistory[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(scanHistory[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

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
