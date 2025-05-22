// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/db/sp.dart';
// import 'package:flutter_application_2/splash.dart';
// import 'package:flutter_application_2/utils/flutter_background_services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'firebase_options.dart'; // ✅ Import the correct Firebase options file

// final navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     debugPrint("Firebase Initialized Successfully!");
//   } catch (e) {
//     debugPrint("Firebase Initialization Failed: $e");
//   }

//   await MySharedPreference.init();
//   await initializeService();
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
//       navigatorKey: navigatorKey,
//       home: SplashScreen(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/db/db_services.dart';
import 'package:flutter_application_2/db/sp.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:flutter_application_2/utils/flutter_background_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';
import 'firebase_options.dart'; // ✅ Ensure this file exists

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase Initialized Successfully!");
  } catch (e) {
    debugPrint("❌ Firebase Initialization Failed: $e");
  }

  await MySharedPreference.init();

  /// 🔹 Step 1: Request permissions BEFORE starting the background service
  await requestPermissions();

  /// 🔹 Step 2: Now start the background service
  await initializeService();

  runApp(const MyApp());
}

/// 🔹 Request all necessary permissions before starting the app
Future<void> requestPermissions() async {
  var statuses = await [
    Permission.locationAlways,
    Permission.sms,
    Permission.contacts,
    Permission.notification,
  ].request();

  // 🔹 Check if permissions are denied
  if (statuses[Permission.locationAlways]!.isDenied ||
      statuses[Permission.sms]!.isDenied) {
    debugPrint("⚠️ Permissions Denied! Some features may not work.");
  }
}

class MyApp extends StatelessWidget {
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
