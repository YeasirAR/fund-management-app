import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? errorMessage; // To store error messages
  bool isLoading = false;

  void sendResetCode() async {
  setState(() {
    isLoading = true;
    errorMessage = null; // Clear any previous error messages
  });

  try {
    await AuthService.forgotPassword(emailController.text); // Backend call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reset code sent to your email!'),
        backgroundColor: Colors.green,
      ),
    );
    // Navigate to reset-password screen
    Navigator.pushNamed(
      context,
      '/reset-password',
      arguments: emailController.text, // Pass email as an argument
    );
  } catch (e) {
    setState(() {
      errorMessage = e.toString(); // Capture error messages
    });
  } finally {
    setState(() {
      isLoading = false; // Ensure the button resets in all cases
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your email to receive a password reset code.',
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

              // Email Input
              CustomTextField(
                controller: emailController,
                hintText: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(height: 24),

              // Send Code Button
              ElevatedButton(
                onPressed: isLoading ? null : sendResetCode,
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: isLoading ? Colors.grey : Theme.of(context).primaryColor,
                  shadowColor: Colors.deepPurple.withOpacity(0.2),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Send Code',
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
