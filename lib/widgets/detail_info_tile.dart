import 'package:flutter/material.dart';
import 'package:green_bin/utils/app_colors.dart';

class DetailInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
            padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color:LightGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,color: CardGreen,size: 22,
        ),
      ),
              const SizedBox(width: 12,),
              //Text Content
              Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
    color: Grey,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 4,),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Black,
          fontWeight: FontWeight.w600,
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
