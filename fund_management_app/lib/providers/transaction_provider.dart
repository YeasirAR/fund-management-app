import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  List<dynamic> _transactions = [];
  List<dynamic> get transactions => _transactions;

  Future<void> fetchTransactions(String token) async {
    try {
      _transactions = await TransactionService.fetchTransactions(token);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<void> addTransaction(
      String token, String type, double amount) async {
    try {
      await TransactionService.createTransaction(token, type, amount);
      await fetchTransactions(token); // Refresh the list
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }
}
