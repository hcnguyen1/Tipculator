import 'dart:io';
import 'package:flutter/material.dart';
import 'open_image_fullscreen.dart';

// Display the scan history
class ScanHistory extends StatelessWidget {
  final List<String> scanHistory;
  final void Function(String)? onScanned;

  const ScanHistory(this.scanHistory, {super.key, this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body:
          scanHistory.isEmpty
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
                      onTap: () async {
                        final scannedAmount = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    FullScreenImage(scanHistory[index]),
                          ),
                        );

                        if (scannedAmount != null && onScanned != null) {
                          onScanned!(scannedAmount);
                        }
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
