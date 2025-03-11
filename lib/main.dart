import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './services/movie_services.dart';
import 'providers/movie_provider.dart';
import 'screens/home_screen.dart';
import './screens/movie_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/profile_screen.dart';

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
        theme: ThemeData.dark().copyWith(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color.fromARGB(255, 24, 25, 26),
        ),
        debugShowCheckedModeBanner: false,
        // You can either use home directly:
        home: const ProfileScreen(),
        
        
      ),
    );
  }
}