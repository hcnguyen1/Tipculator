import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // To save images locally

import 'home_screen.dart';
import 'tip_calculator.dart';
import 'scan_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  List<String> scanHistory = []; // Store image file paths

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Get app's directory to save the image
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final File savedImage = File("${appDir.path}/$fileName");

      // Copy the captured image to the app directory
      await File(pickedFile.path).copy(savedImage.path);

      setState(() {
        scanHistory.add(savedImage.path); // Save image path to history
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tip Calculator",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text("Tip Calculator")),
        body: IndexedStack(
          index: currentIndex,
          children: [
            HomeScreen(onCameraPressed: openCamera), // Camera button
            TipCalculator(),
            ScanHistory(scanHistory), // Pass image history
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Tip"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "Gallery"),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
