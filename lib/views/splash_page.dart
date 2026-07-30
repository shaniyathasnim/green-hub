import 'dart:async';

import 'package:flutter/material.dart';
import 'package:green_bin/views/home_page.dart';
import 'package:green_bin/views/login_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),

    );
    _animation = Tween<double>
      (begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();


    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>login_page(),
        ),
      );
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF017240),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // G logo
          Image.asset("assets/G.png",
        height: 150,
        width: 150,),
        const SizedBox(height: 20),
      ],
        ),
      ),
      )

    );

    }
  }

