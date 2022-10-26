import 'package:creative_minds/config/insets.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final String? Function(String? text)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Insets.xs),
        ),
        hintText: hintText,
      ),
      obscureText: obscureText,
      autocorrect: false,
    );
  }
}
