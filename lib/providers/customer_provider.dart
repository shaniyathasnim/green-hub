import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CustomerModel? _customer;
  String? _verificationId;
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
      log('nnnnnnnnnnnnnnnnnnnnn');
      // Create Firebase Authentication account


      // Your custom UID
      final String uid = DateTime.now().millisecondsSinceEpoch.toString();

      // Create customer model
      _customer = CustomerModel(
        uid: uid,
        name: name,
        email: email,
        phoneNumber: '',
        address: '',
      );

      // Save customer to Firestore
      await _firestore.collection('customers').doc(uid).set(_customer!.toMap());
log('hhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      _isNewUser = false;

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Error Code: ${e.code}');
      log('Firebase Auth Error Message: ${e.message}');

      throw Exception(e.message ?? 'Registration failed');
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
      // Firebase Authentication
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception('Login failed');
      }

      // Find customer using email
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Customer exists
        _customer = CustomerModel.fromMap(snapshot.docs.first.data());

        _isNewUser = false;
      } else {
        // Customer doesn't exist in Firestore
        final String uid = DateTime.now().millisecondsSinceEpoch.toString();

        _customer = CustomerModel(
          uid: uid,
          name: user.displayName ?? '',
          email: user.email ?? email,
          phoneNumber: user.phoneNumber ?? '',
          address: '',
        );

        await _firestore
            .collection('customers')
            .doc(uid)
            .set(_customer!.toMap());

        _isNewUser = true;
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // PHONE AUTH
  // ============================================================

  Future<void> sendOtp(
    String phoneNumber, {
    required Function(String) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    _setLoading(true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',

        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _fetchCustomerData();
          _setLoading(false);
        },

        verificationFailed: (e) {
          _setLoading(false);
          onVerificationFailed(e);
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
          _setLoading(false);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw Exception('Verification ID is null');
    }

    _setLoading(true);

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      await _fetchCustomerData();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // FETCH CUSTOMER DATA
  // ============================================================

  Future<void> _fetchCustomerData() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('customers')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      _customer = CustomerModel.fromMap(snapshot.docs.first.data());

      _isNewUser = _customer?.name == null || _customer!.name!.isEmpty;
    } else {
      // Generate your custom UID
      final String uid = DateTime.now().millisecondsSinceEpoch.toString();

      _customer = CustomerModel(
        uid: uid,
        phoneNumber: user.phoneNumber ?? '',
        name: user.displayName ?? '',
        email: user.email ?? '',
        address: '',
      );

      await _firestore.collection('customers').doc(uid).set(_customer!.toMap());

      _isNewUser = true;
    }

    notifyListeners();
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
    await _auth.signOut();

    _customer = null;
    _isNewUser = false;

    notifyListeners();
  }
}
