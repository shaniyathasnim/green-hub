import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

import 'edit_profile_screen.dart';

/// ProfileScreen
/// Pixel-perfect recreation of the "My Profile" screen.
/// Bottom navigation bar is intentionally excluded (already implemented elsewhere).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color kPrimaryGreen = Color(0xFF1B7A4D);
  static const Color kDarkText = Color(0xFF1E2A26);
  static const Color kSubText = Color(0xFF7A8A85);
  static const Color kCardBorder = Color(0xFFE3E8E6);
  static const Color kIconBg = Color(0xFFE1F0E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              _buildPersonalDetails(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 28),
      decoration: const BoxDecoration(
        color: CardGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          _buildAvatar(context),
          const SizedBox(height: 14),
          const Text(
            'Arun',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Joined : Jan 2023',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 108,
            height: 108,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: const CircleAvatar(
              radius: 51,
              backgroundColor: Colors.white,
              // Replace with NetworkImage/AssetImage of the user's photo
              backgroundImage: (AssetImage('assets/profile_image.png')
                
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryGreen.withOpacity(0.9),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 14,

              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  // ---------------- PERSONAL DETAILS ----------------
  Widget _buildPersonalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(
              color: kDarkText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: 'Arun',
          ),
          const SizedBox(height: 14),
          _InfoCard(
            icon: Icons.call_outlined,
            label: 'Mobile Number',
            value: '+91 000 000 000 0',
          ),
          const SizedBox(height: 14),
          _InfoCard(
            icon: Icons.password,
            label: 'Password',
            value: '******',
          ),
          const SizedBox(height: 14),
          _InfoCard(
            icon: Icons.calendar_today_outlined,
            label: 'Home Address',
            value: '20th Mile, Perinthalmanna',
          ),
        ],
      ),
    );
  }
}

/// Reusable card used for each personal detail row.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProfileScreen.kCardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ProfileScreen.kIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: ProfileScreen.kPrimaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: ProfileScreen.kSubText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: ProfileScreen.kDarkText,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
