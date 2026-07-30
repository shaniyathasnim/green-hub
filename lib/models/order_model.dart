import 'package:flutter/material.dart';

enum OrderStatus { active, completed }

class OrderModel {
  final String orderId;
  final double amount;
  final String date;
  final OrderStatus status;

  const OrderModel({
    required this.orderId,
    required this.amount,
    required this.date,
    required this.status,
  });
}