import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../utils/app_colors.dart';
import 'home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<CustomerProvider>(context, listen: false);

    try {
      await provider.registerWithEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      log('jjjjjjjjjjjjjjjj');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Welcome to Green Bin!'), backgroundColor: Colors.green),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', '')), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<CustomerProvider>().isLoading;

    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Center(child: Text('Create Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: CardGreen))),
                const SizedBox(height: 10),
                const Center(child: Text('Register as a Green Bin customer', style: TextStyle(fontSize: 15, color: Grey))),
                const SizedBox(height: 45),
                _buildLabel('Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  enabled: !isLoading,
                  decoration: _inputDecoration('Enter your name', Icons.person_outline),
                  validator: (v) => (v == null || v.length < 3) ? 'Enter a valid name' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Enter your email', Icons.email_outlined),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  enabled: !isLoading,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration('Enter your password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(onPressed: () => setState(() => _obscurePassword = !_obscurePassword), icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility)),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters required' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Confirm Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  enabled: !isLoading,
                  obscureText: _obscureConfirmPassword,
                  decoration: _inputDecoration('Confirm your password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword), icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility)),
                  ),
                  validator: (v) => (v != _passwordController.text) ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(backgroundColor: CardGreen, foregroundColor: White, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: isLoading ? const CircularProgressIndicator(color: White) : const Text('Register', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600));

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: CardGreen),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Grey)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: CardGreen, width: 2)),
    );
  }
}