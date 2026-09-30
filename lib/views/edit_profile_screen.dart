import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/views/profile_page.dart';

import '../models/customer_model.dart';
import '../utils/app_colors.dart';
import '../utils/shared_prefs.dart';
import 'image_edit_sceen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _contactController =
  TextEditingController();

  final TextEditingController _addressController =
  TextEditingController();

  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // --------------------------------------------------
  // LOAD PROFILE
  // --------------------------------------------------

  Future<void> _loadProfile() async {
    try {
      final CustomerModel? customer =
      await SharedPrefs.getUser();

      if (customer == null || customer.uid == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> document =
      await _firestore
          .collection('customers')
          .doc(customer.uid)
          .get();

      if (document.exists) {
        final data = document.data();

        _nameController.text =
            data?['name']?.toString() ?? '';

        _contactController.text =
            data?['phoneNumber']?.toString() ?? '';

        _addressController.text =
            data?['address']?.toString() ?? '';
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --------------------------------------------------
  // UPDATE PROFILE
  // --------------------------------------------------


  Future<void> _updateProfile() async {
    final String name = _nameController.text.trim();
    final String phone = _contactController.text.trim();
    final String address = _addressController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final CustomerModel? customer =
    await SharedPrefs.getUser();

    if (customer == null || customer.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer information not found'),
        ),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      await _firestore
          .collection('customers')
          .doc(customer.uid)
          .update({
        'name': name,
        'phoneNumber': phone,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update SharedPreferences too
      final CustomerModel updatedCustomer =
      customer.copyWith(
        name: name,
        phoneNumber: phone,
        address: address,
      );

      await SharedPrefs.setUser(updatedCustomer);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,
      body: SafeArea(
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: CardGreen,
          ),
        )
            : Column(
          children: [
            _buildAppBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: _buildAvatar(),
                    ),

                    const SizedBox(height: 28),

                    _buildLabel('Name'),

                    const SizedBox(height: 8),

                    _buildField(
                      controller: _nameController,
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('Contact Number'),

                    const SizedBox(height: 8),

                    _buildField(
                      controller: _contactController,
                      icon: Icons.call_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel('Home Address'),

                    const SizedBox(height: 8),

                    _buildField(
                      controller: _addressController,
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ),

            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // APP BAR
  // --------------------------------------------------

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        20,
        8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Black,
              size: 22,
            ),
          ),

          const SizedBox(width: 4),

          const Text(
            'Edit Profile',
            style: TextStyle(
              color: Black,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // AVATAR
  // --------------------------------------------------

  Widget _buildAvatar() {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: 46,
            backgroundColor: White,
            backgroundImage: AssetImage(
              'assets/profile_image.png',
            ),
          ),

          Positioned(
            right: 0,
            bottom: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) {
                    return ImagePickerBottomSheet(
                      onGalleryTap: () {
                        Navigator.pop(context);
                        // Gallery action
                      },
                      onCameraTap: () {
                        Navigator.pop(context);
                        // Camera action
                      },
                      onRemoveTap: () {
                        Navigator.pop(context);
                        // Remove image action
                      },
                    );
                  },
                );
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CardGreen,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
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
  // LABEL
  // --------------------------------------------------

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Black,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // --------------------------------------------------
  // FIELD
  // --------------------------------------------------

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: LightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: DarkGrey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),

          Icon(
            icon,
            size: 19,
            color: CardGreen,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Grey,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // UPDATE BUTTON
  // --------------------------------------------------

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _isUpdating ? null : _updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: CardGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Grey,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isUpdating
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Update',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}