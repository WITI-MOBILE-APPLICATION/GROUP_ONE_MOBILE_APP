// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// // Model class for saved movies
// class SavedMovie {
//   final int id;
//   final String title;
//   final String posterPath;
//   final String genres;
//   final DateTime savedDate;

//   SavedMovie({
//     required this.id,
//     required this.title,
//     required this.posterPath,
//     required this.genres,
//     required this.savedDate,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'posterPath': posterPath,
//       'genres': genres,
//       'savedDate': savedDate.toIso8601String(),
//     };
//   }

//   factory SavedMovie.fromJson(Map<String, dynamic> json) {
//     return SavedMovie(
//       id: json['id'],
//       title: json['title'],
//       posterPath: json['posterPath'],
//       genres: json['genres'] ?? '',
//       savedDate: DateTime.parse(json['savedDate']),
//     );
//   }
// }

// // Saved Movies Screen
// class SavedMoviesScreen extends StatefulWidget {
//   const SavedMoviesScreen({Key? key}) : super(key: key);

//   @override
//   _SavedMoviesScreenState createState() => _SavedMoviesScreenState();
// }

// class _SavedMoviesScreenState extends State<SavedMoviesScreen> {
//   List<SavedMovie> savedMovies = [];
//   bool isLoading = true;

//   // Image base URL for TMDB API
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedMovies();
//   }

//   Future<void> _loadSavedMovies() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];

//       setState(() {
//         savedMovies = savedMoviesJson
//             .map((json) => SavedMovie.fromJson(jsonDecode(json)))
//             .toList();
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading saved movies: ${e.toString()}');
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading saved movies: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _removeSavedMovie(int movieId) async {
//     bool confirmed = await _showRemoveConfirmationDialog(context);

//     if (confirmed) {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();

//         // Remove from local state
//         setState(() {
//           savedMovies.removeWhere((movie) => movie.id == movieId);
//         });

//         // Update SharedPreferences
//         List<String> updatedMoviesJson =
//             savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

//         await prefs.setStringList('saved_movies', updatedMoviesJson);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Movie removed from saved list',
//                 style: TextStyle(color: Colors.white)),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error removing movie: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               backgroundColor: Color(0xFF2D2C3E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFFB800),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Icon(
//                         Icons.bookmark_remove,
//                         color: Color(0xFF2D2C3E),
//                         size: 28,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Remove from Saved?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'This movie will be removed from your saved collection.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         minimumSize: Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(false);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         minimumSize: Size(double.infinity, 48),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: Text(
//                         'Remove',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ) ??
//         false;
//   }

//   // Helper method to get the correct image URL
//   String getImageUrl(String posterPath) {
//     if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
//       return posterPath;
//     } else if (posterPath.startsWith('/')) {
//       return imageBaseUrl + posterPath;
//     } else {
//       return imageBaseUrl + '/' + posterPath;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0F0E17),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1E1C3A),
//         elevation: 0,
//         title: Text(
//           'Saved',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Functionality to edit saved movies list
//             },
//             child: Text(
//               'Delete',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.blue))
//           : savedMovies.isEmpty
//               ? _buildEmptyState()
//               : _buildSavedMoviesList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.bookmark_border_rounded,
//             size: 80,
//             color: Colors.grey[600],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No Saved Movies Yet',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Movies you save will appear here',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSavedMoviesList() {
//     return GridView.builder(
//       padding: EdgeInsets.all(16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.7,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: savedMovies.length,
//       itemBuilder: (context, index) {
//         final movie = savedMovies[index];
//         return Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Color(0xFF1A1A2A),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Movie poster
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(12)),
//                       child: movie.posterPath.isNotEmpty
//                           ? Image.network(
//                               getImageUrl(movie.posterPath),
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   color: Colors.grey[800],
//                                   child: Icon(
//                                     Icons.movie,
//                                     color: Colors.white,
//                                     size: 50,
//                                   ),
//                                 );
//                               },
//                             )
//                           : Container(
//                               color: Colors.grey[800],
//                               child: Icon(
//                                 Icons.movie,
//                                 color: Colors.white,
//                                 size: 50,
//                               ),
//                             ),
//                     ),
//                   ),
//                   // Movie title and watch button
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           movie.title,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           movie.genres,
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 12,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         SizedBox(height: 8),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             minimumSize: Size(double.infinity, 30),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             padding: EdgeInsets.zero,
//                           ),
//                           onPressed: () {
//                             // Functionality to watch the movie
//                           },
//                           child: Text(
//                             'Watch now',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // More options button
//             Positioned(
//               top: 8,
//               right: 8,
//               child: IconButton(
//                 icon: Icon(Icons.more_vert, color: Colors.white),
//                 onPressed: () {
//                   _showOptionsBottomSheet(context, movie);
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showOptionsBottomSheet(BuildContext context, SavedMovie movie) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Color(0xFF1A1A2A),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.play_arrow, color: Colors.white),
//                 title: Text('Play', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Add play functionality
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.bookmark, color: Colors.white),
//                 title: Text('Saved', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading:
//                     Icon(Icons.bookmark_remove_outlined, color: Colors.red),
//                 title: Text('Remove from Saved',
//                     style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _removeSavedMovie(movie.id);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // Extensions for the MovieDetailScreen to add the save functionality
// // extension MovieDetailExtensions on MovieDetailScreen {
// //   Future<void> saveMovie(dynamic movie) async {
// //     try {
// //       final SharedPreferences prefs = await SharedPreferences.getInstance();

// //       // Get current saved movies
// //       List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];
// //       List<SavedMovie> savedMovies = savedMoviesJson
// //           .map((json) => SavedMovie.fromJson(jsonDecode(json)))
// //           .toList();

// //       // Check if the movie is already saved
// //       bool isAlreadySaved =
// //           savedMovies.any((savedMovie) => savedMovie.id == movie['id']);

// //       if (isAlreadySaved) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Movie already saved',
// //                 style: TextStyle(color: Colors.white)),
// //             backgroundColor: Colors.blue,
// //           ),
// //         );
// //         return;
// //       }

// //       // Create new SavedMovie object
// //       SavedMovie newSavedMovie = SavedMovie(
// //         id: movie['id'],
// //         title: movie['title'] ?? 'Unknown',
// //         posterPath: movie['poster_path'] ?? '',
// //         genres: movie['genre_ids'] != null ? 'Action, Adventure' : 'Unknown',
// //         savedDate: DateTime.now(),
// //       );

// //       // Add to saved movies list
// //       savedMovies.add(newSavedMovie);

// //       // Save updated list
// //       List<String> updatedSavedMoviesJson =
// //           savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

// //       await prefs.setStringList('saved_movies', updatedSavedMoviesJson);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Movie saved successfully',
// //               style: TextStyle(color: Colors.white)),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('Error saving movie: ${e.toString()}'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// // }

// // Modification for MovieDetailScreen to add Save button
// // This will need to be added to your movie_detail_screen.dart file
// /*
// Widget _buildActionsRow() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: [
//       _buildActionButton(
//         icon: Icons.play_arrow,
//         label: 'Play',
//         onTap: () {
//           // Play movie functionality
//         },
//       ),
//       _buildActionButton(
//         icon: Icons.bookmark_add_outlined,
//         label: 'Save',
//         onTap: () {
//           saveMovie(widget.movie);
//         },
//       ),
//       _buildActionButton(
//         icon: Icons.download,
//         label: 'Download',
//         onTap: () {
//           // Download movie functionality
//         },
//       ),
//     ],
//   );
// }
// */

// // Updated HomeScreen _onItemTapped method to navigate to SavedMoviesScreen
// /*
// void _onItemTapped(int index) {
//   if (index == 1) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SearchScreen(apiKey: apiKey),
//       ),
//     );
//   } else if (index == 2) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SavedMoviesScreen()),
//     );
//   } else if (index == 3) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const DownloadsPage()),
//     );
//   } else if (index == 4) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ProfileScreen()),
//     );
//   } else {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
// }
// */
// @dart=2.17
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'search_screen.dart';
// import 'download_screen.dart';
// import 'profile_screen.dart';

// // Model class for saved movies
// class SavedMovie {
//   final int id;
//   final String title;
//   final String posterPath;
//   final String genres;
//   final String description; // Added description field
//   final DateTime savedDate;

//   SavedMovie({
//     required this.id,
//     required this.title,
//     required this.posterPath,
//     required this.genres,
//     this.description = '', // Default empty description
//     required this.savedDate,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'posterPath': posterPath,
//       'genres': genres,
//       'description': description,
//       'savedDate': savedDate.toIso8601String(),
//     };
//   }

//   factory SavedMovie.fromJson(Map<String, dynamic> json) {
//     return SavedMovie(
//       id: json['id'],
//       title: json['title'],
//       posterPath: json['posterPath'],
//       genres: json['genres'] ?? '',
//       description: json['description'] ?? '',
//       savedDate: DateTime.parse(json['savedDate']),
//     );
//   }
// }

// // Saved Movies Screen
// class SavedMoviesScreen extends StatefulWidget {
//   const SavedMoviesScreen({Key? key}) : super(key: key);

//   @override
//   _SavedMoviesScreenState createState() => _SavedMoviesScreenState();
// }

// class _SavedMoviesScreenState extends State<SavedMoviesScreen> {
//   List<SavedMovie> savedMovies = [];
//   bool isLoading = true;
//   int _selectedIndex = 2; // Saved tab is selected by default (index 2)

//   // Image base URL for TMDB API
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedMovies();
//   }

//   Future<void> _loadSavedMovies() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];

//       setState(() {
//         savedMovies = savedMoviesJson
//             .map((json) => SavedMovie.fromJson(jsonDecode(json)))
//             .toList();
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading saved movies: ${e.toString()}');
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading saved movies: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _removeSavedMovie(int movieId) async {
//     bool confirmed = await _showRemoveConfirmationDialog(context);

//     if (confirmed) {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();

//         // Remove from local state
//         setState(() {
//           savedMovies.removeWhere((movie) => movie.id == movieId);
//         });

//         // Update SharedPreferences
//         List<String> updatedMoviesJson =
//             savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

//         await prefs.setStringList('saved_movies', updatedMoviesJson);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Movie removed from saved list',
//                 style: TextStyle(color: Colors.white)),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error removing movie: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               backgroundColor: Color(0xFF2D2C3E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Color(0xFFFFB800),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Icon(
//                         Icons.bookmark_remove,
//                         color: Color(0xFF2D2C3E),
//                         size: 28,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Remove from Saved?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'This movie will be removed from your saved collection.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         minimumSize: Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(false);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextButton(
//                       style: TextButton.styleFrom(
//                         minimumSize: Size(double.infinity, 48),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: Text(
//                         'Remove',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ) ??
//         false;
//   }

//   // Helper method to get the correct image URL
//   String getImageUrl(String posterPath) {
//     if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
//       return posterPath;
//     } else if (posterPath.startsWith('/')) {
//       return imageBaseUrl + posterPath;
//     } else {
//       return imageBaseUrl + '/' + posterPath;
//     }
//   }

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) {
//       return; // Do nothing if tapping the current tab
//     }

//     if (index == 0) {
//       Navigator.of(context).pop(); // Go back to Home screen
//     } else if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               SearchScreen(apiKey: 'ab0608ff77e9b69c9583e1e673f95115'),
//         ),
//       );
//     } else if (index == 3) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const DownloadsPage()),
//       );
//     } else if (index == 4) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ProfileScreen()),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0F0E17),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1E1C3A),
//         elevation: 0,
//         title: Text(
//           'Saved',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Functionality to edit saved movies list
//             },
//             child: Text(
//               'Delete',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//         centerTitle: true,
//       ),
//       bottomNavigationBar: Container(
//         color: const Color(0xFF06041F),
//         child: BottomNavigationBar(
//           backgroundColor: const Color(0xFF06041F),
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           elevation: 0,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
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
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.blue))
//           : savedMovies.isEmpty
//               ? _buildEmptyState()
//               : _buildSavedMoviesList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.bookmark_border_rounded,
//             size: 80,
//             color: Colors.grey[600],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No Saved Movies Yet',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Movies you save will appear here',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey[400],
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSavedMoviesList() {
//     // New list-based layout matching the image
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: savedMovies.length,
//       itemBuilder: (context, index) {
//         final movie = savedMovies[index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 16),
//           height: 140, // Increased height to accommodate description
//           decoration: BoxDecoration(
//             color: Color(0xFF1A1A2A),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               // Movie poster (left side)
//               ClipRRect(
//                 borderRadius:
//                     BorderRadius.horizontal(left: Radius.circular(12)),
//                 child: movie.posterPath.isNotEmpty
//                     ? Image.network(
//                         getImageUrl(movie.posterPath),
//                         width: 95,
//                         height: 140,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             width: 95,
//                             height: 140,
//                             color: Colors.grey[800],
//                             child: Icon(
//                               Icons.movie,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           );
//                         },
//                       )
//                     : Container(
//                         width: 95,
//                         height: 140,
//                         color: Colors.grey[800],
//                         child: Icon(
//                           Icons.movie,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ),
//               ),
//               // Movie info (middle)
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         movie.title,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       // Description text
//                       Text(
//                         movie.description.isNotEmpty
//                             ? movie.description
//                             : 'The Winter Soldier', // Placeholder for the screenshot
//                         style: TextStyle(
//                           color: Colors.white70,
//                           fontSize: 14,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         movie.genres,
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 13,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 12),
//                       // Watch now button
//                       SizedBox(
//                         height: 36,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18),
//                             ),
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                           ),
//                           onPressed: () {
//                             // Functionality to watch the movie
//                           },
//                           child: Text(
//                             'Watch now',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // More options button (right side)
//               IconButton(
//                 icon: Icon(Icons.more_vert, color: Colors.white),
//                 onPressed: () {
//                   _showOptionsBottomSheet(context, movie);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showOptionsBottomSheet(BuildContext context, SavedMovie movie) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Color(0xFF1A1A2A),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.play_arrow, color: Colors.white),
//                 title: Text('Play', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Add play functionality
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.bookmark, color: Colors.white),
//                 title: Text('Saved', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading:
//                     Icon(Icons.bookmark_remove_outlined, color: Colors.red),
//                 title: Text('Remove from Saved',
//                     style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _removeSavedMovie(movie.id);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // Extension for the MovieDetailScreen to add the save functionality
// // You'll need to add this to your movie_detail_screen.dart file
// extension MovieDetailExtensions on dynamic {
//   Future<void> saveMovie(dynamic movie) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();

//       // Get current saved movies
//       List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];
//       List<SavedMovie> savedMovies = savedMoviesJson
//           .map((json) => SavedMovie.fromJson(jsonDecode(json)))
//           .toList();

//       // Check if the movie is already saved
//       bool isAlreadySaved =
//           savedMovies.any((savedMovie) => savedMovie.id == movie['id']);

//       if (isAlreadySaved) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Movie already saved',
//                 style: TextStyle(color: Colors.white)),
//             backgroundColor: Colors.blue,
//           ),
//         );
//         return;
//       }

//       // Create new SavedMovie object with description
//       SavedMovie newSavedMovie = SavedMovie(
//         id: movie['id'],
//         title: movie['title'] ?? 'Unknown',
//         posterPath: movie['poster_path'] ?? '',
//         description: movie['subtitle'] ??
//             movie['tagline'] ??
//             '', // Use subtitle or tagline for description
//         genres: movie['genre_ids'] != null ? 'Action, Adventure' : 'Unknown',
//         savedDate: DateTime.now(),
//       );

//       // Add to saved movies list
//       savedMovies.add(newSavedMovie);

//       // Save updated list
//       List<String> updatedSavedMoviesJson =
//           savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

//       await prefs.setStringList('saved_movies', updatedSavedMoviesJson);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Movie saved successfully',
//               style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error saving movie: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'search_screen.dart';
import 'download_screen.dart';
import 'profile_screen.dart';

// Model class for saved movies
class SavedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String genres;
  final String description;
  final DateTime savedDate;

  SavedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.genres,
    this.description = '',
    required this.savedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'genres': genres,
      'description': description,
      'savedDate': savedDate.toIso8601String(),
    };
  }

  factory SavedMovie.fromJson(Map<String, dynamic> json) {
    return SavedMovie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      genres: json['genres'] ?? '',
      description: json['description'] ?? '',
      savedDate: DateTime.parse(json['savedDate']),
    );
  }
}

// Saved Movies Screen
class SavedMoviesScreen extends StatefulWidget {
  const SavedMoviesScreen({Key? key}) : super(key: key);

  @override
  _SavedMoviesScreenState createState() => _SavedMoviesScreenState();
}

class _SavedMoviesScreenState extends State<SavedMoviesScreen> {
  List<SavedMovie> savedMovies = [];
  bool isLoading = true;
  int _selectedIndex = 2; // Saved tab is selected by default (index 2)
  YoutubePlayerController? _moviePlayerController;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  final String tmdbApiKey = 'ab0608ff77e9b69c9583e1e673f95115';
  final String youtubeApiKey =
      'AIzaSyC-61DxvoQjn-zUWKJ8n2bSjqeusthmMCg'; // Replace with your YouTube API key

  @override
  void initState() {
    super.initState();
    _loadSavedMovies();
  }

  @override
  void dispose() {
    _moviePlayerController?.dispose();
    super.dispose();
  }

  Future<void> _loadSavedMovies() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];

      setState(() {
        savedMovies = savedMoviesJson
            .map((json) => SavedMovie.fromJson(jsonDecode(json)))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading saved movies: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading saved movies: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeSavedMovie(int movieId) async {
    bool confirmed = await _showRemoveConfirmationDialog(context);

    if (confirmed) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        setState(() {
          savedMovies.removeWhere((movie) => movie.id == movieId);
        });

        List<String> updatedMoviesJson =
            savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

        await prefs.setStringList('saved_movies', updatedMoviesJson);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Movie removed from saved list',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing movie: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Color(0xFF2D2C3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFB800),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.bookmark_remove,
                        color: Color(0xFF2D2C3E),
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Remove from Saved?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This movie will be removed from your saved collection.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  String getImageUrl(String posterPath) {
    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return posterPath;
    } else if (posterPath.startsWith('/')) {
      return imageBaseUrl + posterPath;
    } else {
      return imageBaseUrl + '/' + posterPath;
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return;
    }

    if (index == 0) {
      Navigator.of(context).pop();
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(apiKey: tmdbApiKey),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DownloadsPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _playMovie(SavedMovie movie) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
    );

    String? movieVideoKey = await _searchYouTubeForMovie(movie);
    Navigator.pop(context);

    if (movieVideoKey == null) {
      // Try fetching a trailer
      final trailerKey = await _fetchTrailer(movie.id);
      if (trailerKey != null) {
        movieVideoKey = trailerKey;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No full movie found. Playing trailer instead.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No full movie or trailer found on YouTube'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    _moviePlayerController = YoutubePlayerController(
      initialVideoId: movieVideoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  YoutubePlayer(
                    controller: _moviePlayerController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onReady: () {
                      _moviePlayerController!.play();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _moviePlayerController?.pause();
                      _moviePlayerController?.dispose();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _moviePlayerController?.pause();
      _moviePlayerController?.dispose();
    });
  }

  Future<String?> _searchYouTubeForMovie(SavedMovie movie) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedVideoId = prefs.getString('movie_${movie.id}');
      if (cachedVideoId != null) {
        return cachedVideoId;
      }

      // Fetch movie details from TMDb
      String releaseYear = '';
      String exactTitle = movie.title;
      final tmdbResponse = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie.id}?api_key=$tmdbApiKey'));
      if (tmdbResponse.statusCode == 200) {
        var tmdbData = json.decode(tmdbResponse.body);
        releaseYear = tmdbData['release_date']?.substring(0, 4) ?? '';
        exactTitle = tmdbData['title'] ?? movie.title;
      }

      // Construct search query
      final String query = Uri.encodeComponent(
          '$exactTitle full movie ${releaseYear.isNotEmpty ? releaseYear : ''}');
      final String url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&videoDuration=long&videoDefinition=high&maxResults=10&key=$youtubeApiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var results = json.decode(response.body);
        if (results['items'].isNotEmpty) {
          // Prefer videos with "full movie" or official content
          var video = results['items'].firstWhere(
            (item) =>
                item['snippet']['title'].toLowerCase().contains('full movie') ||
                item['snippet']['description']
                    .toLowerCase()
                    .contains('official'),
            orElse: () => results['items'][0], // Fallback to first result
          );
          String videoId = video['id']['videoId'];
          await prefs.setString('movie_${movie.id}', videoId);
          return videoId;
        }
      } else {
        print('YouTube API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching YouTube: $e');
    }
    return null;
  }

  Future<String?> _fetchTrailer(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$tmdbApiKey'));
      if (response.statusCode == 200) {
        var results = json.decode(response.body)['results'];
        var trailer = results.firstWhere(
          (video) => video['type'] == 'Trailer' || video['type'] == 'Teaser',
          orElse: () => null,
        );
        return trailer?['key'];
      }
    } catch (e) {
      print('Error fetching trailer: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3A),
        elevation: 0,
        title: Text(
          'Saved',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Functionality to edit saved movies list
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF06041F),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF06041F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : savedMovies.isEmpty
              ? _buildEmptyState()
              : _buildSavedMoviesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 80,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Text(
            'No Saved Movies Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Movies you save will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedMoviesList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: savedMovies.length,
      itemBuilder: (context, index) {
        final movie = savedMovies[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 140,
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
                child: movie.posterPath.isNotEmpty
                    ? Image.network(
                        getImageUrl(movie.posterPath),
                        width: 95,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 95,
                            height: 140,
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.movie,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 95,
                        height: 140,
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.movie,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        movie.description.isNotEmpty
                            ? movie.description
                            : 'No description available',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        movie.genres,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: () => _playMovie(movie),
                          child: Text(
                            'Watch now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  _showOptionsBottomSheet(context, movie);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsBottomSheet(BuildContext context, SavedMovie movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.play_arrow, color: Colors.white),
                title: Text('Play', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _playMovie(movie);
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark, color: Colors.white),
                title: Text('Saved', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.bookmark_remove_outlined, color: Colors.red),
                title: Text('Remove from Saved',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeSavedMovie(movie.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
