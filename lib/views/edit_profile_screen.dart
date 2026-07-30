import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'image_edit_sceen.dart';

/// EditProfileScreen
/// Pixel-perfect recreation of the "Edit Profile" screen.
/// Bottom navigation bar is intentionally excluded (already implemented elsewhere).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  // static const Color kPrimaryGreen = Color(0xFF1B7A4D);
  // static const Color kDarkText = Color(0xFF1E2A26);
  // static const Color kSubText = Color(0xFF6B7975);
  // static const Color kFieldBg = Color(0xFFF3F6F5);
  // static const Color kFieldBorder = Color(0xFFE3E8E6);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
  TextEditingController(text: 'Arun');
  final TextEditingController _contactController =
  TextEditingController(text: '+91 000 000 000 0');
  final TextEditingController _addressController =
  TextEditingController(text: '20th Mile, Perinthalmanna');

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
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _buildAvatar()),
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

  // ---------------- APP BAR ----------------
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back,
              color: White,
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

  // ---------------- AVATAR ----------------
  Widget _buildAvatar() {
    return SizedBox(
      width: 92,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: 46,
            backgroundColor: Color(0xFFEFEFEF),
            // Replace with NetworkImage/AssetImage of the user's photo
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

  // ---------------- LABEL ----------------
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

  // ---------------- FIELD ----------------
  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: White, width: 1),
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
                color: Black,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }

  // ---------------- UPDATE BUTTON ----------------
  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            // TODO: handle update action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CardGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
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