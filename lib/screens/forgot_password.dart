import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/signup_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
            const Text('Forgot Password?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "You forgot your password? don't worry, please enter your recovery email address",
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Email Address', border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder()),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
