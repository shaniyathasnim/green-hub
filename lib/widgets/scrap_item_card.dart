import 'package:flutter/material.dart';
import 'package:green_bin/models/gb_modelclass.dart';
import 'package:green_bin/utils/app_colors.dart';

class ScrapItemCard extends StatelessWidget {
  final ScrapItemModel item;
  final bool isSelected;
  final VoidCallback onTap;


  const ScrapItemCard({super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration:const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? CardGreen :LightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? CardGreen : Colors.green.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
            if(isSelected)
             const  Positioned(
            top: 6,
          right: 6,
          child: Icon(
            Icons.check,
            color: White,
            size: 16,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected? DarkGrey : DarkGrey,
                  shape:  BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: isSelected ? CardGreen : CardGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? White : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

              ],
          ),
        ),
              ],
        )

      ),
          ),
    );
  }
}
