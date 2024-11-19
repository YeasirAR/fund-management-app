import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: John Doe',
              style: TextStyle(fontSize: 18),
            ),
            Divider(),
            Text(
              'Email: john@example.com',
              style: TextStyle(fontSize: 18),
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
