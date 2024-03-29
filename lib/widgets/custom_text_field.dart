import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String type;
  final String? Function(String?) validator;
  final TextEditingController? controller;

  const CustomTextFormField(
      {super.key,
      required this.type,
      required this.validator,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: type == "Password" ? true : false,
        decoration: InputDecoration(
          hintText: "Enter $type",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
