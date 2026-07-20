import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class OtpPage extends StatelessWidget {
   OtpPage({super.key});
  final List<TextEditingController> controller =
  List.generate(4, (index) => TextEditingController());

  Widget otpBox(TextEditingController controller) {
    return SizedBox(
      width: 55,
      height: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength:  1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey,width: 2,
            ),

          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
        const SizedBox(height: 40),
        // image
        Image.asset("assets/otp.gif",
          height: 200,
        ),
        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.all(10),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Verify OTP",
              style: TextStyle(
                color: CardGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Enter the 4 digit code sent to your mobile number",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // OTP box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              otpBox(controller[0]),
              otpBox(controller[1]),
              otpBox(controller[2]),
              otpBox(controller[3]),
            ],
          ),
        ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: CardGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                ),
              onPressed: () {
                // Handle login button press
                String otp = controller
                    .map((e) => e.text)
                    .join();
                print("OTP:$otp");
              },
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextButton
              (
              onPressed: () {},
                // Handle resend button press

              child: const Text(
                "Resend OTP?",
                style: TextStyle(
                  color: CardGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
