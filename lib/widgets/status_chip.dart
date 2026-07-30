import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';

class StatusChip extends StatelessWidget {
  final OrderStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == OrderStatus.completed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? CardGreen : White,
        borderRadius: BorderRadius.circular(20),
        border: isCompleted ? null : Border.all(color: CardGreen, width: 1),
      ),
      child: Text(
        isCompleted ? "Completed" : "Active",
        style: TextStyle(
          color: isCompleted ? White : CardGreen,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}