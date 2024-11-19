import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Current Funds'),
                subtitle: Text('\$10,000'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with transaction data length
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text('Transaction #$index'),
                    subtitle: Text('Nov ${10 - index}, 2024'),
                    trailing: Text(
                      '\$100.00',
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
