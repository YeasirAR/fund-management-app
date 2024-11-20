import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/dashboard_service.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      final data = await DashboardService.fetchDashboardData();
      setState(() {
        transactions = data['transactions'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load transactions: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6C63FF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final transactionDate = DateFormat('MMM d, yyyy, hh:mm a')
                        .format(DateTime.parse(transaction['date']));
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          transaction['type'] == 'deposit'
                              ? Icons.arrow_downward
                              : transaction['type'] == 'withdraw'
                                  ? Icons.arrow_upward
                                  : Icons.swap_horiz,
                          color: transaction['type'] == 'deposit'
                              ? Colors.green
                              : transaction['type'] == 'withdraw'
                                  ? Colors.red
                                  : Colors.blue,
                        ),
                        title: Text(
                          '${transaction['type'].toUpperCase()}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Date: $transactionDate',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          '\$${(transaction['amount'] ?? 0).toDouble().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction['type'] == 'deposit' ||
                                    transaction['type'] == 'Receive Money'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
