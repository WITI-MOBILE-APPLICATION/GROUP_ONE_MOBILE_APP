// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
//   final String trendingMoviesUrl =
//       'https://api.themoviedb.org/3/trending/movie/week';
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

//   List<dynamic>? trendingMovies;
//   List<dynamic> lastWatched = [];
//   List<dynamic> filteredMovies = [];
//   final List<String> categories = ['All', 'Actors', 'Comedy', 'Romance'];
//   String selectedCategory = 'All';

//   @override
//   void initState() {
//     super.initState();
//     fetchTrendingMovies();
//   }

//   Future<void> fetchTrendingMovies() async {
//     final response =
//         await http.get(Uri.parse('$trendingMoviesUrl?api_key=$apiKey'));

//     if (response.statusCode == 200) {
//       final results = json.decode(response.body)['results'];
//       setState(() {
//         trendingMovies = results;
//         filteredMovies = results; // Default: showing all movies
//       });
//     } else {
//       throw Exception('Failed to load trending movies');
//     }
//   }

//   void _addToLastWatched(dynamic movie) {
//     setState(() {
//       if (!lastWatched
//           .any((watchedMovie) => watchedMovie['id'] == movie['id'])) {
//         lastWatched.add(movie);
//       }
//     });
//   }

//   void _filterMovies(String category) {
//     setState(() {
//       selectedCategory = category;
//       if (category == 'All') {
//         filteredMovies = trendingMovies!;
//       } else {
//         filteredMovies = trendingMovies!.where((movie) {
//           final genres = movie['genre_ids'] as List<dynamic>;
//           switch (category) {
//             case 'Actors':
//               return genres.contains(18); // Drama
//             case 'Comedy':
//               return genres.contains(35); // Comedy
//             case 'Romance':
//               return genres.contains(10749); // Romance
//             default:
//               return true;
//           }
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF06041F),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xFF06041F),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.download), label: 'Downloads'),
//         ],
//       ),
//       body: trendingMovies == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Movie slider
//                     Container(
//                       height: 250,
//                       child: PageView.builder(
//                         itemCount: trendingMovies!.length > 5
//                             ? 5
//                             : trendingMovies!.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () =>
//                                 _addToLastWatched(trendingMovies![index]),
//                             child: Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 image: DecorationImage(
//                                   image: NetworkImage(
//                                       '$imageBaseUrl${trendingMovies![index]['poster_path']}'),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Categories filter
//                     const Text('Categories',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       height: 50,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: categories.length,
//                         itemBuilder: (context, index) {
//                           final category = categories[index];
//                           return GestureDetector(
//                             onTap: () => _filterMovies(category),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               margin: const EdgeInsets.only(right: 10),
//                               decoration: BoxDecoration(
//                                 color: selectedCategory == category
//                                     ? Colors.red
//                                     : Colors.grey[800],
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(category,
//                                   style: const TextStyle(color: Colors.white)),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Last watched
//                     const Text('Last watched',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: lastWatched.map((movie) {
//                           return GestureDetector(
//                             onTap: () => _showMovieDetails(context, movie),
//                             child: Container(
//                               width: 140,
//                               margin: const EdgeInsets.only(right: 10),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     child: Image.network(
//                                       '$imageBaseUrl${movie['poster_path']}',
//                                       height: 100,
//                                       width: 140,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Text(
//                                     movie['title'] ?? 'Unknown',
//                                     style: const TextStyle(color: Colors.white),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Filtered movies
//                     const Text('Filtered Movies',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                       ),
//                       itemCount: filteredMovies.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () =>
//                               _showMovieDetails(context, filteredMovies[index]),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: Image.network(
//                               '$imageBaseUrl${filteredMovies[index]['poster_path']}',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   void _showMovieDetails(BuildContext context, dynamic movie) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.black,
//           title: Text(
//             movie['title'] ?? 'Unknown',
//             style: const TextStyle(color: Colors.white),
//           ),
//           content: Text(
//             movie['overview'] ?? 'No description available.',
//             style: const TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Close', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'movie_detail_screen.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
//   final String trendingMoviesUrl =
//       'https://api.themoviedb.org/3/trending/movie/week';
//   final String popularMoviesUrl = 'https://api.themoviedb.org/3/movie/popular';
//   final String latestMoviesUrl =
//       'https://api.themoviedb.org/3/movie/now_playing'; // or '/movie/upcoming' for upcoming releases
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

//   List<dynamic>? trendingMovies;
//   List<dynamic>? popularMovies; // Separate list for popular movies
//   List<dynamic>? latestMovies; // Separate list for latest movies
//   List<dynamic> filteredMovies = [];
//   final List<String> categories = ['All', 'Action', 'Comedy', 'Romance'];
//   String selectedCategory = 'All';

//   late PageController _pageController;
//   int _currentPage = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     fetchTrendingMovies();
//     fetchPopularMovies(); // Fetch popular movies
//     fetchLatestMovies(); // Fetch latest movies
//     _pageController = PageController(initialPage: 0);
//     _startAutoSlide();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchTrendingMovies() async {
//     final response =
//         await http.get(Uri.parse('$trendingMoviesUrl?api_key=$apiKey'));
//     if (response.statusCode == 200) {
//       final results = json.decode(response.body)['results'];
//       setState(() {
//         trendingMovies = results;
//         filteredMovies = results; // Still used for category filtering
//       });
//     } else {
//       throw Exception('Failed to load trending movies');
//     }
//   }

//   Future<void> fetchPopularMovies() async {
//     final response =
//         await http.get(Uri.parse('$popularMoviesUrl?api_key=$apiKey'));
//     if (response.statusCode == 200) {
//       final results = json.decode(response.body)['results'];
//       setState(() {
//         popularMovies = results;
//       });
//     } else {
//       throw Exception('Failed to load popular movies');
//     }
//   }

//   Future<void> fetchLatestMovies() async {
//     final response =
//         await http.get(Uri.parse('$latestMoviesUrl?api_key=$apiKey'));
//     if (response.statusCode == 200) {
//       final results = json.decode(response.body)['results'];
//       setState(() {
//         latestMovies = results;
//       });
//     } else {
//       throw Exception('Failed to load latest movies');
//     }
//   }

//   void _filterMovies(String category) {
//     setState(() {
//       selectedCategory = category;
//       if (category == 'All') {
//         filteredMovies = trendingMovies!;
//       } else {
//         filteredMovies = trendingMovies!.where((movie) {
//           final genres = movie['genre_ids'] as List<dynamic>;
//           switch (category) {
//             case 'Action':
//               return genres.contains(28);
//             case 'Comedy':
//               return genres.contains(35);
//             case 'Romance':
//               return genres.contains(10749);
//             default:
//               return true;
//           }
//         }).toList();
//       }
//     });
//   }

//   void _navigateToMovieDetails(BuildContext context, dynamic movie) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MovieDetailScreen(movie: movie),
//       ),
//     );
//   }

//   void _startAutoSlide() {
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (trendingMovies != null && trendingMovies!.isNotEmpty) {
//         if (_currentPage <
//             (trendingMovies!.length > 5 ? 5 : trendingMovies!.length) - 1) {
//           _currentPage++;
//         } else {
//           _currentPage = 0;
//         }
//         _pageController.animateToPage(
//           _currentPage,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF06041F),
//       bottomNavigationBar: Container(
//         color: Color(0xFF06041F),
//         child: BottomNavigationBar(
//           backgroundColor: Color(0xFF06041F),
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//             BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.download), label: 'Downloads'),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ],
//         ),
//       ),
//       body: trendingMovies == null ||
//               popularMovies == null ||
//               latestMovies == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding:
//                   const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Featured Slider (unchanged)
//                   Container(
//                     height: 250,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: trendingMovies!.length > 5
//                           ? 5
//                           : trendingMovies!.length,
//                       itemBuilder: (context, index) {
//                         final movie = trendingMovies![index];
//                         return GestureDetector(
//                           onTap: () => _navigateToMovieDetails(context, movie),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16.0),
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                     '$imageBaseUrl${movie['backdrop_path'] ?? movie['poster_path']}'),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16.0),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.transparent,
//                                         Colors.black.withOpacity(0.7)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 20,
//                                   left: 20,
//                                   right: 20,
//                                   child: Text(
//                                     movie['title'] ?? 'Unknown',
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 10,
//                                   left: 0,
//                                   right: 0,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: List.generate(
//                                       5,
//                                       (dotIndex) => Container(
//                                         width: 8,
//                                         height: 8,
//                                         margin:
//                                             EdgeInsets.symmetric(horizontal: 2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: dotIndex == index
//                                               ? Colors.red
//                                               : Colors.grey.withOpacity(0.5),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentPage = index;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Categories Filter (unchanged)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Categories',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                       TextButton(
//                           onPressed: () {},
//                           child: const Text('See all',
//                               style:
//                                   TextStyle(color: Colors.grey, fontSize: 14))),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 40,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         final category = categories[index];
//                         return GestureDetector(
//                           onTap: () => _filterMovies(category),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 10),
//                             margin: const EdgeInsets.only(right: 10),
//                             decoration: BoxDecoration(
//                               color: selectedCategory == category
//                                   ? Colors.red
//                                   : Colors.grey[900],
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               category,
//                               style: TextStyle(
//                                   color: selectedCategory == category
//                                       ? Colors.white
//                                       : Colors.grey),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Most Popular section using popularMovies
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Most Popular',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                       TextButton(
//                           onPressed: () {},
//                           child: const Text('See all',
//                               style:
//                                   TextStyle(color: Colors.grey, fontSize: 14))),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount:
//                           popularMovies!.length > 5 ? 5 : popularMovies!.length,
//                       itemBuilder: (context, index) {
//                         final movie = popularMovies![index];
//                         return GestureDetector(
//                           onTap: () => _navigateToMovieDetails(context, movie),
//                           child: Container(
//                             width: 120,
//                             margin: const EdgeInsets.only(right: 12),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12.0),
//                               child: Image.network(
//                                 '$imageBaseUrl${movie['poster_path']}',
//                                 height: 150,
//                                 width: 120,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Latest Movies section using latestMovies
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Latest Movies',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold)),
//                       TextButton(
//                           onPressed: () {},
//                           child: const Text('See all',
//                               style:
//                                   TextStyle(color: Colors.grey, fontSize: 14))),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount:
//                           latestMovies!.length > 5 ? 5 : latestMovies!.length,
//                       itemBuilder: (context, index) {
//                         final movie = latestMovies![index];
//                         return GestureDetector(
//                           onTap: () => _navigateToMovieDetails(context, movie),
//                           child: Container(
//                             width: 120,
//                             margin: const EdgeInsets.only(right: 12),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12.0),
//                               child: Image.network(
//                                 '$imageBaseUrl${movie['poster_path']}',
//                                 height: 150,
//                                 width: 120,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'movie_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
  final String trendingMoviesUrl =
      'https://api.themoviedb.org/3/trending/movie/week';
  final String popularMoviesUrl = 'https://api.themoviedb.org/3/movie/popular';
  final String latestMoviesUrl = 'https://api.themoviedb.org/3/movie/upcoming';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  List<dynamic>? trendingMovies;
  List<dynamic>? popularMovies;
  List<dynamic>? latestMovies;
  List<dynamic> filteredMovies = [];
  final List<String> categories = ['All', 'Action', 'Comedy', 'Romance'];
  String selectedCategory = 'All';

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
    fetchPopularMovies();
    fetchLatestMovies();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchTrendingMovies() async {
    final response =
        await http.get(Uri.parse('$trendingMoviesUrl?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      setState(() {
        trendingMovies = results;
        filteredMovies = results;
      });
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<void> fetchPopularMovies() async {
    final response =
        await http.get(Uri.parse('$popularMoviesUrl?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      setState(() {
        popularMovies = results;
      });
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<void> fetchLatestMovies() async {
    final response =
        await http.get(Uri.parse('$latestMoviesUrl?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      setState(() {
        latestMovies = results;
        if (popularMovies != null) {
          latestMovies = latestMovies!
              .where((latest) => !popularMovies!
                  .any((popular) => popular['id'] == latest['id']))
              .toList();
        }
      });
    } else {
      throw Exception('Failed to load latest movies');
    }
  }

  void _filterMovies(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredMovies = trendingMovies!;
      } else {
        filteredMovies = trendingMovies!.where((movie) {
          final genres = movie['genre_ids'] as List<dynamic>;
          switch (category) {
            case 'Action':
              return genres.contains(28);
            case 'Comedy':
              return genres.contains(35);
            case 'Romance':
              return genres.contains(10749);
            default:
              return true;
          }
        }).toList();
      }
    });
  }

  void _navigateToMovieDetails(BuildContext context, dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
    );
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (trendingMovies != null && trendingMovies!.isNotEmpty) {
        if (_currentPage <
            (trendingMovies!.length > 5 ? 5 : trendingMovies!.length) - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen(apiKey: apiKey)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      bottomNavigationBar: Container(
        color: Color(0xFF06041F),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF06041F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: _selectedIndex, // Reflect the selected index
          onTap: _onItemTapped, // Link the tap handler
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: 'Downloads'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: trendingMovies == null ||
              popularMovies == null ||
              latestMovies == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Slider
                  Container(
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: trendingMovies!.length > 5
                          ? 5
                          : trendingMovies!.length,
                      itemBuilder: (context, index) {
                        final movie = trendingMovies![index];
                        return GestureDetector(
                          onTap: () => _navigateToMovieDetails(context, movie),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '$imageBaseUrl${movie['backdrop_path'] ?? movie['poster_path']}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7)
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Text(
                                    movie['title'] ?? 'Unknown',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      5,
                                      (dotIndex) => Container(
                                        width: 8,
                                        height: 8,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: dotIndex == index
                                              ? Colors.red
                                              : Colors.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Categories Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Categories',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {},
                          child: const Text('See all',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () => _filterMovies(category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: selectedCategory == category
                                  ? Colors.red
                                  : Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                  color: selectedCategory == category
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Most Popular section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Most Popular',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {},
                          child: const Text('See all',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          popularMovies!.length > 5 ? 5 : popularMovies!.length,
                      itemBuilder: (context, index) {
                        final movie = popularMovies![index];
                        return GestureDetector(
                          onTap: () => _navigateToMovieDetails(context, movie),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                '$imageBaseUrl${movie['poster_path']}',
                                height: 150,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Latest Movies section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Latest Movies',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: () {},
                          child: const Text('See all',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          latestMovies!.length > 5 ? 5 : latestMovies!.length,
                      itemBuilder: (context, index) {
                        final movie = latestMovies![index];
                        return GestureDetector(
                          onTap: () => _navigateToMovieDetails(context, movie),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                '$imageBaseUrl${movie['poster_path']}',
                                height: 150,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
