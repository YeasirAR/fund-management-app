import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/performance_chart_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/verify_email_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/withdraw_screen.dart';
import 'screens/transfer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fund Management App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // Define routes here
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(), // Add this
        '/dashboard': (context) => DashboardScreen(),
        '/verify-email': (context) => VerifyEmailScreen(),
        '/deposit': (context) => DepositScreen(),
        '/withdraw': (context) => WithdrawScreen(),
        '/transfer': (context) => TransferScreen(),
        '/transactions': (context) => TransactionsScreen(),
        '/performance-chart': (context) => PerformanceChartScreen(), // Add this

      },
    );
  }
}
