// @dart=2.17

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import 'app_localizations.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String error = '';
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        error =
            AppLocalizations.of(context)!.translate('all_fields_required') ??
                'All Fields Are Required';
      });
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        error = AppLocalizations.of(context)!.translate('invalid_email') ??
            'Please Enter a Valid Email Address';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        error =
            AppLocalizations.of(context)!.translate('passwords_dont_match') ??
                'Passwords Do Not Match';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        error = AppLocalizations.of(context)!.translate('password_too_short') ??
            'Password Must Be at Least 6 Characters Long';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final user = await _authService.signUp(email, password, name);

      if (user == null) {
        setState(() {
          error = AppLocalizations.of(context)!.translate('email_in_use') ??
              'Email Already in Use';
          isLoading = false;
        });
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)!.translate('registration_successful') ??
              'Registration Successful',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        error =
            '${AppLocalizations.of(context)!.translate('registration_failed') ?? 'Registration Failed'}: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.translate('sign_up') ??
                      'Sign Up',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.translate('full_name') ??
                            'Full Name',
                    border: const UnderlineInputBorder(),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.translate('email') ??
                            'Email',
                    border: const UnderlineInputBorder(),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.translate('password') ??
                            'Password',
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                            .translate('confirm_password') ??
                        'Confirm Password',
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.red)
                    : ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(double.infinity, 50),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('sign_up') ??
                              'Sign Up',
                          style: const TextStyle(fontSize: 16),
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
                      label:
                          AppLocalizations.of(context)!.translate('google') ??
                              'Google',
                      icon: Icons.g_mobiledata,
                    ),
                    SocialButton(
                      label:
                          AppLocalizations.of(context)!.translate('facebook') ??
                              'Facebook',
                      icon: Icons.facebook,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text.rich(
                    TextSpan(
                      text: AppLocalizations.of(context)!
                              .translate('already_have_account') ??
                          'Already Have an Account?',
                      children: [
                        WidgetSpan(
                          child: SizedBox(
                              width: 8), // 👈 adds horizontal space (8 pixels)
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                                  .translate('login') ??
                              'Login',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
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



// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../services/auth_service.dart';
// import 'app_localizations.dart';
// import 'login_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   bool isLoading = false;
//   String error = '';
//   final AuthService _authService = AuthService();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   Future<void> registerUser() async {
//     final name = nameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text;
//     final confirmPassword = confirmPasswordController.text;

//     if (name.isEmpty ||
//         email.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       setState(() {
//         error =
//             AppLocalizations.of(context)!.translate('all_fields_required') ??
//                 'All Fields Are Required';
//       });
//       return;
//     }

//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(email)) {
//       setState(() {
//         error = AppLocalizations.of(context)!.translate('invalid_email') ??
//             'Please Enter a Valid Email Address';
//       });
//       return;
//     }

//     if (password != confirmPassword) {
//       setState(() {
//         error =
//             AppLocalizations.of(context)!.translate('passwords_dont_match') ??
//                 'Passwords Do Not Match';
//       });
//       return;
//     }

//     if (password.length < 6) {
//       setState(() {
//         error = AppLocalizations.of(context)!.translate('password_too_short') ??
//             'Password Must Be at Least 6 Characters Long';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       error = '';
//     });

//     try {
//       final user = await _authService.signUp(email, password, name);

//       if (user == null) {
//         setState(() {
//           error = AppLocalizations.of(context)!.translate('email_in_use') ??
//               'Email Already in Use';
//           isLoading = false;
//         });
//         return;
//       }

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           AppLocalizations.of(context)!.translate('registration_successful') ??
//               'Registration Successful',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ));

//       Navigator.pushReplacementNamed(context, '/login');
//     } catch (e) {
//       setState(() {
//         error =
//             '${AppLocalizations.of(context)!.translate('registration_failed') ?? 'Registration Failed'}: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> signInWithGoogle() async {
//     setState(() {
//       isLoading = true;
//       error = '';
//     });

//     try {
//       final user = await _authService.signInWithGoogle();

//       if (user == null) {
//         setState(() {
//           error = AppLocalizations.of(context)!
//                   .translate('google_sign_in_failed') ??
//               'Google Sign-In Failed';
//           isLoading = false;
//         });
//         return;
//       }

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(
//           AppLocalizations.of(context)!
//                   .translate('google_sign_in_successful') ??
//               'Google Sign-In Successful',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ));

//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       setState(() {
//         error =
//             '${AppLocalizations.of(context)!.translate('google_sign_in_failed') ?? 'Google Sign-In Failed'}: $e';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF06041F),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 30),
//                 Text(
//                   AppLocalizations.of(context)!.translate('sign_up') ??
//                       'Sign Up',
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText:
//                         AppLocalizations.of(context)!.translate('full_name') ??
//                             'Full Name',
//                     border: const UnderlineInputBorder(),
//                     labelStyle: const TextStyle(color: Colors.white),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText:
//                         AppLocalizations.of(context)!.translate('email') ??
//                             'Email',
//                     border: const UnderlineInputBorder(),
//                     labelStyle: const TextStyle(color: Colors.white),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     labelText:
//                         AppLocalizations.of(context)!.translate('password') ??
//                             'Password',
//                     border: const UnderlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                     labelStyle: const TextStyle(color: Colors.white),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: confirmPasswordController,
//                   obscureText: _obscureConfirmPassword,
//                   decoration: InputDecoration(
//                     labelText: AppLocalizations.of(context)!
//                             .translate('confirm_password') ??
//                         'Confirm Password',
//                     border: const UnderlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirmPassword
//                             ? Icons.visibility_off
//                             : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureConfirmPassword = !_obscureConfirmPassword;
//                         });
//                       },
//                     ),
//                     labelStyle: const TextStyle(color: Colors.white),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 30),
//                 if (error.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Text(
//                       error,
//                       style: const TextStyle(color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 isLoading
//                     ? const CircularProgressIndicator(color: Colors.red)
//                     : ElevatedButton(
//                         onPressed: registerUser,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           minimumSize: const Size(double.infinity, 50),
//                           shape: const StadiumBorder(),
//                         ),
//                         child: Text(
//                           AppLocalizations.of(context)!.translate('sign_up') ??
//                               'Sign Up',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: <Widget>[
//                     const Expanded(child: Divider(color: Colors.grey)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text(
//                         AppLocalizations.of(context)!.translate('or') ?? 'Or',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const Expanded(child: Divider(color: Colors.grey)),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: signInWithGoogle,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                         shape: const StadiumBorder(),
//                       ),
//                       icon: Image.asset(
//                         'assets/images/google_logo.png',
//                         height: 24.0,
//                         width: 24.0,
//                       ),
//                       label: Text(
//                         AppLocalizations.of(context)!
//                                 .translate('sign_in_with_google') ??
//                             'Sign in with Google',
//                         style: const TextStyle(
//                           color: Colors.black87,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                   child: Text.rich(
//                     TextSpan(
//                       text: AppLocalizations.of(context)!
//                               .translate('already_have_account') ??
//                           'Already Have an Account?',
//                       children: [
//                         WidgetSpan(
//                           child: SizedBox(
//                               width: 8), // 👈 adds horizontal space (8 pixels)
//                         ),
//                         TextSpan(
//                           text: AppLocalizations.of(context)!
//                                   .translate('login') ??
//                               'Login',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
