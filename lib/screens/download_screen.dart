// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class DownloadedMovie {
//   final int id;
//   final String title;
//   final String posterPath;
//   final String quality;
//   final DateTime downloadDate;
//   final String genres;
//   final String duration;

//   DownloadedMovie({
//     required this.id,
//     required this.title,
//     required this.posterPath,
//     required this.quality,
//     required this.downloadDate,
//     this.genres = '',
//     this.duration = '',
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'posterPath': posterPath,
//       'quality': quality,
//       'downloadDate': downloadDate.toIso8601String(),
//       'genres': genres,
//       'duration': duration,
//     };
//   }

//   factory DownloadedMovie.fromJson(Map<String, dynamic> json) {
//     return DownloadedMovie(
//       id: json['id'],
//       title: json['title'],
//       posterPath: json['posterPath'],
//       quality: json['quality'],
//       downloadDate: DateTime.parse(json['downloadDate']),
//       genres: json['genres'] ?? '',
//       duration: json['duration'] ?? '',
//     );
//   }
// }

// class DownloadsPage extends StatefulWidget {
//   const DownloadsPage({Key? key}) : super(key: key);

//   @override
//   _DownloadsPageState createState() => _DownloadsPageState();
// }

// class _DownloadsPageState extends State<DownloadsPage> {
//   List<DownloadedMovie> downloadedMovies = [];
//   bool isLoading = true;

//   // IMPORTANT: Update this to match your API's base URL for images
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

//   @override
//   void initState() {
//     super.initState();
//     _loadDownloads();
//   }

//   Future<void> _loadDownloads() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       List<String> downloadedMoviesJson =
//           prefs.getStringList('downloads') ?? [];

//       setState(() {
//         downloadedMovies = downloadedMoviesJson
//             .map((json) => DownloadedMovie.fromJson(jsonDecode(json)))
//             .toList();
//         isLoading = false;
//       });

//       // Debug print to check what data is being loaded
//       print('Loaded ${downloadedMovies.length} movies');
//       if (downloadedMovies.isNotEmpty) {
//         print('First movie poster path: ${downloadedMovies[0].posterPath}');
//       }
//     } catch (e) {
//       print('Error loading downloads: ${e.toString()}');
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading downloads: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _deleteDownload(int movieId) async {
//     // Show confirmation dialog first
//     bool confirmed = await _showDeleteConfirmationDialog(context);

//     if (confirmed) {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();

//         // Remove from local state
//         setState(() {
//           downloadedMovies.removeWhere((movie) => movie.id == movieId);
//         });

//         // Update SharedPreferences
//         List<String> updatedMoviesJson = downloadedMovies
//             .map((movie) => jsonEncode(movie.toJson()))
//             .toList();

//         await prefs.setStringList('downloads', updatedMoviesJson);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Movie removed from downloads',
//                 style: TextStyle(color: Colors.white)),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error removing download: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
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
//                         Icons.delete_outline,
//                         color: Color(0xFF2D2C3E),
//                         size: 28,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Are you sure?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'By doing this, the download will be deleted from your account!',
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
//                         'Delete',
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
//         false; // Return false if dialog is dismissed
//   }

//   // Helper method to get the correct image URL
//   String getImageUrl(String posterPath) {
//     // If the path already starts with http or https, assume it's a complete URL
//     if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
//       return posterPath;
//     }
//     // If the path starts with a slash, make sure we don't double up slashes
//     else if (posterPath.startsWith('/')) {
//       return imageBaseUrl + posterPath;
//     }
//     // Otherwise, add a slash between base URL and path
//     else {
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
//           'My Downloads',
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
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.blue))
//           : downloadedMovies.isEmpty
//               ? _buildEmptyState()
//               : _buildDownloadsList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.cloud_download_outlined,
//             size: 80,
//             color: Colors.grey[600],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No Downloads Yet',
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
//               'Your downloaded movies and shows will appear here',
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

//   Widget _buildDownloadsList() {
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       itemCount: downloadedMovies.length,
//       itemBuilder: (context, index) {
//         final movie = downloadedMovies[index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: Color(0xFF1A1A2A),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               // Movie Poster with rounded corners and improved error handling
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Container(
//                   width: 90,
//                   height: 120,
//                   margin: EdgeInsets.all(12),
//                   child: movie.posterPath.isNotEmpty
//                       ? FadeInImage.assetNetwork(
//                           placeholder:
//                               'assets/placeholder.png', // Create a placeholder image in your assets folder
//                           image: getImageUrl(movie.posterPath),
//                           fit: BoxFit.cover,
//                           imageErrorBuilder: (context, error, stackTrace) {
//                             print('Error loading image: $error');
//                             return Container(
//                               color: Colors.grey[800],
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.movie,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     movie.title.split(' ')[0],
//                                     style: TextStyle(
//                                       color: Colors.white70,
//                                       fontSize: 10,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         )
//                       : Container(
//                           color: Colors.grey[800],
//                           child: Icon(
//                             Icons.movie,
//                             color: Colors.white,
//                             size: 40,
//                           ),
//                         ),
//                 ),
//               ),
//               // Movie Info
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         movie.title,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: 4),
//                       if (movie.genres.isNotEmpty)
//                         Text(
//                           movie.genres,
//                           style: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 13,
//                           ),
//                         ),
//                       SizedBox(height: 12),
//                       Row(
//                         children: [
//                           if (movie.duration.isNotEmpty)
//                             Text(
//                               movie.duration,
//                               style: TextStyle(
//                                 color: Colors.grey[400],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           if (movie.duration.isNotEmpty) SizedBox(width: 12),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               movie.quality,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Options button
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

//   void _showOptionsBottomSheet(BuildContext context, DownloadedMovie movie) {
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
//                 leading: Icon(Icons.file_download_done, color: Colors.white),
//                 title:
//                     Text('Downloaded', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete_outline, color: Colors.red),
//                 title: Text('Delete Download',
//                     style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _deleteDownload(movie.id);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DownloadedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String quality;
  final DateTime downloadDate;
  final String genres;
  final String duration;

  DownloadedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.quality,
    required this.downloadDate,
    this.genres = '',
    this.duration = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'quality': quality,
      'downloadDate': downloadDate.toIso8601String(),
      'genres': genres,
      'duration': duration,
    };
  }

  factory DownloadedMovie.fromJson(Map<String, dynamic> json) {
    return DownloadedMovie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      quality: json['quality'],
      downloadDate: DateTime.parse(json['downloadDate']),
      genres: json['genres'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}

// Model for saved movies
class SavedMovie {
  final int id;
  final String title;
  final String posterPath;
  final String genres;
  final DateTime savedDate;

  SavedMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.genres,
    required this.savedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'genres': genres,
      'savedDate': savedDate.toIso8601String(),
    };
  }

  factory SavedMovie.fromJson(Map<String, dynamic> json) {
    return SavedMovie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      genres: json['genres'] ?? '',
      savedDate: DateTime.parse(json['savedDate']),
    );
  }
}

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<DownloadedMovie> downloadedMovies = [];
  bool isLoading = true;

  // IMPORTANT: Update this to match your API's base URL for images
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> downloadedMoviesJson =
          prefs.getStringList('downloads') ?? [];

      setState(() {
        downloadedMovies = downloadedMoviesJson
            .map((json) => DownloadedMovie.fromJson(jsonDecode(json)))
            .toList();
        isLoading = false;
      });

      // Debug print to check what data is being loaded
      print('Loaded ${downloadedMovies.length} movies');
      if (downloadedMovies.isNotEmpty) {
        print('First movie poster path: ${downloadedMovies[0].posterPath}');
      }
    } catch (e) {
      print('Error loading downloads: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading downloads: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteDownload(int movieId) async {
    // Show confirmation dialog first
    bool confirmed = await _showDeleteConfirmationDialog(context);

    if (confirmed) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Remove from local state
        setState(() {
          downloadedMovies.removeWhere((movie) => movie.id == movieId);
        });

        // Update SharedPreferences
        List<String> updatedMoviesJson = downloadedMovies
            .map((movie) => jsonEncode(movie.toJson()))
            .toList();

        await prefs.setStringList('downloads', updatedMoviesJson);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Movie removed from downloads',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing download: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
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
                        Icons.delete_outline,
                        color: Color(0xFF2D2C3E),
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'By doing this, the download will be deleted from your account!',
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
                        'Delete',
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
        false; // Return false if dialog is dismissed
  }

  // Save movie to saved collection
  Future<void> _saveMovie(DownloadedMovie movie) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get current saved movies
      List<String> savedMoviesJson = prefs.getStringList('saved_movies') ?? [];
      List<SavedMovie> savedMovies = savedMoviesJson
          .map((json) => SavedMovie.fromJson(jsonDecode(json)))
          .toList();

      // Check if the movie is already saved
      bool isAlreadySaved =
          savedMovies.any((savedMovie) => savedMovie.id == movie.id);

      if (isAlreadySaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Movie already saved',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }

      // Create new SavedMovie object
      SavedMovie newSavedMovie = SavedMovie(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        genres: movie.genres,
        savedDate: DateTime.now(),
      );

      // Add to saved movies list
      savedMovies.add(newSavedMovie);

      // Save updated list
      List<String> updatedSavedMoviesJson =
          savedMovies.map((movie) => jsonEncode(movie.toJson())).toList();

      await prefs.setStringList('saved_movies', updatedSavedMoviesJson);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie saved successfully',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving movie: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to get the correct image URL
  String getImageUrl(String posterPath) {
    // If the path already starts with http or https, assume it's a complete URL
    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return posterPath;
    }
    // If the path starts with a slash, make sure we don't double up slashes
    else if (posterPath.startsWith('/')) {
      return imageBaseUrl + posterPath;
    }
    // Otherwise, add a slash between base URL and path
    else {
      return imageBaseUrl + '/' + posterPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1C3A),
        elevation: 0,
        title: Text(
          'My Downloads',
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
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : downloadedMovies.isEmpty
              ? _buildEmptyState()
              : _buildDownloadsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_download_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          SizedBox(height: 16),
          Text(
            'No Downloads Yet',
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
              'Your downloaded movies and shows will appear here',
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

  Widget _buildDownloadsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: downloadedMovies.length,
      itemBuilder: (context, index) {
        final movie = downloadedMovies[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Movie Poster with rounded corners and improved error handling
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 90,
                  height: 120,
                  margin: EdgeInsets.all(12),
                  child: movie.posterPath.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder:
                              'assets/placeholder.png', // Create a placeholder image in your assets folder
                          image: getImageUrl(movie.posterPath),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Container(
                              color: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.movie,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    movie.title.split(' ')[0],
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                ),
              ),
              // Movie Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      if (movie.genres.isNotEmpty)
                        Text(
                          movie.genres,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          if (movie.duration.isNotEmpty)
                            Text(
                              movie.duration,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          if (movie.duration.isNotEmpty) SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              movie.quality,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          // Replace "Play now" with "Save" Button
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.red,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: 12, vertical: 8),
                          //   ),
                          //   onPressed: () => _saveMovie(movie),
                          //   child: Text(
                          //     'Save',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Options button
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

  void _showOptionsBottomSheet(BuildContext context, DownloadedMovie movie) {
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
              // ListTile(
              //   leading: Icon(Icons.play_arrow, color: Colors.white),
              //   title: Text('Play', style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Add play functionality
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.bookmark_add, color: Colors.white),
                title: Text('Save', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _saveMovie(movie);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download_done, color: Colors.white),
                title:
                    Text('Downloaded', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Delete Download',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteDownload(movie.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
