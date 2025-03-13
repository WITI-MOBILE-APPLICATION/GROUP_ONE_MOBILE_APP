import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'signup_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      backgroundColor: Colors.red,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "MovieVault",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
