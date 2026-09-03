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

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Send OTP
  Future<void> sendOtp(String phoneNumber, {
    required Function(String) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    _setLoading(true);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          await _fetchOrCreateCustomer();
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

  // Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (_verificationId == null) return;
    
    _setLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      await _fetchOrCreateCustomer();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Fetch or Create Customer in Firestore
  Future<void> _fetchOrCreateCustomer() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('customers').doc(user.uid).get();
    
    if (doc.exists) {
      _customer = CustomerModel.fromMap(doc.data()!);
      // User exists but might not have completed registration (missing name)
      _isNewUser = _customer?.name == null || _customer!.name!.isEmpty;
    } else {
      _customer = CustomerModel(
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        name: '',
        email: '',
        address: '',
      );
      await _firestore.collection('customers').doc(user.uid).set(_customer!.toMap());
      _isNewUser = true;
    }
    notifyListeners();
  }

  // Register Customer Profile
  Future<void> registerCustomer({
    required String name,
    required String email,
    required String address,
  }) async {
    if (_customer == null) return;
    
    _setLoading(true);
    try {
      final updatedCustomer = _customer!.copyWith(
        name: name,
        email: email,
        address: address,
      );
      
      await _firestore.collection('customers').doc(updatedCustomer.uid!).update(updatedCustomer.toMap());
      _customer = updatedCustomer;
      _isNewUser = false;
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Update Customer Info
  Future<void> updateCustomer(CustomerModel updatedCustomer) async {
    _setLoading(true);
    try {
      await _firestore.collection('customers').doc(updatedCustomer.uid!).update(updatedCustomer.toMap());
      _customer = updatedCustomer;
      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _customer = null;
    _isNewUser = false;
    notifyListeners();
  }
}
