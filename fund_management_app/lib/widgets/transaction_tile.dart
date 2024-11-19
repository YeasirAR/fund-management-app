import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;

  const TransactionTile({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.monetization_on),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        '\$${amount.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}
