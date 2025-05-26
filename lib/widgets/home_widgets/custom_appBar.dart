import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils/quotes.dart';

class CustomAppbar extends StatelessWidget {
  //const CustomAppbar({super.key});

  final Function? onTap;
  final int? quoteIndex;
  const CustomAppbar(this.onTap, this.quoteIndex, {super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Text(
          womenEmpowermentQuotes[quoteIndex ?? 0],
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF43061E),
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
