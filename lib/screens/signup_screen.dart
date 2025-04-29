// ignore_for_file: library_private_types_in_public_api

// import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
// ignore: depend_on_referenced_packages

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    // Removed delay logic, as we will navigate directly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black87,
      backgroundColor: Color(0xFF06041F),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign up',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Full Name', border: UnderlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Email Address', border: UnderlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: UnderlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // On successful signup, navigate to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: StadiumBorder()),
              child: Text('Sign up'),
            ),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Expanded(child: Divider(color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("or"),
              ),
              Expanded(child: Divider(color: Colors.grey)),
            ]),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialButton(label: 'Google', icon: Icons.g_mobiledata),
                SocialButton(label: 'Facebook', icon: Icons.facebook),
              ],
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text.rich(TextSpan(
                  text: "Do you already have an account? ",
                  children: [
                    TextSpan(
                        text: "Login now",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ])),
            )
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const SocialButton({required this.label, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: StadiumBorder(),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
