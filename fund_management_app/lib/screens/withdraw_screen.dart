import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  void handleWithdraw() async {
    setState(() {
      isLoading = true;
    });

    try {
      double amount = double.parse(amountController.text);
      if (amount <= 0) {
        throw Exception("Amount must be greater than zero.");
      }

      await AuthService.withdraw(amount);

      Fluttertoast.showToast(
        msg: "Withdrawal successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pop(context, true); // Pass true to trigger refresh on dashboard
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Withdraw Funds",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6C63FF),
        iconTheme: IconThemeData(color: Colors.white), // Ensures back button is white
      ),
      backgroundColor: Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.attach_money, color: Color(0xFF6C63FF)),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : handleWithdraw,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Withdraw',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
