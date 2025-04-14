import 'dart:io';
import 'package:flutter/material.dart';
import 'scan_screen.dart';

// Open the image in full screen
class FullScreenImage extends StatefulWidget {
  final String imagePath;
  const FullScreenImage(this.imagePath, {super.key});

  @override
  State<FullScreenImage> createState() => FullScreenImageState();
}

class FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: Image.file(File(widget.imagePath))),
          Positioned(
            top: 40, // Adjust for notch devices
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context), // Go back
            ),
          ),
          // Scan Button
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.document_scanner,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                final scannedAmount = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder:
                        (context) => ScanScreen(imagePath: widget.imagePath),
                  ),
                );

                if (scannedAmount != null) {
                  Navigator.pop(context, scannedAmount);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
