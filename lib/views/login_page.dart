import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';
import 'package:green_bin/views/register_screen.dart';

import 'home_page.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      print("Email: $email");
      print("Password: $password");

      // Firebase login logic will be added here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // Top green design
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
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

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Welcome
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          color: CardGreen,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Login to schedule waste pickups",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Email
                      const Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: "Enter email id",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),

                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: CardGreen,
                            size: 20,
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
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

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }

                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value.trim())) {
                            return "Enter a valid email";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      // Password
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: CardGreen,
                            size: 20,
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
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

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }

                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 35),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CardGreen,
                            foregroundColor: White,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),

                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: CardGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}