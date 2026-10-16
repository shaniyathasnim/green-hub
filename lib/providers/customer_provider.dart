import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/customer_model.dart';
import '../services/cloudinary_service.dart';
import '../utils/shared_prefs.dart';

class CustomerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  // LOAD CUSTOMER FROM SHARED PREFERENCES
  // ============================================================

  Future<void> loadCustomer() async {
    try {
      final bool loggedIn = SharedPrefs.isLoggedIn();

      if (!loggedIn) {
        log('No logged-in customer');
        return;
      }

      final CustomerModel? savedCustomer = await SharedPrefs.getUser();

      if (savedCustomer != null) {
        _customer = savedCustomer;

        log('Customer loaded: ${savedCustomer.email}');

        notifyListeners();
      }
    } catch (e) {
      log('Load customer error: $e');
    }
  }

  // ============================================================
  // CREATE PICKUP ORDER
  // ============================================================

  Future<String> createPickupOrder({
    required List<String> selectedItems,
    required Map<String, double> weights,
    required String pickupAddress,
  }) async {
    if (_customer == null ||
        _customer!.uid == null ||
        _customer!.uid!.isEmpty) {
      throw Exception('Customer is not logged in');
    }

    _setLoading(true);

    try {
      final String orderId = 'SG-${DateTime.now().millisecondsSinceEpoch}';

      final Map<String, dynamic> orderData = {
        'orderId': orderId,
        'customerId': _customer!.uid,
        'customerName': _customer!.name ?? '',
        'customerEmail': _customer!.email ?? '',
        'selectedItems': selectedItems,
        'weights': weights,
        'pickupAddress': pickupAddress,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('pickupOrders').doc(orderId).set(orderData);

      log('Pickup order created: $orderId');

      return orderId;
    } catch (e) {
      log('Failed to create pickup order: $e');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final String cleanName = name.trim();

      final String cleanEmail = email.trim().toLowerCase();

      final String cleanPassword = password.trim();

      if (cleanName.isEmpty) {
        throw Exception('Please enter your name');
      }

      if (cleanEmail.isEmpty) {
        throw Exception('Please enter your email');
      }

      if (cleanPassword.isEmpty) {
        throw Exception('Please enter your password');
      }

      // --------------------------------------------------------
      // CHECK EXISTING EMAIL
      // --------------------------------------------------------

      final QuerySnapshot<Map<String, dynamic>> existing = await _firestore
          .collection('customers')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('An account with this email already exists');
      }

      // --------------------------------------------------------
      // CREATE UID
      // --------------------------------------------------------

      final String uid = DateTime.now().millisecondsSinceEpoch.toString();

      // --------------------------------------------------------
      // CREATE CUSTOMER MODEL
      // --------------------------------------------------------

      final CustomerModel newCustomer = CustomerModel(
        uid: uid,
        name: cleanName,
        email: cleanEmail,
        password: cleanPassword,
        address: '',
        phoneNumber: '',
        profileImageUrl: '',
      );

      // --------------------------------------------------------
      // SAVE TO FIRESTORE
      // --------------------------------------------------------

      await _firestore.collection('customers').doc(uid).set({
        ...newCustomer.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // --------------------------------------------------------
      // SAVE LOCALLY
      // --------------------------------------------------------

      _customer = newCustomer;

      _isNewUser = true;

      await SharedPrefs.setUser(newCustomer);

      notifyListeners();

      log('Registration successful');

      log('Customer ID: $uid');
    } catch (e) {
      log('Registration error: $e');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> loginWithEmail(String email, String password) async {
    _setLoading(true);

    try {
      final String cleanEmail = email.trim().toLowerCase();

      final String cleanPassword = password.trim();

      log('================================');
      log('LOGIN STARTED');
      log('Email: $cleanEmail');

      // --------------------------------------------------------
      // FIND CUSTOMER
      // --------------------------------------------------------

      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('customers')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      log('Customers found: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        throw Exception('No account found with this email');
      }

      // --------------------------------------------------------
      // GET DATA
      // --------------------------------------------------------

      final Map<String, dynamic> data = snapshot.docs.first.data();

      log('Customer UID: ${data['uid']}');

      log('Customer email: ${data['email']}');

      // --------------------------------------------------------
      // CHECK PASSWORD
      // --------------------------------------------------------

      final String storedPassword = data['password']?.toString() ?? '';

      if (storedPassword != cleanPassword) {
        log('Password does not match');

        throw Exception('Incorrect password');
      }

      log('Password matched');

      // --------------------------------------------------------
      // CREATE CUSTOMER MODEL
      // --------------------------------------------------------

      _customer = CustomerModel.fromMap(data);

      _isNewUser = false;

      // --------------------------------------------------------
      // SAVE LOGIN SESSION
      // --------------------------------------------------------

      await SharedPrefs.setUser(_customer!);

      notifyListeners();

      log('LOGIN SUCCESS');

      log('================================');
    } catch (e) {
      log('Login error: $e');

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
    required String phoneNumber,

  }) async {
    if (_customer == null) {
      throw Exception('Customer is not logged in');
    }

    if (_customer!.uid == null || _customer!.uid!.isEmpty) {
      throw Exception('Customer ID is missing');
    }

    _setLoading(true);

    try {
      final String cleanName = name.trim();

      final String cleanEmail = email.trim().toLowerCase();

      final String cleanAddress = address.trim();

      final CustomerModel updatedCustomer = _customer!.copyWith(
        name: cleanName,
        email: cleanEmail,
        address: cleanAddress,
      );

      await _firestore
          .collection('customers')
          .doc(updatedCustomer.uid!)
          .update({
            'name': cleanName,
            'email': cleanEmail,
            'address': cleanAddress,
            'updatedAt': FieldValue.serverTimestamp(),
            'phoneNumber': phoneNumber,
          });

      _customer = updatedCustomer;

      await SharedPrefs.setUser(updatedCustomer);

      _isNewUser = false;

      notifyListeners();

      log('Profile updated successfully');
    } catch (e) {
      log('Profile update error: $e');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // UPDATE PROFILE PHOTO
  // ============================================================

  Future<void> updateProfilePhoto(XFile imageFile) async {
    if (_customer == null) {
      throw Exception('Customer is not logged in');
    }

    if (_customer!.uid == null || _customer!.uid!.isEmpty) {
      throw Exception('Customer ID is missing');
    }

    _setLoading(true);

    try {
      // --------------------------------------------------------
      // CLOUDINARY UPLOAD
      // --------------------------------------------------------

      log('Uploading profile image to Cloudinary...');

      final String? imageUrl = await CloudinaryService.uploadImage(imageFile);

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Cloudinary image upload failed');
      }

      log('Cloudinary upload successful');

      log('Image URL: $imageUrl');

      // --------------------------------------------------------
      // FIRESTORE UPDATE
      // --------------------------------------------------------

      await _firestore.collection('customers').doc(_customer!.uid!).update({
        'profileImageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // --------------------------------------------------------
      // UPDATE LOCAL CUSTOMER
      // --------------------------------------------------------

      _customer = _customer!.copyWith(profileImageUrl: imageUrl);

      // --------------------------------------------------------
      // UPDATE SHARED PREFS
      // --------------------------------------------------------

      await SharedPrefs.setUser(_customer!);

      notifyListeners();

      log('Profile image updated successfully');
    } catch (e) {
      log('Profile image update error: $e');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      _customer = null;

      _isNewUser = false;

      await SharedPrefs.clear();

      notifyListeners();

      log('Customer logged out');
    } catch (e) {
      log('Logout error: $e');

      rethrow;
    }
  }
}
