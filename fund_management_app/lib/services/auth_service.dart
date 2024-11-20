import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/secure_storage_helper.dart';

class AuthService {
  static const String baseUrl = apiBaseUrl;

  // Login Method
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await SecureStorageHelper.write('authToken', token);
      return token;
    } else {
      throw jsonDecode(response.body)['error'] ?? 'Login failed';
    }
  }

  // Signup Method
  static Future<void> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw jsonDecode(response.body)['error'] ?? 'Signup failed';
    }
  }

  // Verify Email Method
  static Future<void> verifyEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Verification failed';
    }
  }

  // Forgot Password Method
  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Failed to send reset code';
    }
  }

  // Reset Password Method
  static Future<void> resetPassword(
      String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Password reset failed';
    }
  }
    // Get Dashboard Data
  static Future<Map<String, dynamic>> getDashboardData() async {
    final token = await SecureStorageHelper.read('authToken');
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token!,
      },
    );

    print('API Response: ${response.statusCode} ${response.body}'); // Debug log

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw jsonDecode(response.body)['error'] ?? 'Failed to fetch dashboard data';
    }
  }


  // Deposit Funds
  static Future<void> deposit(double amount) async {
    final token = await SecureStorageHelper.read('authToken');
    final response = await http.post(
      Uri.parse('$baseUrl/transaction/deposit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Deposit failed';
    }
  }

  // Withdraw Funds
  static Future<void> withdraw(double amount) async {
    final token = await SecureStorageHelper.read('authToken');
    final response = await http.post(
      Uri.parse('$baseUrl/transaction/withdraw'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Withdrawal failed';
    }
  }

  // Transfer Funds
  static Future<void> transfer(double amount, String recipientEmail) async {
    final token = await SecureStorageHelper.read('authToken');
    final response = await http.post(
      Uri.parse('$baseUrl/transaction/transfer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount, 'recipientEmail': recipientEmail}),
    );

    if (response.statusCode != 200) {
      throw jsonDecode(response.body)['error'] ?? 'Transfer failed';
    }
  }
}
