import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage_helper.dart';
import '../utils/constants.dart';

class DashboardService {
  static Future<Map<String, dynamic>> fetchDashboardData() async {
    final token = await SecureStorageHelper.read('authToken');
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}
