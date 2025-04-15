// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
// import 'screens/movie_detail_screen.dart';
// import 'screens/splash_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/download_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/forgot_password.dart';
// import 'screens/onboarding1.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: "assets/.env");

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider(create: (_) => DownloadServices()),
//       ],
//       child: MaterialApp(
//         title: 'MovieVault',
//         theme: ThemeData.dark().copyWith(
//           primaryColor: const Color(0xFF06041F),
//           scaffoldBackgroundColor: const Color(0xFF06041F),
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         debugShowCheckedModeBanner: false,

//         initialRoute: '/', // Start with the splash screen
//         routes: {
//           '/': (context) => SplashScreen(),
//           '/onboarding': (context) => OnboardingScreen(),

//           // Login screen route
//           '/signup': (context) => SignUpScreen(),
//           '/login': (context) => LoginScreen(),
//           '/home': (context) => HomeScreen(),
//           '/forgot': (context) => ForgotPasswordScreen()
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '/screens/forgot_password.dart';
import '/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'providers/movie_provider.dart';
import 'screens/forgot_password.dart';
import 'screens/onboarding1.dart';
import 'screens/download_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'MovieVault',
        // theme: ThemeData.dark().copyWith(
        //   primaryColor: Colors.blueAccent,
        //   // primaryColor: Colors.black,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF06041F), // Custom Black Pearl color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        debugShowCheckedModeBanner: false,

        initialRoute: '/', // Start with the splash screen
        routes: {
          '/': (context) => SplashScreen(),
          '/onboarding': (context) => OnboardingScreen(),

          // Login screen route
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/forgot': (context) => ForgotPasswordScreen(),
          '/downloads': (context) => DownloadsScreen()
        },
      ),
    );
  }
}
