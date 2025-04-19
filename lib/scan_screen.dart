import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanScreen extends StatefulWidget {
  final String imagePath;

  const ScanScreen({super.key, required this.imagePath});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<TextElement> textElements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scanText(File(widget.imagePath));
  }

  Future<void> scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    textRecognizer.close();

    final List<TextElement> elements = [];
    final regex = RegExp(r'(\d+(\.\d{1,2})?)');

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          // print("Detected: ${element.text}"); // debug
          if (regex.hasMatch(element.text)) {
            // print("Matched: ${element.text}"); // debug
            elements.add(element);
          }
        }
      }
    }

    setState(() {
      textElements = elements;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = File(widget.imagePath);

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Result")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                builder: (context, constraints) {
                  final imageWidget = Image.file(imageFile);
                  return FutureBuilder<Size>(
                    future: _getImageSize(imageFile),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return imageWidget;

                      final imageSize = snapshot.data!;
                      final scaleX = constraints.maxWidth / imageSize.width;
                      final scaleY = constraints.maxHeight / imageSize.height;

                      return Stack(
                        children: [
                          Positioned.fill(child: imageWidget),
                          ...textElements.map((element) {
                            final rect = element.boundingBox;
                            return Positioned(
                              left: rect.left * scaleX,
                              top: rect.top * scaleY,
                              width: rect.width * scaleX,
                              height: rect.height * scaleY,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, element.text);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ), // Light gray border
                                    color: Colors.grey.shade200.withAlpha(
                                      153,
                                    ), // Light background
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    element.text,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
              ),
    );
  }

  // This helps calculate original image dimensions
  Future<Size> _getImageSize(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }
}
