

import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class CustomDialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
final bool isPrimary;

  const CustomDialogButton({
    super.key,
  required this.text,
  required this.onPressed,
  this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: isPrimary
      ? ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
          backgroundColor: CardGreen,
          foregroundColor: White,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
      : OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Grey, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
    color: Grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
    ),
          ),
        ),

    );
  }
}
