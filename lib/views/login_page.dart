import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/otp_page.dart';
class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor:White,
      body: SafeArea(
        child: Column(
          children: [
            // Top green design
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Positioned.fill(
                    child: Image.asset(
                      "assets/login_curve.png",
                      fit: BoxFit.fill,
                    ),
                  ),

                  Image.asset(
                    "assets/G.png",
                    width: 110,
                    height: 110,
                  ),

                ],
              ),
            ),
            //Login
            Expanded(
              flex: 6,
              child: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 28,vertical: 26,
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text("Welcome",
                    style: TextStyle(
                      color: CardGreen,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),

                    ),
                    const SizedBox(height: 8,),
                      const Text('Login to schedule waste pickups',
                      style: TextStyle(
                        color:Colors.black ,
                        fontSize: 15,
                          fontWeight: FontWeight.w400,
                        height: 1.4,

                      ),
                      ),
                    const SizedBox(height: 30,),
                    const Text("phone number",
                      style: TextStyle(
                        color:Colors.black ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        height: 1.4,

                      ),
                    ),
                    const SizedBox(height: 10,),
                   TextField(
                     decoration: InputDecoration(
                       hintText: 'Enter phone number',
                       hintStyle: const TextStyle(
                         color: Colors.grey,
                         fontSize: 14,
                   ),
                       prefixIcon: const Icon(Icons.phone,color:CardGreen,size: 20,),
                       contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20,
                       ),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(16),
                         borderSide: const BorderSide(
                           color: Green,
                           width: 1,
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(16),
                         borderSide: const BorderSide(
                           color: Green,
                           width: 1,
                         ),
                       ),
                     ),
                   ),
                    const SizedBox(height: 30,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) =>OtpPage(),
                         ),);
                          // Handle login button press
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CardGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Send OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            )
            ],
          ),
      ),
    );
  }
}
