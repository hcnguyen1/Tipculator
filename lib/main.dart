import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // To save images locally
import 'package:firebase_core/firebase_core.dart'; // Ensure Firebase is initialized
import 'firebase_options.dart'; // Firebase options for initialization
import 'package:flutter/services.dart' show rootBundle;

import 'signin.dart';
import 'home_screen.dart';
import 'summary.dart';
import 'scan_history.dart';
import 'scan_screen.dart';

void main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int currentIndex = 0;
  List<String> scanHistory = []; // Store image file paths
  String? cameraImagePath; // Store camera image path
  List<String> scannedElements = []; // Store scanned elements
  String? selectedAmount; // Store selected amount from scan

  Future<void> openCamera(BuildContext context) async {
    // Simulate a "camera capture" using a static image for testing
    final appDir = await getApplicationDocumentsDirectory();
    final byteData = await rootBundle.load('assets/images/tip.jpg');
    final file = File('${appDir.path}/tip.jpg');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    setState(() {
      cameraImagePath = file.path;
      scanHistory.add(file.path);
    });

    // Navigate to the scan screen with the captured image
    if (mounted) {
      final scannedAmount = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => ScanScreen(imagePath: file.path),
        ),
      );

      print('Returned from ScanScreen with amount: $scannedAmount');

      if (scannedAmount != null) {
        setState(() {
          selectedAmount = scannedAmount;
          currentIndex = 1;
        });
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Save image to local app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.path.split("/").last;
      final localFile = await File(
        pickedFile.path,
      ).copy("${appDir.path}/$fileName");

      setState(() {
        scanHistory.add(localFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tip Calculator",
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/signin',
      routes: {
        '/signin':
            (context) => SignIn(
              onSignInSuccess: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
        '/home':
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Tip Calculator"),
                actions: [
                  TextButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                  ),
                ],
              ),
              body: Builder(
                builder: (context) {
                  switch (currentIndex) {
                    case 0:
                      return HomeScreen(
                        onCameraPressed: (context) => openCamera(context),
                        onGalleryPressed: openGallery,
                      );
                    case 1:
                      return TipSummary(
                        key: UniqueKey(),
                        amount: selectedAmount,
                      );
                    case 2:
                      return ScanHistory(scanHistory);
                    default:
                      return const Center(child: Text('Unknown tab'));
                  }
                },
              ),

              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calculate),
                    label: "Summary",
                  ),
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
      },
    );
  }
}
