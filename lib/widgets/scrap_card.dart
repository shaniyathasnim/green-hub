import 'package:flutter/material.dart';import 'package:green_bin/models/gb_modelclass.dart';
import 'package:green_bin/utils/app_colors.dart';

class ScrapCard extends StatelessWidget {
  final ScrapItemModel item;
  final VoidCallback onTap;

  const ScrapCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: LightGrey, width:1.5),
        boxShadow: [
          BoxShadow(
            color: Black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: LightGrey,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: CardGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price Range
                Text(
                  item.priceRange,
                  style: const TextStyle(
                    color: CardGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}