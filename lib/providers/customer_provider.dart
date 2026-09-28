import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CustomerModel? _customer;

  bool _isLoading = false;
  bool _isNewUser = false;

  // ============================================================
  // GETTERS
  // ============================================================

  CustomerModel? get customer => _customer;

  bool get isLoading => _isLoading;

  bool get isNewUser => _isNewUser;

  // ============================================================
  // LOADING
  // ============================================================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================================================
  // CREATE PICKUP ORDER
  // ============================================================

  Future<String> createPickupOrder({
    required List<String> selectedItems,
    required Map<String, double> weights,
    required String pickupAddress,
  }) async {
    // Check customer login
    if (_customer == null ||
        _customer!.uid == null ||
        _customer!.uid!.isEmpty) {
      throw Exception(
        'Customer is not logged in',
      );
    }

    _setLoading(true);

    try {
      // --------------------------------------------------------
      // Generate Order ID
      // --------------------------------------------------------

      final String orderId =
          'SG-${DateTime.now().millisecondsSinceEpoch}';

      // --------------------------------------------------------
      // Prepare Order Data
      // --------------------------------------------------------

      final Map<String, dynamic> orderData = {
        'orderId': orderId,

        'customerId': _customer!.uid,

        'customerName':
        _customer!.name ?? '',

        'customerEmail':
        _customer!.email ?? '',

        'selectedItems': selectedItems,

        'weights': weights,

        'pickupAddress': pickupAddress,

        'status': 'Pending',

        'createdAt':
        FieldValue.serverTimestamp(),
      };

      // --------------------------------------------------------
      // Save to Firestore
      // --------------------------------------------------------

      await _firestore
          .collection('pickupOrders')
          .doc(orderId)
          .set(orderData);

      log(
        'Pickup order created successfully: $orderId',
      );

      // IMPORTANT:
      // Return Order ID to SellScrapPage
      return orderId;
    } catch (e) {
      log(
        'Failed to create pickup order: $e',
      );

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // EMAIL / PASSWORD REGISTER
  // ============================================================

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      // --------------------------------------------------------
      // Check Existing Email
      // --------------------------------------------------------

      final QuerySnapshot<Map<String, dynamic>> existing =
      await _firestore
          .collection('customers')
          .where(
        'email',
        isEqualTo: email,
      )
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception(
          'An account with this email already exists',
        );
      }

      // --------------------------------------------------------
      // Generate Custom UID
      // --------------------------------------------------------

      final String uid =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      // --------------------------------------------------------
      // Create Customer
      // --------------------------------------------------------

      _customer = CustomerModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
        address: '',
      );

      // --------------------------------------------------------
      // Save Customer
      // --------------------------------------------------------

      await _firestore
          .collection('customers')
          .doc(uid)
          .set(
        _customer!.toMap(),
      );

      _isNewUser = false;

      notifyListeners();
    } catch (e) {
      log(
        'Registration error: $e',
      );

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // EMAIL / PASSWORD LOGIN
  // ============================================================

  Future<void> loginWithEmail(
      String email,
      String password,
      ) async {
    _setLoading(true);

    try {
      // --------------------------------------------------------
      // Find Customer
      // --------------------------------------------------------

      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore
          .collection('customers')
          .where(
        'email',
        isEqualTo: email,
      )
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception(
          'No account found with this email',
        );
      }

      // --------------------------------------------------------
      // Get Customer Data
      // --------------------------------------------------------

      final Map<String, dynamic> data =
      snapshot.docs.first.data();

      final String storedPassword =
          data['password']?.toString() ?? '';

      // --------------------------------------------------------
      // Check Password
      // --------------------------------------------------------

      if (storedPassword != password) {
        throw Exception(
          'Incorrect password',
        );
      }

      // --------------------------------------------------------
      // Set Current Customer
      // --------------------------------------------------------

      _customer =
          CustomerModel.fromMap(data);

      _isNewUser = false;

      notifyListeners();
    } catch (e) {
      log(
        'Login error: $e',
      );

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // UPDATE CUSTOMER PROFILE
  // ============================================================

  Future<void> updateCustomerProfile({
    required String name,
    required String email,
    required String address,
  }) async {
    if (_customer == null) {
      throw Exception(
        'Customer is not logged in',
      );
    }

    if (_customer!.uid == null ||
        _customer!.uid!.isEmpty) {
      throw Exception(
        'Customer ID is missing',
      );
    }

    _setLoading(true);

    try {
      // --------------------------------------------------------
      // Create Updated Customer
      // --------------------------------------------------------

      final CustomerModel updatedCustomer =
      _customer!.copyWith(
        name: name,
        email: email,
        address: address,
      );

      // --------------------------------------------------------
      // Update Firestore
      // --------------------------------------------------------

      await _firestore
          .collection('customers')
          .doc(updatedCustomer.uid!)
          .update(
        updatedCustomer.toMap(),
      );

      // --------------------------------------------------------
      // Update Local Customer
      // --------------------------------------------------------

      _customer = updatedCustomer;

      _isNewUser = false;

      notifyListeners();
    } catch (e) {
      log(
        'Profile update error: $e',
      );

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    _customer = null;

    _isNewUser = false;

    notifyListeners();
  }
}