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
  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  int _currentNavIndex = 2; // "Help" is selected

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _complaintController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSuccessScreen(),
                      ),
                    );
                    // Handle Submit logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CardGreen,
                    foregroundColor: White,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),

                  ),
                  ),
  child: const Text(
  'Submit',
  style: TextStyle(fontWeight: FontWeight.bold),

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
                fontWeight:FontWeight.w200,
                color: Grey,
              ),
            ),
            const SizedBox(height: 24),

            // Reusing existing CustomTextField
            CustomTextField(
              label: "Name",
              hint: "Arun",
              controller: _nameController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Address",
              hint: "Perinthalmanna",
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

            // Custom Attachment Widget
            AttachmentCard(
              onUploadPressed: () {
                // Handle Image Picker logic
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