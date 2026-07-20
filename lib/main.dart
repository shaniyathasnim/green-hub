import 'package:flutter/material.dart';
import 'package:green_bin/views/home_page.dart';
import 'package:green_bin/views/login_page.dart';
import 'package:green_bin/views/otp_page.dart';
import 'package:green_bin/views/scrap_item_page.dart';
import 'package:green_bin/views/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:ScrapItemPage()
    );
  }
}

