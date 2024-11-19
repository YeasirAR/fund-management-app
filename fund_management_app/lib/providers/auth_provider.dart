import 'package:flutter/material.dart';
import '../utils/secure_storage_helper.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    _token = await AuthService.login(email, password);
    await SecureStorageHelper.write('authToken', _token!);
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    _token = await SecureStorageHelper.read('authToken');
    if (_token != null) {
      notifyListeners();
    }
  }

  void logout() async {
    _token = null;
    await SecureStorageHelper.clear();
    notifyListeners();
  }
}
