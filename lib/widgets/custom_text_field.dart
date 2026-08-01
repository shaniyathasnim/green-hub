import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final Widget? prefixIcon;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Black,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor:LightGrey,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color:CardGreen,
                width: 2,
              ),
    ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            ),
          ),

      ],
    );
  }
}