import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback? onGalleryTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onRemoveTap;

  const ImagePickerBottomSheet({
    super.key,
    this.onGalleryTap,
    this.onCameraTap,
    this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: White,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Header
              Row(
                children: [

                  const Expanded(
                    child: Text(
                      "Choose Image",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Black,
                      ),
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _BottomSheetItem(
                icon: Icons.photo_library_outlined,
                title: "Choose From Gallery",
                onTap: onGalleryTap,
              ),

              const SizedBox(height: 18),

              _BottomSheetItem(
                icon: Icons.photo_camera_outlined,
                title: "Take Photo",
                onTap: onCameraTap,
              ),

              const SizedBox(height: 18),

              _BottomSheetItem(
                icon: Icons.delete_outline,
                title: "Remove current Picture",
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: onRemoveTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _BottomSheetItem({
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 2,
          ),
          child: Row(
            children: [

              Icon(
                icon,
                size: 22,
                color: iconColor ?? CardGreen,
              ),

              const SizedBox(width: 14),

              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}