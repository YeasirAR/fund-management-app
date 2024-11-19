import 'dart:convert';
import 'package:fund_management_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = apiBaseUrl;
  // Login Method
  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw jsonDecode(response.body)['error'] ?? 'Login failed';
    }
  }

  // Signup Method
  static Future<void> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
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
      Uri.parse('$baseUrl/verify-email'),
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
      Uri.parse('$baseUrl/forgot-password'),
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
      Uri.parse('$baseUrl/reset-password'),
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
}
