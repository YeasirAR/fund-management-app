import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  void handleTransfer() async {
    setState(() {
      isLoading = true;
    });

    try {
      double amount = double.parse(amountController.text);
      if (amount <= 0) {
        throw Exception("Amount must be greater than zero.");
      }
      if (emailController.text.trim().isEmpty) {
        throw Exception("Recipient email cannot be empty.");
      }

      await AuthService.transfer(
        amount,
        emailController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Transfer successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pop(context, true); // Pass true to refresh dashboard
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
          "Transfer Funds",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF6C63FF),
        iconTheme: IconThemeData(color: Colors.white), // Back button in white
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipient Email',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter recipient email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.email, color: Color(0xFF6C63FF)),
              ),
            ),
            SizedBox(height: 24),
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
              onPressed: isLoading ? null : handleTransfer,
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
                      'Transfer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Button text color white
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
