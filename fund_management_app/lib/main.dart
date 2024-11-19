import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fund Management App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}
