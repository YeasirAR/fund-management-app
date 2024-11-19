import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  // Function to handle verification
  void verifyCode(String email) async {
    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.verifyEmail(email, codeController.text.trim());

      Fluttertoast.showToast(
        msg: "Email verified successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to login screen after successful verification
      Navigator.pushReplacementNamed(context, '/login');
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
    // Retrieve the email passed as an argument
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: Color(0xFF6C63FF), // Modern Purple
      ),
      backgroundColor: Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify Your Email',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Enter the verification code sent to $email.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6, // Limit to 6 digits for the verification code
              decoration: InputDecoration(
                hintText: 'Enter Verification Code',
                prefixIcon: Icon(Icons.verified_outlined, color: Color(0xFF6C63FF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : () => verifyCode(email),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF), // Modern Purple
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Verify',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
