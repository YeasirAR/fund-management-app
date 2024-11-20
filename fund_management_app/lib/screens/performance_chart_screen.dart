import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/dashboard_service.dart';

class PerformanceChartScreen extends StatefulWidget {
  @override
  _PerformanceChartScreenState createState() => _PerformanceChartScreenState();
}

class _PerformanceChartScreenState extends State<PerformanceChartScreen> {
  Map<String, double> transactionData = {
    'deposit': 0.0,
    'withdraw': 0.0,
    'transfer': 0.0,
  }; // Store transaction sums
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
        transactionData = calculateTransactionData(data['transactions'] ?? []);
        isLoading = false;
      });

      // Debugging log
      print("Transaction Data: $transactionData");
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load transactions: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  Map<String, double> calculateTransactionData(List transactions) {
    final Map<String, double> transactionSums = {
      'deposit': 0.0,
      'withdraw': 0.0,
      'transfer': 0.0,
    };

    for (var transaction in transactions) {
      final type = transaction['type'];
      final amount = (transaction['amount'] ?? 0).toDouble();
      if (transactionSums.containsKey(type)) {
        transactionSums[type] = transactionSums[type]! + amount;
      }
    }

    return transactionSums;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Performance Chart',
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
              : transactionData.values.every((value) => value == 0.0)
                  ? Center(
                      child: Text(
                        'No transactions available to display.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction Chart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                barGroups: transactionData.entries.map((entry) {
                                  return BarChartGroupData(
                                    x: entry.key == 'deposit'
                                        ? 0
                                        : entry.key == 'withdraw'
                                            ? 1
                                            : 2,
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value,
                                        color: entry.key == 'deposit'
                                            ? Colors.green
                                            : entry.key == 'withdraw'
                                                ? Colors.red
                                                : Colors.blue,
                                        width: 16,
                                      ),
                                    ],
                                  );
                                }).toList(),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return Text('Deposit');
                                          case 1:
                                            return Text('Withdraw');
                                          case 2:
                                            return Text('Transfer');
                                          default:
                                            return Text('');
                                        }
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
