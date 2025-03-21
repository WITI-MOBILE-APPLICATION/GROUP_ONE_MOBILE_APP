// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/download_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password.dart';
import 'services/download_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => DownloadServices()),
      ],
      child: MaterialApp(
        title: 'MovieVault',
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF06041F),
          scaffoldBackgroundColor: const Color(0xFF06041F),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/forgot': (context) => const ForgotPasswordScreen(),
          '/downloads': (context) => const DownloadsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/movie_detail') {
            final movie = settings.arguments as dynamic;
            return MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            );
          }
          return null;
        },
      ),
    );
  }
}