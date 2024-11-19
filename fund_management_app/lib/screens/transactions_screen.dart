import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to deposit funds screen
              },
              child: Text('Deposit Funds'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to withdraw funds screen
              },
              child: Text('Withdraw Funds'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to transfer funds screen
              },
              child: Text('Transfer Funds'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with transaction data length
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.arrow_forward),
                    title: Text('Transaction #$index'),
                    subtitle: Text('Details here'),
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
