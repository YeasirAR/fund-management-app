import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String? errorMessage; // To store error messages
  bool isLoading = false;

  void resetPassword(String email) async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Clear previous error messages
    });

    try {
      await AuthService.resetPassword(
        email,
        codeController.text,
        newPasswordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/'); // Redirect to login
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Capture error messages
      });
    } finally {
      setState(() {
        isLoading = false; // Reset loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Reset Code',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter the reset code sent to your email along with your new password.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // Display Error Message
              if (errorMessage != null)
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),

              // Reset Code Input
              CustomTextField(
                controller: codeController,
                hintText: 'Reset Code',
                prefixIcon: Icons.vpn_key_outlined,
              ),
              SizedBox(height: 16),

              // New Password Input
              CustomTextField(
                controller: newPasswordController,
                hintText: 'New Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              SizedBox(height: 24),

              // Reset Password Button
              ElevatedButton(
                onPressed: isLoading ? null : () => resetPassword(email),
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor:
                      isLoading ? Colors.grey : Theme.of(context).primaryColor,
                  shadowColor: Colors.deepPurple.withOpacity(0.2),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Reset Password',
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
      ),
    );
  }
}
