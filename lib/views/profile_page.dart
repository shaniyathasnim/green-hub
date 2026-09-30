import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

import '../models/customer_model.dart';
import '../utils/shared_prefs.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color kPrimaryGreen = Color(0xFF1B7A4D);
  static const Color kDarkText = Color(0xFF1E2A26);
  static const Color kSubText = Color(0xFF7A8A85);
  static const Color kCardBorder = Color(0xFFE3E8E6);
  static const Color kIconBg = Color(0xFFE1F0E7);

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userData;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // --------------------------------------------------
  // LOAD PROFILE FROM FIREBASE
  // --------------------------------------------------

  Future<void> _loadProfile() async {
    try {
      // final User? currentUser = _auth.currentUser;
      final CustomerModel? customer =
      await SharedPrefs.getUser();

      if (customer == null || customer.uid == null) {
        return;
      }
      // if (currentUser == null) {
      //   if (mounted) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      //   return;
      // }

      final DocumentSnapshot<Map<String, dynamic>> document =
      await _firestore
          .collection('customers')
          .doc(customer.uid)
          .get();

      if (document.exists) {
        setState(() {
          _userData = document.data();
          _isLoading = false;
        });
      } else {
        setState(() {
          _userData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Profile loading error: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
          ),
        );
      }
    }
  }

  // --------------------------------------------------
  // GET VALUES
  // --------------------------------------------------

  String get _name {
    return _userData?['name']?.toString() ?? 'User';
  }

  String get _phone {
    return _userData?['phoneNumber']?.toString() ??
        'Not available';
  }

  String get _address {
    return _userData?['address']?.toString() ??
        'Not available';
  }

  String get _joinedDate {
    final dynamic value = _userData?['joinedDate'];

    if (value == null) {
      return 'Not available';
    }

    if (value is Timestamp) {
      final DateTime date = value.toDate();

      return '${_monthName(date.month)} ${date.year}';
    }

    return value.toString();
  }

  String _monthName(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: CardGreen,
          ),
        )
            : RefreshIndicator(
          color: CardGreen,
          onRefresh: _loadProfile,
          child: SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                _buildPersonalDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 28,
      ),
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

          Text(
            _name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Joined : $_joinedDate',
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

  // --------------------------------------------------
  // AVATAR
  // --------------------------------------------------

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
              backgroundImage: AssetImage(
                'assets/profile_image.png',
              ),
            ),
          ),

          Positioned(
            right: 2,
            bottom: 2,
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const EditProfileScreen(),
                  ),
                );

                // IMPORTANT:
                // Reload Firebase data after returning
                // from Edit Profile.
                await _loadProfile();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  kPrimaryGreen.withOpacity(0.9),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
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

  // --------------------------------------------------
  // PERSONAL DETAILS
  // --------------------------------------------------

  Widget _buildPersonalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        20,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
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
            value: _name,
          ),

          const SizedBox(height: 14),

          _InfoCard(
            icon: Icons.call_outlined,
            label: 'Mobile Number',
            value: _phone,
          ),

          const SizedBox(height: 14),

          _InfoCard(
            icon: Icons.password,
            label: 'Password',
            value: '********',

          ),

          const SizedBox(height: 14),

          _InfoCard(
            icon: Icons.home_outlined,
            label: 'Home Address',
            value: _address,
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// INFO CARD
// --------------------------------------------------

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
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _ProfileScreenState.kCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _ProfileScreenState.kIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: _ProfileScreenState.kPrimaryGreen,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color:
                    _ProfileScreenState.kSubText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    color:
                    _ProfileScreenState.kDarkText,
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