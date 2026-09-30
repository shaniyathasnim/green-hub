import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  List<OrderModel> _orders = [];

  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders(String customerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint(
        'Fetching pickup orders for customer: $customerId',
      );

      final snapshot = await _firestore
          .collection('pickupOrders')
          .where(
        'customerId',
        isEqualTo: customerId,
      )
          .orderBy(
        'createdAt',
        descending: true,
      )
          .get();

      debugPrint(
        'Pickup orders found: ${snapshot.docs.length}',
      );

      _orders = snapshot.docs.map((doc) {
        debugPrint(
          'Pickup order ${doc.id}: ${doc.data()}',
        );

        return OrderModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    } catch (e) {
      debugPrint(
        'FETCH PICKUP ORDERS ERROR: $e',
      );

      _error = e.toString();
      _orders = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}