import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // To save images locally
import 'dart:io';

class ScanScreen {
  Future<List<TextElement>> scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    textRecognizer.close();

    List<TextElement> textElements = [];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          textElements.add(element);
        }
      }
    }

    return textElements;
  }
  
  Widget buildScanView(File imageFile, List<TextElement> elements) {
    return Stack(
      children: [
        Image.file(imageFile), // Base image
        ...elements.map((element) {
          final rect = element.boundingBox;
          return Positioned(
            left: rect.left,
            top: rect.top,
            width: rect.width,
            height: rect.height,
            child: GestureDetector(
              onTap: () {
                print("Tapped text: ${element.text}");
                // Set selected value, update UI, etc.
              },
              child: Container(
                color: Colors.transparent,
                child: Text(
                  element.text,
                  style: TextStyle(
                    backgroundColor: Colors.yellow.withOpacity(0.4),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
