import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top green design
            Expanded(
          flex: 4,
          child: Stack(
            children: [
Container(
              width: double.infinity,
            decoration: const BoxDecoration(
              color: CardGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
          ),
                // curved stripe design
            Positioned(
              top: 50,
              left: -80,
              child: Transform.rotate(
                  angle: -0.35,
              child: Container(
                  width: 500,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),),
            ),
          Positioned(
            top: 180,
            left: -120,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 500,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
//App logo
            const Center(
              child: Text('G',
              style: TextStyle(color: Colors.white,
              fontSize: 110,
              fontWeight: FontWeight.w900,
              height: 1,),
              ),
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
                      const Text('Login to schedule waste pickup',
                      style: TextStyle(
                        color:Colors.black ,
                        fontSize: 15,
                          fontWeight: FontWeight.bold,
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
                       prefixIcon: const Icon(Icons.phone,color: Colors.grey,size: 20,),
                       contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20,
                       ),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                           color: Colors.grey,
                           width: 1,
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: const BorderSide(
                           color: Colors.grey,
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
