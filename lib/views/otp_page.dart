// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:green_bin/utils/app_colors.dart';
// import 'package:green_bin/views/home_page.dart';
// import 'package:green_bin/views/edit_profile_screen.dart';
// import 'package:green_bin/providers/customer_provider.dart';
//
// class OtpPage extends StatefulWidget {
//   final String phone;
//   const OtpPage({super.key, required this.phone,});
//
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State<OtpPage> {
//   final List<TextEditingController> controllers =
//   List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> focusNodes =
//   List.generate(4, (_) => FocusNode());
//
//   @override
//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     for (var node in focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }
//
//   Widget otpBox(int index) {
//     return SizedBox(
//       width: 55,
//       height: 60,
//       child: TextField(
//         controller: controllers[index],
//         focusNode: focusNodes[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         style: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//         ),
//         decoration: InputDecoration(
//           counterText: "",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: CardGreen),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(
//               color: CardGreen,
//               width: 2,
//             ),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             if (index < focusNodes.length - 1) {
//               FocusScope.of(context).requestFocus(focusNodes[index + 1]);
//             } else {
//               FocusScope.of(context).unfocus();
//             }
//           } else {
//             if (index > 0) {
//               FocusScope.of(context).requestFocus(focusNodes[index - 1]);
//             }
//           }
//         },
//       ),
//     );
//   }
//
//   void _verifyOtp() async {
//     String otp = controllers.map((e) => e.text).join();
//     if (otp.length < 4) return;
//
//     final provider = Provider.of<CustomerProvider>(context, listen: false);
//
//     try {
//       await provider.verifyOtp(otp);
//
//       if (!mounted) return;
//
//       if (provider.isNewUser) {
//         // Navigate to Profile Registration if new user
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const EditProfileScreen()),
//           (route) => false,
//         );
//       } else {
//         // Go to Home if existing user
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (_) => const HomePage()),
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP: $e")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isLoading = context.watch<CustomerProvider>().isLoading;
//
//     return Scaffold(
//       backgroundColor: White,
//       resizeToAvoidBottomInset: true,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 24,
//               vertical: 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Image.asset(
//                     "assets/otp.gif",
//                     height: 220,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 const Text(
//                   "Verify OTP",
//                   style: TextStyle(
//                     color: CardGreen,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Enter the 4 digit code sent to ${widget.phone}",
//                   style: const TextStyle(
//                     color: Black,
//                     fontSize: 15,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 35),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     otpBox(0),
//                     otpBox(1),
//                     otpBox(2),
//                     otpBox(3),
//                   ],
//                 ),
//                 const SizedBox(height: 40),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 54,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : _verifyOtp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: CardGreen,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                     ),
//                     child: isLoading
//                       ? const CircularProgressIndicator(color: White)
//                       : const Text(
//                           "Verify",
//                           style: TextStyle(
//                             color: White,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: TextButton(
//                     onPressed: () {
//                       // Logic to resend OTP
//                     },
//                     child: const Text(
//                       "Resend OTP?",
//                       style: TextStyle(
//                         color: CardGreen,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
