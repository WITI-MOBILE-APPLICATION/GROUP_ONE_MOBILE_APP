// @dart=2.17

import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import 'app_localizations.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';
  bool isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        setState(() {
          error = AppLocalizations.of(context)!
                  .translate('email_password_required') ??
              'Email and Password Are Required';
        });
        return;
      }

      final user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (user == null) {
        setState(() {
          error = AppLocalizations.of(context)!
                  .translate('invalid_email_password') ??
              'Invalid Email or Password';
        });
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate('login_successful') ??
              'Login Successful',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        error =
            AppLocalizations.of(context)!.translate('something_went_wrong') ??
                'Something Went Wrong Please Try Again';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
            Text(
              AppLocalizations.of(context)!.translate('login') ?? 'Login',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('email') ?? 'Email',
                border: const UnderlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('password') ??
                        'Password',
                border: const UnderlineInputBorder(),
                labelStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.translate('forgot_password') ??
                      'Forgot Password',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('login') ??
                          'Login',
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.translate('or') ?? 'Or',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SocialButton(
                  label: AppLocalizations.of(context)!.translate('google') ??
                      'Google',
                  icon: Icons.g_mobiledata,
                ),
                SocialButton(
                  label: AppLocalizations.of(context)!.translate('facebook') ??
                      'Facebook',
                  icon: Icons.facebook,
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text.rich(
                TextSpan(
                  text: AppLocalizations.of(context)!
                          .translate('dont_have_account') ??
                      "Don't Have an Account?",
                  children: [
                    WidgetSpan(
                      child: SizedBox(
                          width: 8), // 👈 adds horizontal space (8 pixels)
                    ),
                    TextSpan(
                      text:
                          AppLocalizations.of(context)!.translate('sign_up') ??
                              'Sign Up',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
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
