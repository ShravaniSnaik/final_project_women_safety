import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final Function(String?)? onsave;
  final int? maxLines;
  final bool isPassword;
  final bool enable;
  final bool? check;
  final TextInputType? keyboardtype;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  const CustomTextField({
    super.key,
    this.controller,
    this.check,
    this.enable = true,
    this.focusNode,
    this.hintText,
    this.isPassword = false,
    this.keyboardtype,
    this.maxLines,
    this.onsave,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.validate,
    this.hintStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style ?? TextStyle(color: Colors.black),
      enabled: enable == true ? true : enable,
      maxLines: maxLines ?? 1,
      onSaved: onsave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardtype ?? TextInputType.name,
      controller: controller,
      validator: validate,
      obscureText: isPassword == false ? false : isPassword,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        labelText: hintText ?? "hint text..",
        labelStyle: hintStyle, // Apply custom hint text style
        hintText: hintText, // Ensure hint text is set
        hintStyle:
            hintStyle ??
            TextStyle(color: Color(0xFFE0435E)), // Set hint text color
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Color(0xFFE0435E),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(style: BorderStyle.solid, color: Colors.red),
        ),
      ),
    );
  }
}
