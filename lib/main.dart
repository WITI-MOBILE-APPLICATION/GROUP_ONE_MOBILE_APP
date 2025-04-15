import 'package:flutter/material.dart';
import 'package:my_app/screens/forgot_password.dart';
import 'package:my_app/screens/onboarding1.dart';
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
  const MyApp({super.key});

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
          primaryColor: const Color(0xFF06041F), // Custom Black Pearl color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Start with the splash screen
        routes: {
          '/': (context) => SplashScreen(),
          '/': (context) => OnboardingScreen(),
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

// main.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(const MovieApp());
// }

// class MovieApp extends StatelessWidget {
//   const MovieApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'JusPlay Movie App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         scaffoldBackgroundColor: const Color(0xFF0F1111),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white),
//         ),
//       ),
//       home: const HomeScreen(),
//       routes: {
//         '/details': (context) => const MovieDetailScreen(),
//       },
//     );
//   }
// }

// // API Service
// class TMDBApiService {
//   static const String baseUrl = "https://api.themoviedb.org/3";
//   static const String apiKey =
//       "ab0608ff77e9b69c9583e1e673f95115"; // Replace with your actual TMDB API key
//   static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

//   static Future<List<dynamic>> getTrendingMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load trending movies');
//     }
//   }

//   static Future<List<dynamic>> getPopularMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load popular movies');
//     }
//   }

//   static Future<List<dynamic>> getTopRatedMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load top rated movies');
//     }
//   }

//   static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
//     final response = await http.get(
//       Uri.parse(
//           '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,videos'),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
// }

// // Home Screen
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<dynamic>> trendingMovies;
//   late Future<List<dynamic>> popularMovies;
//   late Future<List<dynamic>> topRatedMovies;

//   @override
//   void initState() {
//     super.initState();
//     trendingMovies = TMDBApiService.getTrendingMovies();
//     popularMovies = TMDBApiService.getPopularMovies();
//     topRatedMovies = TMDBApiService.getTopRatedMovies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'JusPlay',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               // Search functionality
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.person, color: Colors.white),
//             onPressed: () {
//               // Profile functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTrendingMoviesCarousel(),
//             const SizedBox(height: 20),
//             _buildMovieSection("Popular Movies", popularMovies),
//             const SizedBox(height: 20),
//             _buildMovieSection("Top Rated Movies", topRatedMovies),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFF1A1C1E),
//         unselectedItemColor: Colors.grey,
//         selectedItemColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Explore',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.video_library),
//             label: 'Library',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.download),
//             label: 'Downloads',
//           ),
//         ],
//         currentIndex: 0,
//         onTap: (index) {
//           // Handle navigation
//         },
//       ),
//     );
//   }

//   Widget _buildTrendingMoviesCarousel() {
//     return FutureBuilder<List<dynamic>>(
//       future: trendingMovies,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: SizedBox(
//               height: 250,
//               child: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: SizedBox(
//               height: 250,
//               child: Center(
//                   child: Text('Error: ${snapshot.error}',
//                       style: const TextStyle(color: Colors.white))),
//             ),
//           );
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: SizedBox(
//               height: 250,
//               child: Center(
//                   child: Text('No trending movies available',
//                       style: TextStyle(color: Colors.white))),
//             ),
//           );
//         }

//         return SizedBox(
//           height: 250,
//           child: PageView.builder(
//             itemCount: snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
//             itemBuilder: (context, index) {
//               var movie = snapshot.data![index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     '/details',
//                     arguments: {
//                       'movieId': movie['id'],
//                       'title': movie['title'],
//                       'posterPath': movie['poster_path'],
//                       'backdropPath': movie['backdrop_path'],
//                       'overview': movie['overview'],
//                       'releaseDate': movie['release_date'],
//                       'voteAverage': movie['vote_average'],
//                     },
//                   );
//                 },
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     movie['backdrop_path'] != null
//                         ? Image.network(
//                             '${TMDBApiService.imageBaseUrl}${movie['backdrop_path']}',
//                             fit: BoxFit.cover,
//                           )
//                         : Container(color: Colors.grey[800]),
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.8),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 40,
//                       left: 20,
//                       right: 20,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             movie['title'] ?? 'No Title',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               const Icon(Icons.star,
//                                   color: Colors.amber, size: 16),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${(movie['vote_average'] ?? 0).toStringAsFixed(1)}/10',
//                                 style: const TextStyle(color: Colors.white70),
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 movie['release_date']?.substring(0, 4) ?? '',
//                                 style: const TextStyle(color: Colors.white70),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMovieSection(String title, Future<List<dynamic>> moviesFuture) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 220,
//           child: FutureBuilder<List<dynamic>>(
//             future: moviesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(
//                     child: Text('Error: ${snapshot.error}',
//                         style: const TextStyle(color: Colors.white)));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Center(
//                     child: Text('No $title available',
//                         style: const TextStyle(color: Colors.white)));
//               }

//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   var movie = snapshot.data![index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         '/details',
//                         arguments: {
//                           'movieId': movie['id'],
//                           'title': movie['title'],
//                           'posterPath': movie['poster_path'],
//                           'backdropPath': movie['backdrop_path'],
//                           'overview': movie['overview'],
//                           'releaseDate': movie['release_date'],
//                           'voteAverage': movie['vote_average'],
//                         },
//                       );
//                     },
//                     child: Container(
//                       width: 130,
//                       margin: const EdgeInsets.only(right: 12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: movie['poster_path'] != null
//                                 ? Image.network(
//                                     '${TMDBApiService.imageBaseUrl}${movie['poster_path']}',
//                                     height: 180,
//                                     width: 130,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Container(
//                                     height: 180,
//                                     width: 130,
//                                     color: Colors.grey[800],
//                                     child: const Center(
//                                       child: Icon(Icons.image_not_supported,
//                                           color: Colors.white70),
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             movie['title'] ?? 'No Title',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Movie Detail Screen
// class MovieDetailScreen extends StatefulWidget {
//   const MovieDetailScreen({Key? key}) : super(key: key);

//   @override
//   _MovieDetailScreenState createState() => _MovieDetailScreenState();
// }

// class _MovieDetailScreenState extends State<MovieDetailScreen> {
//   late Future<Map<String, dynamic>> movieDetails;
//   late int movieId;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     movieId = args['movieId'];
//     movieDetails = TMDBApiService.getMovieDetails(movieId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

//     return Scaffold(
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: movieDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error: ${snapshot.error}',
//                     style: const TextStyle(color: Colors.white)));
//           } else if (!snapshot.hasData) {
//             return const Center(
//                 child: Text('No movie details available',
//                     style: TextStyle(color: Colors.white)));
//           }

//           var movie = snapshot.data!;
//           List<dynamic> cast = movie['credits']['cast'] ?? [];
//           String genres = (movie['genres'] as List<dynamic>)
//               .map((genre) => genre['name'])
//               .join(', ');

//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 expandedHeight: 250,
//                 pinned: true,
//                 backgroundColor: Colors.transparent,
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       args['backdropPath'] != null
//                           ? Image.network(
//                               '${TMDBApiService.imageBaseUrl}${args['backdropPath']}',
//                               fit: BoxFit.cover,
//                             )
//                           : Container(color: Colors.grey[800]),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.8),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 leading: IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: args['posterPath'] != null
//                                 ? Image.network(
//                                     '${TMDBApiService.imageBaseUrl}${args['posterPath']}',
//                                     height: 180,
//                                     width: 120,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Container(
//                                     height: 180,
//                                     width: 120,
//                                     color: Colors.grey[800],
//                                     child: const Center(
//                                       child: Icon(Icons.image_not_supported,
//                                           color: Colors.white70),
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   args['title'] ?? 'No Title',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.star,
//                                         color: Colors.amber, size: 16),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       '${(args['voteAverage'] ?? 0).toStringAsFixed(1)}/10',
//                                       style: const TextStyle(
//                                           color: Colors.white70),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Release Date: ${args['releaseDate'] ?? 'Unknown'}',
//                                   style: const TextStyle(color: Colors.white70),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Genres: $genres',
//                                   style: const TextStyle(color: Colors.white70),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Play movie functionality
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: const [
//                                       Icon(Icons.play_arrow),
//                                       SizedBox(width: 4),
//                                       Text('Watch Now'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Synopsis',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         args['overview'] ?? 'No overview available.',
//                         style:
//                             const TextStyle(color: Colors.white70, height: 1.5),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'Cast',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 130,
//                         child: cast.isEmpty
//                             ? const Center(
//                                 child: Text('No cast information available',
//                                     style: TextStyle(color: Colors.white70)))
//                             : ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: cast.length > 10 ? 10 : cast.length,
//                                 itemBuilder: (context, index) {
//                                   var actor = cast[index];
//                                   return Container(
//                                     width: 80,
//                                     margin: const EdgeInsets.only(right: 8),
//                                     child: Column(
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(40),
//                                           child: actor['profile_path'] != null
//                                               ? Image.network(
//                                                   '${TMDBApiService.imageBaseUrl}${actor['profile_path']}',
//                                                   height: 80,
//                                                   width: 80,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Container(
//                                                   height: 80,
//                                                   width: 80,
//                                                   color: Colors.grey[800],
//                                                   child: const Center(
//                                                     child: Icon(Icons.person,
//                                                         color: Colors.white70),
//                                                   ),
//                                                 ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           actor['name'] ?? 'Unknown',
//                                           style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12),
//                                           textAlign: TextAlign.center,
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                       ),
//                       const SizedBox(height: 24),
//                       const Text(
//                         'You May Also Like',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       FutureBuilder<List<dynamic>>(
//                         future: TMDBApiService.getPopularMovies(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           } else if (snapshot.hasError || !snapshot.hasData) {
//                             return const SizedBox.shrink();
//                           }

//                           // Filter out the current movie
//                           var recommendations = snapshot.data!
//                               .where((m) => m['id'] != movieId)
//                               .take(5)
//                               .toList();

//                           return SizedBox(
//                             height: 220,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: recommendations.length,
//                               itemBuilder: (context, index) {
//                                 var movie = recommendations[index];
//                                 return GestureDetector(
//                                   onTap: () {
//                                     Navigator.pushReplacementNamed(
//                                       context,
//                                       '/details',
//                                       arguments: {
//                                         'movieId': movie['id'],
//                                         'title': movie['title'],
//                                         'posterPath': movie['poster_path'],
//                                         'backdropPath': movie['backdrop_path'],
//                                         'overview': movie['overview'],
//                                         'releaseDate': movie['release_date'],
//                                         'voteAverage': movie['vote_average'],
//                                       },
//                                     );
//                                   },
//                                   child: Container(
//                                     width: 130,
//                                     margin: const EdgeInsets.only(right: 12),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: movie['poster_path'] != null
//                                               ? Image.network(
//                                                   '${TMDBApiService.imageBaseUrl}${movie['poster_path']}',
//                                                   height: 180,
//                                                   width: 130,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Container(
//                                                   height: 180,
//                                                   width: 130,
//                                                   color: Colors.grey[800],
//                                                   child: const Center(
//                                                     child: Icon(
//                                                         Icons
//                                                             .image_not_supported,
//                                                         color: Colors.white70),
//                                                   ),
//                                                 ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           movie['title'] ?? 'No Title',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(const MovieApp());
// }

// class MovieApp extends StatelessWidget {
//   const MovieApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'JusPlay Movie App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.red,
//         scaffoldBackgroundColor: const Color(0xFFFF0033),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white),
//         ),
//       ),
//       home: const HomeScreen(),
//       routes: {
//         '/details': (context) => const MovieDetailScreen(),
//         '/downloads': (context) => const DownloadsScreen(),
//       },
//     );
//   }
// }

// // API Service
// class TMDBApiService {
//   static const String baseUrl = "https://api.themoviedb.org/3";
//   static const String apiKey = "ab0608ff77e9b69c9583e1e673f95115";
//   static const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

//   static Future<List<dynamic>> getTrendingMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/trending/movie/week?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load trending movies');
//     }
//   }

//   static Future<List<dynamic>> getPopularMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load popular movies');
//     }
//   }

//   static Future<List<dynamic>> getTopRatedMovies() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = json.decode(response.statusCode.toString() != "404"
//           ? response.body
//           : '{"results":[]}');
//       return data['results'];
//     } else {
//       throw Exception('Failed to load top rated movies');
//     }
//   }

//   static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
//     final response = await http.get(
//       Uri.parse(
//           '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,videos'),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load movie details');
//     }
//   }
// }

// // Home Screen
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<dynamic>> trendingMovies;
//   late Future<List<dynamic>> popularMovies;
//   late Future<List<dynamic>> topRatedMovies;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     trendingMovies = TMDBApiService.getTrendingMovies();
//     popularMovies = TMDBApiService.getPopularMovies();
//     topRatedMovies = TMDBApiService.getTopRatedMovies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFF0033),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeroMovieSection(),
//               const SizedBox(height: 20),
//               _buildCategoriesSection(),
//               const SizedBox(height: 20),
//               _buildMovieSection("Most Popular", popularMovies),
//               const SizedBox(height: 20),
//               _buildMovieSection("Latest Movies", topRatedMovies),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         selectedItemColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bookmark),
//             label: 'Saved',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.download),
//             label: 'Downloads',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//           if (index == 3) {
//             Navigator.pushNamed(context, '/downloads');
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildHeroMovieSection() {
//     return FutureBuilder<List<dynamic>>(
//       future: trendingMovies,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SizedBox(
//             height: 300,
//             child:
//                 Center(child: CircularProgressIndicator(color: Colors.white)),
//           );
//         } else if (snapshot.hasError ||
//             !snapshot.hasData ||
//             snapshot.data!.isEmpty) {
//           return const SizedBox(
//             height: 300,
//             child: Center(
//                 child: Text('No movies available',
//                     style: TextStyle(color: Colors.white))),
//           );
//         }

//         var heroMovie = snapshot.data!.first;
//         return GestureDetector(
//           onTap: () {
//             Navigator.pushNamed(
//               context,
//               '/details',
//               arguments: {
//                 'movieId': heroMovie['id'],
//                 'title': heroMovie['title'],
//                 'posterPath': heroMovie['poster_path'],
//                 'backdropPath': heroMovie['backdrop_path'],
//                 'overview': heroMovie['overview'],
//                 'releaseDate': heroMovie['release_date'],
//                 'voteAverage': heroMovie['vote_average'],
//               },
//             );
//           },
//           child: Container(
//             height: 300,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(
//                   '${TMDBApiService.imageBaseUrl}${heroMovie['poster_path']}',
//                 ),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Gradient overlay
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.8),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Title & Categories at bottom
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Categories',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           _buildCategoryPill('Action', isSelected: true),
//                           const SizedBox(width: 8),
//                           _buildCategoryPill('Comedy'),
//                           const SizedBox(width: 8),
//                           _buildCategoryPill('Romance'),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Most Popular',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'See all',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                           // Movie progress indicator
//                           Row(
//                             children: [
//                               Container(
//                                 width: 16,
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                               const SizedBox(width: 2),
//                               Container(
//                                 width: 8,
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                               const SizedBox(width: 2),
//                               Container(
//                                 width: 8,
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.5),
//                                   borderRadius: BorderRadius.circular(2),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryPill(String text, {bool isSelected = false}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.red : Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.white,
//           fontSize: 12,
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoriesSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Categories',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildCategoryPill('Action', isSelected: true),
//               _buildCategoryPill('Comedy'),
//               _buildCategoryPill('Romance'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMovieSection(String title, Future<List<dynamic>> moviesFuture) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 'See all',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 180,
//           child: FutureBuilder<List<dynamic>>(
//             future: moviesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Colors.white));
//               } else if (snapshot.hasError ||
//                   !snapshot.hasData ||
//                   snapshot.data!.isEmpty) {
//                 return const Center(
//                     child: Text('No movies available',
//                         style: TextStyle(color: Colors.white)));
//               }

//               return ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(left: 20),
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   var movie = snapshot.data![index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(
//                         context,
//                         '/details',
//                         arguments: {
//                           'movieId': movie['id'],
//                           'title': movie['title'],
//                           'posterPath': movie['poster_path'],
//                           'backdropPath': movie['backdrop_path'],
//                           'overview': movie['overview'],
//                           'releaseDate': movie['release_date'],
//                           'voteAverage': movie['vote_average'],
//                         },
//                       );
//                     },
//                     child: Container(
//                       width: 120,
//                       margin: const EdgeInsets.only(right: 12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: movie['poster_path'] != null
//                                 ? Image.network(
//                                     '${TMDBApiService.imageBaseUrl}${movie['poster_path']}',
//                                     height: 160,
//                                     width: 120,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Container(
//                                     height: 160,
//                                     width: 120,
//                                     color: Colors.grey[800],
//                                     child: const Center(
//                                       child: Icon(Icons.image_not_supported,
//                                           color: Colors.white70),
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             movie['title'] ?? 'No Title',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Movie Detail Screen
// class MovieDetailScreen extends StatefulWidget {
//   const MovieDetailScreen({Key? key}) : super(key: key);

//   @override
//   _MovieDetailScreenState createState() => _MovieDetailScreenState();
// }

// class _MovieDetailScreenState extends State<MovieDetailScreen> {
//   late Future<Map<String, dynamic>> movieDetails;
//   late int movieId;
//   int _selectedTabIndex = 0;
//   final List<String> _tabs = ['Episode', 'Similar', 'About'];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//     movieId = args['movieId'];
//     movieDetails = TMDBApiService.getMovieDetails(movieId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFF0033),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Backdrop image with gradient overlay
//               Stack(
//                 children: [
//                   Container(
//                     height: 300,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                           '${TMDBApiService.imageBaseUrl}${args['backdropPath']}',
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   // Gradient overlay
//                   Container(
//                     height: 300,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.8),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Back button and movie info
//                   Positioned(
//                     top: 16,
//                     left: 16,
//                     child: GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Movie Title
//                   Positioned(
//                     bottom: 16,
//                     left: 16,
//                     right: 16,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Disney's ${args['title'] ?? 'Movie Title'}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Text(
//                               '${args['releaseDate']?.substring(0, 4) ?? ''} • ',
//                               style: const TextStyle(color: Colors.white70),
//                             ),
//                             const Text(
//                               'Adventure, Comedy • 2h 8m',
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Action buttons
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.play_arrow),
//                         label: const Text('Play'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     IconButton(
//                       icon: const Icon(Icons.download_outlined,
//                           color: Colors.white),
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/downloads');
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // Movie description
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   'Aladdin, a street boy who falls in love with a princess. With differences in caste and wealth, Aladdin tries to find a way to become a prince.',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 14,
//                     height: 1.5,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     'Read more',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Tabs
//               DefaultTabController(
//                 length: _tabs.length,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         children: List.generate(
//                           _tabs.length,
//                           (index) => Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedTabIndex = index;
//                                 });
//                               },
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 12),
//                                 decoration: BoxDecoration(
//                                   color: _selectedTabIndex == index
//                                       ? Colors.red
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(25),
//                                 ),
//                                 child: Text(
//                                   _tabs[index],
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: _selectedTabIndex == index
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.5),
//                                     fontWeight: _selectedTabIndex == index
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Trailer section
//                     _selectedTabIndex == 0
//                         ? _buildTrailerSection()
//                         : _selectedTabIndex == 1
//                             ? _buildSimilarSection()
//                             : _buildAboutSection(args),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTrailerSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Trailer',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.black.withOpacity(0.3),
//               image: const DecorationImage(
//                 image: NetworkImage(
//                   'https://image.tmdb.org/t/p/w500/aiadL3YyJlA1ck4oWbRoNtPBEKX.jpg',
//                 ),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 36,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Aladdin, a street boy who falls in love with a princess. With differences in caste and wealth, Aladdin tries to find a way to become a prince.',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.schedule, color: Colors.white, size: 16),
//                     const SizedBox(width: 4),
//                     Text(
//                       '2:45',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimilarSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Similar Movies',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           FutureBuilder<List<dynamic>>(
//             future: TMDBApiService.getPopularMovies(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Colors.white));
//               } else if (snapshot.hasError ||
//                   !snapshot.hasData ||
//                   snapshot.data!.isEmpty) {
//                 return const Center(
//                     child: Text('No similar movies available',
//                         style: TextStyle(color: Colors.white)));
//               }

//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.7,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   var movie = snapshot.data![index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacementNamed(
//                         context,
//                         '/details',
//                         arguments: {
//                           'movieId': movie['id'],
//                           'title': movie['title'],
//                           'posterPath': movie['poster_path'],
//                           'backdropPath': movie['backdrop_path'],
//                           'overview': movie['overview'],
//                           'releaseDate': movie['release_date'],
//                           'voteAverage': movie['vote_average'],
//                         },
//                       );
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         '${TMDBApiService.imageBaseUrl}${movie['poster_path']}',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAboutSection(Map<String, dynamic> args) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'About Movie',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             args['overview'] ?? 'No overview available.',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Release Date',
//                     style: TextStyle(
//                       color: Colors.white60,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'May 24, 2019',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(width: 40),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Director',
//                     style: TextStyle(
//                       color: Colors.white60,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Guy Ritchie',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Cast',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           FutureBuilder<Map<String, dynamic>>(
//             future: movieDetails,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                     child: CircularProgressIndicator(color: Colors.white));
//               } else if (snapshot.hasError || !snapshot.hasData) {
//                 return const Center(
//                     child: Text('No cast information available',
//                         style: TextStyle(color: Colors.white)));
//               }

//               var movie = snapshot.data!;
//               List<dynamic> cast = movie['credits']['cast'] ?? [];

//               return SizedBox(
//                 height: 120,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: cast.length > 5 ? 5 : cast.length,
//                   itemBuilder: (context, index) {
//                     var actor = cast[index];
//                     return Container(
//                       width: 80,
//                       margin: const EdgeInsets.only(right: 12),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(40),
//                             child: actor['profile_path'] != null
//                                 ? Image.network(
//                                     '${TMDBApiService.imageBaseUrl}${actor['profile_path']}',
//                                     height: 80,
//                                     width: 80,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Container(
//                                     height: 80,
//                                     width: 80,
//                                     color: Colors.grey[800],
//                                     child: const Icon(Icons.person,
//                                         color: Colors.white70),
//                                   ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             actor['name'] ?? 'Unknown',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Downloads Screen
// class DownloadsScreen extends StatelessWidget {
//   const DownloadsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFF0033),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Downloads',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.download_done_rounded,
//               size: 100,
//               color: Colors.white54,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'No downloads yet',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Your downloaded movies will appear here',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.7),
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//               ),
//               child: const Text('Browse Movies'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

