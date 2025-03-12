import 'package:flutter/material.dart';
import 'package:my_app/screens/forgot_password.dart';
import 'package:my_app/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'providers/movie_provider.dart';
import 'screens/forgot_password.dart';

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
          // Login screen route
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/forgot': (context) => ForgotPasswordScreen()
        },
      ),
    );
  }
}
