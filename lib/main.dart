import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Import the screens
import 'home_screen.dart';
import 'tip_calculator.dart';
import 'scan_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  // Function to open camera
  Future<void> openCamera() async {
    final picker = ImagePicker();
    // Open the camera
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;
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
            HomeScreen(
              onCameraPressed: openCamera,
            ), // Pass the openCamera function here
            TipCalculator(),
            ScanHistory(
              [],
            ), // Pass an empty list or implement the feature if needed
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Tip"),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),
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
