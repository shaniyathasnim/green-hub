import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  active,
  completed,
}

class OrderModel {
  final String orderId;
  final OrderStatus status;
  final double amount;
  final String date;
  final String customerId;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.amount,
    required this.date,
    required this.customerId,
  });

  factory OrderModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    final timestamp = map['createdAt'];

    DateTime orderDate;

    if (timestamp is Timestamp) {
      orderDate = timestamp.toDate();
    } else if (timestamp is DateTime) {
      orderDate = timestamp;
    } else {
      orderDate = DateTime.now();
    }

    return OrderModel(
      orderId: map['orderId'] ?? id,

      status: _parseStatus(
        map['status'],
      ),

      amount: _getAmount(map),

      date:
      '${orderDate.day.toString().padLeft(2, '0')}/'
          '${orderDate.month.toString().padLeft(2, '0')}/'
          '${orderDate.year}',

      customerId: map['customerId'] ?? '',
    );
  }

  static OrderStatus _parseStatus(dynamic value) {
    final status = value
        ?.toString()
        .toLowerCase()
        .trim();

    switch (status) {
      case 'completed':
        return OrderStatus.completed;

      case 'pending':
      case 'active':
      default:
        return OrderStatus.active;
    }
  }

  static double _getAmount(
      Map<String, dynamic> map,
      ) {
    // Your current Firebase document
    // does not contain an amount field.
    //
    // So we safely return 0 until you
    // store the calculated amount.

    final value = map['amount'];

    if (value is num) {
      return value.toDouble();
    }

    return 0.0;
  }
}