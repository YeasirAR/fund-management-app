import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              hintText: 'Full Name',
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              hintText: 'Email Address',
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Sign Up',
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match!'),
                    ),
                  );
                  return;
                }

                try {
                  await AuthService.signup(
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup successful! Please log in.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Navigate back to the login screen
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate to login screen
                  },
                  child: Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
