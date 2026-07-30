import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AttachmentCard extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const AttachmentCard({
    super.key,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Grey, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.link, // Attachment icon
            color: Black,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Attach Photo (Optional)",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color:Black,
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              onPressed: onUploadPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: CardGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                "Upload",
                style: TextStyle(
                  color: CardGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
