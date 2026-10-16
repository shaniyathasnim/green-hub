import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AttachmentCard extends StatelessWidget {
  final VoidCallback onUploadPressed;
  final Uint8List? selectedImageBytes;

  const AttachmentCard({
    super.key,
     required this.onUploadPressed,
    this.selectedImageBytes,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = selectedImageBytes != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Grey,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // TITLE + BUTTON
          // =========================
          Row(
            children: [
              const Icon(
                Icons.link,
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
                    color: Black,
                  ),
                ),
              ),

              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: onUploadPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: CardGreen,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  child: Text(
                    hasImage ? "Retake" : "Upload",
                    style: const TextStyle(
                      color: CardGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // =========================
          // IMAGE PREVIEW
          // =========================
          if (hasImage) ...[
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                selectedImageBytes!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}