import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  void handleDeposit() async {
    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.deposit(double.parse(amountController.text));
      Fluttertoast.showToast(
        msg: "Deposit successful!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate back to the dashboard and indicate that data needs to be refreshed
      Navigator.pop(context, true); // Pass `true` to indicate success
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
          "Deposit Funds",
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: Color(0xFF6C63FF), // Modern Purple
        iconTheme: IconThemeData(color: Colors.white), // Back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Amount',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : handleDeposit,
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
                      'Deposit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Button text color
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
