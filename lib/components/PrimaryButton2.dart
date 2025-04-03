import 'package:flutter/material.dart';

class PrimaryButton2 extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton2({super.key, 
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
          backgroundColor: Color(0xFF43061E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFFECE1EE),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
