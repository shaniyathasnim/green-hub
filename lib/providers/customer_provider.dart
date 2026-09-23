import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CustomerModel? _customer;
  bool _isLoading = false;
  bool _isNewUser = false;

  CustomerModel? get customer => _customer;
  bool get isLoading => _isLoading;
  bool get isNewUser => _isNewUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
      // Check if email already exists
      final QuerySnapshot<Map<String, dynamic>> existing = await _firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('An account with this email already exists');
      }

      // Custom UID
      final String uid = DateTime.now().millisecondsSinceEpoch.toString();

      // Create customer model
      _customer = CustomerModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
        address: '',
      );

      // Save customer to Firestore
      await _firestore
          .collection('customers')
          .doc(uid)
          .set(_customer!.toMap());

      _isNewUser = false;

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // EMAIL / PASSWORD LOGIN
  // ============================================================

  Future<void> loginWithEmail(String email, String password) async {
    _setLoading(true);

    try {
      // Find customer using email
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('No account found with this email');
      }

      final Map<String, dynamic> data = snapshot.docs.first.data();
      final String storedPassword = data['password']?.toString() ?? '';

      if (storedPassword != password) {
        throw Exception('Incorrect password');
      }

      _customer = CustomerModel.fromMap(data);
      _isNewUser = false;

      notifyListeners();
    } catch (e) {
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
      return;
    }

    _setLoading(true);

    try {
      final CustomerModel updatedCustomer = _customer!.copyWith(
        name: name,
        email: email,
        address: address,
      );

      await _firestore
          .collection('customers')
          .doc(updatedCustomer.uid!)
          .update(updatedCustomer.toMap());

      _customer = updatedCustomer;
      _isNewUser = false;

      notifyListeners();
    } catch (e) {
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