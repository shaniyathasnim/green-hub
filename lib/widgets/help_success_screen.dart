import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:green_bin/views/home_page.dart';

class HelpSuccessScreen extends StatelessWidget {
  const HelpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Success Image
              Image.asset(
              "assets/complaint_submit.gif",
              width: 300,
              height:300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Complaint Submitted\nSuccessfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CardGreen,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                // height property ensures the line spacing matches the screenshot
                height: 1.3,
              ),
            ),
                const SizedBox(height: 50),

                // Back to Home Button

              ],
          ),
        ),
      ),
    );
  }
}