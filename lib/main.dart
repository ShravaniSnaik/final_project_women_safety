import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/splash.dart';
import 'child/bottom_page.dart';
import 'firebase_options.dart'; // ✅ Import the correct Firebase options file

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, 
    );
    debugPrint(" Firebase Initialized Successfully!");
  } catch (e) {
    debugPrint(" Firebase Initialization Failed: $e");
  }

  runApp(const MyApp()); // ✅ Use MyApp instead of MainApp
}

class MyApp extends StatelessWidget { // ✅ Changed from MainApp to MyApp
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      navigatorKey: navigatorKey,
      home: SplashScreen(),
    );
  }
}