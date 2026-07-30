// import 'package:flutter/material.dart';
// import '../models/order_model.dart';
// import '../utils/app_colors.dart';
// import 'status_chip.dart';
//
// class OrderCard extends StatelessWidget {
//   final OrderModel order;
//
//   const OrderCard({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: White,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: DarkGrey, width: 1.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Order Id:",
//                     style: TextStyle(color: Grey, fontSize: 13),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     order.orderId,
//                     style: const TextStyle(
//                       color: Black,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               StatusChip(status: order.status),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Pay Amount:",
//                     style: TextStyle(color: Grey, fontSize: 13),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "₹${order.amount.toStringAsFixed(2)}",
//                     style: const TextStyle(
//                       color: CardGreen,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Icon(Icons.calendar_today_outlined,
//                       size: 16, color: CardGreen),
//                   const SizedBox(width: 6),
//                   Text(
//                     order.date,
//                     style: const TextStyle(
//                       color: Black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DarkGrey,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Order ID & Status
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
                        color: Black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              StatusChip(status: order.status),
            ],
          ),

          const SizedBox(height: 18),

          /// Amount
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          /// Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: CardGreen,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                order.date,
                style: const TextStyle(
                  color: Black,
                  fontSize: 14,
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