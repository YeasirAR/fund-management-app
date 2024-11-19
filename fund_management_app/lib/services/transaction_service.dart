import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl = 'http://localhost:5000/api/transactions';

  static Future<List<dynamic>> fetchTransactions(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  static Future<void> createTransaction(
      String token, String type, double amount) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'type': type, 'amount': amount}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction');
    }
  }
}
