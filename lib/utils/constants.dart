import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const Color primaryColor = Color(0xfffc3b77);
const kColorDarkRed = Colors.redAccent;

void goTo(BuildContext context, Widget nextScreen, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}

dialogueBox(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(title: Text(text)),
  );
}

Widget progressIndicator(BuildContext context) {
  return Center(
    child: Lottie.asset(
      'assets/animations/loading.json',  // Ensure the JSON file is added to assets
      width: 150,  // Adjust size as needed
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}
