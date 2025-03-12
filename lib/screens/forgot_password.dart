import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Forgot Password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "You forgot your password? don't worry, please enter your recovery email address",
              style: TextStyle(color: Colors.grey[300]),
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Email Address', border: UnderlineInputBorder()),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: StadiumBorder()),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
