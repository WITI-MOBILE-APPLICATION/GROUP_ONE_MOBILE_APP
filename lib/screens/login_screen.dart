// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:my_app/screens/home_screen.dart';
// import 'package:my_app/screens/signup_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Adding delay to simulate splash or initial loading screen
//     Timer(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => SignUpScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Login',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 40),
//             const TextField(
//               decoration: InputDecoration(
//                   labelText: 'Email Address', border: UnderlineInputBorder()),
//             ),
//             SizedBox(height: 20),
//             const TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/forgot');
//                 },
//                 child: Text("Forgot Password?"),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   minimumSize: Size(double.infinity, 50),
//                   shape: StadiumBorder()),
//               child: Text('Login'),
//             ),
//             SizedBox(height: 20),
//             const Row(children: <Widget>[
//               Expanded(child: Divider(color: Colors.grey)),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text("or"),
//               ),
//               Expanded(child: Divider(color: Colors.grey)),
//             ]),
//             SizedBox(height: 20),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SocialButton(label: 'Google', icon: Icons.g_mobiledata),
//                 SocialButton(label: 'Facebook', icon: Icons.facebook),
//               ],
//             ),
//             SizedBox(height: 30),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/signup');
//               },
//               child: const Text.rich(TextSpan(
//                   text: "Do you already have an account? ",
//                   children: [
//                     TextSpan(
//                         text: "Sign up now",
//                         style: TextStyle(fontWeight: FontWeight.bold))
//                   ])),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SocialButton extends StatelessWidget {
//   final String label;
//   final IconData icon;

//   const SocialButton({required this.label, required this.icon, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey[800],
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         shape: StadiumBorder(),
//       ),
//       icon: Icon(icon, color: Colors.white),
//       label: Text(label, style: TextStyle(color: Colors.white)),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // The initState now only sets up the initial state without delay
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Email Address', border: UnderlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: UnderlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot');
                },
                child: const Text("Forgot Password?"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // On login, navigate to the next screen (e.g., home or dashboard)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder()),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            const Row(children: <Widget>[
              Expanded(child: Divider(color: Colors.grey)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("or"),
              ),
              Expanded(child: Divider(color: Colors.grey)),
            ]),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialButton(label: 'Google', icon: Icons.g_mobiledata),
                SocialButton(label: 'Facebook', icon: Icons.facebook),
              ],
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text.rich(TextSpan(
                  text: "Do you already have an account? ",
                  children: [
                    TextSpan(
                        text: "Sign up now",
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

  const SocialButton({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: const StadiumBorder(),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
