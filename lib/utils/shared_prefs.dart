import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_model.dart';
class SharedPrefs {
static late SharedPreferences _prefs;

// Keys
static const String _keyUser = 'user_data';
static const String _keyIsLoggedIn = 'is_logged_in';

// Initialize
static Future<void> init() async {
  _prefs = await SharedPreferences.getInstance();
}
// Save User
static Future<void> setUser(CustomerModel user) async {
await _prefs.setString(_keyUser, jsonEncode(user.toMap()));
await _prefs.setBool(_keyIsLoggedIn, true);
}
// ----Get User--------

// static CustomerModel? getUser() {
// String? userJson = _prefs.getString(_keyUser);
// if (userJson == null) return null;
// return CustomerModel.fromMap(jsonDecode(userJson));
// }
  static Future<CustomerModel?> getUser() async {
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final String? userData = prefs.getString(_keyUser);

    if (userData == null) {
      return null;
    }

    return CustomerModel.fromMap(
      jsonDecode(userData),
    );
  }
// Check Login Status
static bool isLoggedIn() {
return _prefs.getBool(_keyIsLoggedIn) ?? false;
}
// Clear / Logout
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
