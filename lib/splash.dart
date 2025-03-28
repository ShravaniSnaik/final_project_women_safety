import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/WelcomePage.dart';
import 'package:flutter_application_2/child/bottom_page.dart';
import 'package:flutter_application_2/db/sp.dart';
import 'package:flutter_application_2/parent/parent_home_screen.dart';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay

    String? userType = await MySharedPreference.getUserType();

    if (!mounted) return;

    Widget nextScreen;

    if (userType == "child") {
      nextScreen = BottomPage();
    } else if (userType == "parent") {
      nextScreen = ParentHomeScreen();
    } else {
      nextScreen = WelcomeScreen();
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor:  Color(0xFFECE1EE),
      splash: Center(
        child: Lottie.asset('assets/animations/splash_animation.json', width: 400,  // Adjust size as needed
      height: 400,
      alignment: Alignment.center,
      fit: BoxFit.cover,),
       
      ),
      nextScreen: Scaffold(body: Container()), // Temporary screen
      duration: 3500,
    );
  }
}