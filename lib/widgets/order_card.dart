import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final String status =
    order.status == OrderStatus.completed
        ? "Completed"
        : "Active";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Green,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID + Status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order ID",
                      style: TextStyle(
                        color: Grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderId,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CardGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: White,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Pay Amount
          const Text(
            "Pay Amount",
            style: TextStyle(
              color: Grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "₹${order.amount.toStringAsFixed(2)}",
            style: const TextStyle(
              color: CardGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: CardGreen,
              ),
              const SizedBox(width: 8),
              Text(
                order.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}