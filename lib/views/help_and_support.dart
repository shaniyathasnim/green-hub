import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/attachment_card.dart';
import '../widgets/help_success_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentNavIndex = 2;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  // Submit complaint to Firebase
  Future<void> _submitComplaint() async {
    // Remove extra spaces
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String complaint = _complaintController.text.trim();

    // Validation
    if (name.isEmpty || address.isEmpty || complaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create Complaint document in Firestore
      await _firestore.collection('Complaint').add({
        'name': name,
        'address': address,
        'complaint': complaint,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Clear fields
      _nameController.clear();
      _addressController.clear();
      _complaintController.clear();

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HelpSuccessScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit complaint: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: White,

      appBar: AppBar(
        backgroundColor: White,
        elevation: 0,
        centerTitle: false,

        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CardGreen,
                    foregroundColor: White,
                    disabledBackgroundColor: Grey,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: White,
                    ),
                  )
                      : const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Can We Help You Today?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Grey,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Please Select An Issue Type Below.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Grey,
              ),
            ),

            const SizedBox(height: 24),

            CustomTextField(
              label: "Name",
              hint: "Enter your name",
              controller: _nameController,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "Address",
              hint: "Enter your address",
              controller: _addressController,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "Complaint",
              hint: "Please provide details of your issue...",
              maxLines: 5,
              controller: _complaintController,
            ),

            const SizedBox(height: 24),

            AttachmentCard(
              onUploadPressed: () {
                // Image picker can be added here later
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}