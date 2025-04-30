// @dart=2.17
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
// import 'screens/profile_screen.dart';
// import 'screens/saved.dart';
// // import 'screens/voucher_screen.dart';
// // import 'screens/payment_screen.dart';

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
//         ChangeNotifierProvider(create: (_) => MovieProvider()),
//       ],
//       child: MaterialApp(
//         title: 'MovieVault',
//         // theme: ThemeData.dark().copyWith(
//         //   primaryColor: Colors.blueAccent,
//         //   // primaryColor: Colors.black,
//         //   visualDensity: VisualDensity.adaptivePlatformDensity,
//         // ),
//         theme: ThemeData.dark().copyWith(
//           primaryColor: const Color(0xFF06041F), // Custom Black Pearl color
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
//           '/downloads': (context) => DownloadsPage(),
//           '/profile': (context) => ProfileScreen(),
//           '/saved': (context) => SavedMoviesScreen(),
//           // '/vocher': (context) => VoucherScreen(),
//           // '/payment': (context) => PaymentScreen()
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Screens
import '/screens/forgot_password.dart';
import '/screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/onboarding1.dart';
import 'screens/download_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved.dart';
// import 'screens/voucher_screen.dart';
// import 'screens/payment_screen.dart';

// Providers
import 'providers/movie_provider.dart';

// Localization
import 'screens/app_localizations.dart';
import 'screens/language_provider.dart';
import 'screens/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  // Initialize language provider
  final languageProvider = LanguageProvider();
  await languageProvider.initLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'MovieVault',
          theme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF06041F), // Custom Black Pearl color
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,

          // Initialize routes
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/onboarding': (context) => OnboardingScreen(),
            '/signup': (context) => SignUpScreen(),
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/forgot': (context) => ForgotPasswordScreen(),
            '/downloads': (context) => DownloadsPage(),
            '/profile': (context) => ProfileScreen(),
            '/saved': (context) => SavedMoviesScreen(),
            '/settings': (context) => SettingScreen(),
            // '/vocher': (context) => VoucherScreen(),
            // '/payment': (context) => PaymentScreen()
          },

          // Localization configuration
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'), // English
            Locale('de'), // German
            Locale('hi'), // Hindi
            Locale('id'), // Indonesian
            Locale('it'), // Italian
            Locale('ja'), // Japanese
            Locale('ko'), // Korean
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:firebase_core/firebase_core.dart';

// // Screens
// import 'screens/home_screen.dart';
// import 'screens/movie_detail_screen.dart';
// import 'screens/splash_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/signup_screen.dart';
// import 'screens/forgot_password.dart';
// import 'screens/onboarding1.dart';
// import 'screens/download_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/saved.dart';
// import 'screens/settings.dart';
// // import 'screens/voucher_screen.dart';
// // import 'screens/payment_screen.dart';

// // Providers
// import 'providers/movie_provider.dart';

// // Localization
// import 'screens/app_localizations.dart';
// import 'screens/language_provider.dart';

// // Firebase configuration
// import 'screens/firebase_options.dart'; // This file will be generated by FlutterFire CLI

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     // Initialize Firebase
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );

//     // Load environment variables
//     await dotenv.load(fileName: "assets/.env").catchError((error) {
//       print("Error loading .env file: $error");
//       // Continue even if .env fails to load
//     });

//     // Initialize language provider
//     final languageProvider = LanguageProvider();
//     await languageProvider.initLocale();

//     runApp(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => MovieProvider()),
//           ChangeNotifierProvider.value(value: languageProvider),
//         ],
//         child: const MyApp(),
//       ),
//     );
//   } catch (e) {
//     print("Error during initialization: $e");
//     // Fallback to basic app if initialization fails
//     runApp(const FallbackApp());
//   }
// }

// class FallbackApp extends StatelessWidget {
//   const FallbackApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MovieVault',
//       theme: ThemeData.dark(),
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Loading Failed',
//                 style: TextStyle(fontSize: 24),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   main(); // Try to reinitialize the app
//                 },
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LanguageProvider>(
//       builder: (context, languageProvider, child) {
//         return MaterialApp(
//           title: 'MovieVault',
//           theme: ThemeData.dark().copyWith(
//             primaryColor: const Color(0xFF06041F), // Custom Black Pearl color
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//           ),
//           debugShowCheckedModeBanner: false,

//           // Initialize routes
//           initialRoute: '/',
//           routes: {
//             '/': (context) => SplashScreen(),
//             '/onboarding': (context) => OnboardingScreen(),
//             '/signup': (context) => SignUpScreen(),
//             '/login': (context) => LoginScreen(),
//             '/home': (context) => HomeScreen(),
//             '/forgot': (context) => ForgotPasswordScreen(),
//             '/downloads': (context) => DownloadsPage(),
//             '/profile': (context) => ProfileScreen(),
//             '/saved': (context) => SavedMoviesScreen(),
//             '/settings': (context) => SettingScreen(),
//             // '/vocher': (context) => VoucherScreen(),
//             // '/payment': (context) => PaymentScreen()
//           },

//           // Fallback route handler for unknown routes
//           onUnknownRoute: (settings) {
//             return MaterialPageRoute(
//               builder: (ctx) => Scaffold(
//                 body: Center(
//                   child: Text('Route not found: ${settings.name}'),
//                 ),
//               ),
//             );
//           },

//           // Localization configuration
//           locale: languageProvider.locale,
//           supportedLocales: const [
//             Locale('en'), // English
//             Locale('de'), // German
//             Locale('hi'), // Hindi
//             Locale('id'), // Indonesian
//             Locale('it'), // Italian
//             Locale('ja'), // Japanese
//             Locale('ko'), // Korean
//           ],
//           localizationsDelegates: const [
//             AppLocalizations.delegate,
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//         );
//       },
//     );
//   }
// }
