import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final bool isObsecureText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final readOnly;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObsecureText = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObsecureText,
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value?.trim() == null || value!.trim().isEmpty) {
          return "${hintText} is required";
        }
        return null;
      },
    );
  }
}
