import 'package:flutter/material.dart';

class PrimaryButton1 extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton1({super.key, 
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF9F80A7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Color(0xFF43061E),fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
