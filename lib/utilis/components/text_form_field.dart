import 'package:flutter/material.dart';

class CustomeFormField extends StatelessWidget {
  final String hintText;
  TextEditingController controller = TextEditingController();
  final bool obscureText;
  final String? Function(String?)? validator;

  CustomeFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
