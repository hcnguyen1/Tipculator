import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // To save images locally
import 'package:firebase_core/firebase_core.dart'; // Ensure Firebase is initialized
import 'firebase_options.dart'; // Firebase options for initialization

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
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) return;

    // Save image to local app directory
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = pickedFile.path.split("/").last;
    final localFile = await File(
      pickedFile.path,
    ).copy("${appDir.path}/$fileName");

    if (!mounted) return;

    setState(() {
      cameraImagePath = localFile.path;
      scanHistory.add(localFile.path);
    });

    if (mounted) {
      final scannedAmount = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => ScanScreen(imagePath: localFile.path),
        ),
      );

      if (scannedAmount != null) {
        setState(() {
          selectedAmount = scannedAmount;
          currentIndex = 1;
        });
      }
    }
  }

  Future<void> openGallery(BuildContext context) async {
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

    // Scan Screen once picture is selected
    if (pickedFile != null) {
      if (!mounted) return;
      final scannedAmount = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => ScanScreen(imagePath: pickedFile.path),
        ),
      );
      if (!mounted) return;
      if (scannedAmount != null) {
        setState(() {
          selectedAmount = scannedAmount;
          currentIndex = 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tip Calculator",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // true dark
        primaryColor: const Color(0xFF00BCD4), // example primary color (cyan)
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.cyan,
          thumbColor: Colors.cyanAccent,
          overlayColor: Colors.cyan.withAlpha(32),
        ),
        cardColor: Colors.grey[900],
      ),
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
                title: const Text("Tipculator"),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(
                    1.0,
                  ), // Height of the divider
                  child: Divider(
                    color: Colors.grey, // Divider color
                    thickness: 1.0, // Divider thickness
                    height: 1.0, // Divider height
                  ),
                ),
                actions: [
                  TextButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
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
                        onGalleryPressed: (context) => openGallery(context),
                      );
                    case 1:
                      return TipSummary(
                        key: UniqueKey(),
                        amount: selectedAmount,
                      );
                    case 2:
                      return ScanHistory(
                        scanHistory,
                        onScanned: (scannedAmount) {
                          setState(() {
                            selectedAmount = scannedAmount;
                            currentIndex = 1; // jump to summary
                          });
                        },
                      );
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
