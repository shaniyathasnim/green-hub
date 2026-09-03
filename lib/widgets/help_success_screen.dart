import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class HelpSuccessScreen extends StatelessWidget {
  const HelpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              // Middle content takes remaining space and centers itself
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success Image
                      Image.asset(
                        "assets/sucess.gif",
                        width: 200,
                        height: 200,
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
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Back to Home Button — pinned near the bottom
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CardGreen,
                    foregroundColor: White,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}