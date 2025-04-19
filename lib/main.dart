// import 'package:flutter/material.dart';

// import '/screens/forgot_password.dart';
// import '/screens/signup_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'screens/home_screen.dart';
// import 'screens/movie_detail_screen.dart';
// import 'screens/splash_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/signup_screen.dart';
// import 'providers/movie_provider.dart';
// import 'screens/forgot_password.dart';
// import 'screens/onboarding1.dart';
// import 'screens/download_screen.dart';
// import 'screens/settings.dart'; // Add this import for your settings page

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: "assets/.env");
  
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => MovieProvider()),
//       ],
//       child: MaterialApp(
//         title: 'MovieVault',
//         theme: ThemeData.dark().copyWith(
//           primaryColor: Color(0xFF06041F), // Custom Black Pearl color
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
//           '/forgot': (context) => ForgotPasswordScreen(),
//           '/downloads': (context) => DownloadsScreen(),
//           '/settings': (context) => Settings(), 
         
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/forgot_password.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding1.dart';
import 'screens/download_screen.dart';
import 'screens/settings.dart';
import 'providers/movie_provider.dart';

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
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'MovieVault',
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF06041F),
          scaffoldBackgroundColor: const Color(0xFF1a1a2e),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFe0e0e0)),
            bodyMedium: TextStyle(color: Color(0xFFe0e0e0)),
            titleSmall: TextStyle(color: Color(0xFF9e9e9e), fontSize: 12),
            titleLarge: TextStyle(color: Color(0xFFe0e0e0), fontSize: 24, fontWeight: FontWeight.bold),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.all(Colors.white),
            trackColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected) ? const Color(0xFF4f46e5) : Colors.grey),
          ),
        ),
        debugShowCheckedModeBanner: false,
        
        // home: const Settings(),
        
        routes: {
          '/': (context) => SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/forgot': (context) => const ForgotPasswordScreen(),
          '/downloads': (context) => const DownloadsScreen(),
          '/settings': (context) => const Settings(),
        },
      ),
    );
  }
}