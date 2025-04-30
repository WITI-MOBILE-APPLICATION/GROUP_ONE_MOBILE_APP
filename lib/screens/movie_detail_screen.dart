// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'download_screen.dart';

// // ... (Your existing DownloadedMovie class remains unchanged) ...

// class MovieDetailScreen extends StatefulWidget {
//   final dynamic movie;

//   const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

//   @override
//   _MovieDetailScreenState createState() => _MovieDetailScreenState();
// }

// class _MovieDetailScreenState extends State<MovieDetailScreen>
//     with SingleTickerProviderStateMixin {
//   final String imageBaseUrl = 'https://image.tmdb.org/t/p/original/';
//   final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115'; // TMDb API key
//   final String youtubeApiKey =
//       'AIzaSyC-61DxvoQjn-zUWKJ8n2bSjqeusthmMCg'; // Replace with your YouTube API key
//   TabController? _tabController;
//   Map<String, dynamic>? movieDetails;
//   List<dynamic> similarMovies = [];
//   List<dynamic> movieVideos = [];
//   bool isDownloading = false;
//   YoutubePlayerController? _youtubeController;
//   YoutubePlayerController? _moviePlayerController;
//   bool _isPlayingTrailer = false;
//   String? _currentTrailerKey;
//   int _selectedTrailerIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     fetchMovieDetails();
//     fetchSimilarMovies();
//     fetchMovieVideos();
//   }

//   @override
//   void dispose() {
//     _tabController?.dispose();
//     _youtubeController?.dispose();
//     _moviePlayerController?.dispose();
//     super.dispose();
//   }

//   Future<void> fetchMovieDetails() async {
//     final url =
//         'https://api.themoviedb.org/3/movie/${widget.movie['id']}?api_key=$apiKey&append_to_response=credits,videos';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         movieDetails = json.decode(response.body);
//       });
//     }
//   }

//   Future<void> fetchMovieVideos() async {
//     final url =
//         'https://api.themoviedb.org/3/movie/${widget.movie['id']}/videos?api_key=$apiKey';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       var result = json.decode(response.body);
//       if (result['results'] != null) {
//         setState(() {
//           movieVideos = result['results']
//               .where((video) =>
//                   video['type'] == 'Trailer' || video['type'] == 'Teaser')
//               .toList();
//         });
//       }
//     }
//   }

//   Future<void> fetchSimilarMovies() async {
//     final url =
//         'https://api.themoviedb.org/3/movie/${widget.movie['id']}/similar?api_key=$apiKey';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         similarMovies = json.decode(response.body)['results'];
//       });
//     }
//   }

//   void _playTrailer(String? videoKey, int index) {
//     if (videoKey == null) return;

//     setState(() {
//       _selectedTrailerIndex = index;
//       _currentTrailerKey = videoKey;
//       _isPlayingTrailer = true;
//     });

//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoKey,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   YoutubePlayer(
//                     controller: _youtubeController!,
//                     showVideoProgressIndicator: true,
//                     progressIndicatorColor: Colors.red,
//                     progressColors: ProgressBarColors(
//                       playedColor: Colors.red,
//                       handleColor: Colors.redAccent,
//                     ),
//                     onReady: () {
//                       _youtubeController!.play();
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       setState(() {
//                         _isPlayingTrailer = false;
//                       });
//                       _youtubeController?.pause();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((_) {
//       setState(() {
//         _isPlayingTrailer = false;
//       });
//       _youtubeController?.pause();
//     });
//   }

//   void _playMovie() async {
//     // Search YouTube for the movie
//     String? movieVideoKey = await _searchYouTubeForMovie();

//     if (movieVideoKey == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No full movie found on YouTube'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Initialize YouTube player for the movie
//     _moviePlayerController = YoutubePlayerController(
//       initialVideoId: movieVideoKey,
//       flags: YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );

//     // Show movie playback dialog (same style as trailer)
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   YoutubePlayer(
//                     controller: _moviePlayerController!,
//                     showVideoProgressIndicator: true,
//                     progressIndicatorColor: Colors.red,
//                     progressColors: ProgressBarColors(
//                       playedColor: Colors.red,
//                       handleColor: Colors.redAccent,
//                     ),
//                     onReady: () {
//                       _moviePlayerController!.play();
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.close, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       _moviePlayerController?.pause();
//                       _moviePlayerController?.dispose();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((_) {
//       // Clean up when dialog is closed
//       _moviePlayerController?.pause();
//       _moviePlayerController?.dispose();
//     });
//   }

//   Future<String?> _searchYouTubeForMovie() async {
//     try {
//       // Construct search query with movie title and "full movie"
//       final String query = Uri.encodeComponent(
//           '${widget.movie['title']} full movie ${movieDetails?['release_date']?.substring(0, 4) ?? ''}');
//       final String url =
//           'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&videoDuration=long&maxResults=5&key=$youtubeApiKey';

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         var results = json.decode(response.body);
//         if (results['items'].isNotEmpty) {
//           // Return the first long-duration video's ID
//           return results['items'][0]['id']['videoId'];
//         }
//       }
//     } catch (e) {
//       print('Error searching YouTube: $e');
//     }
//     return null; // No suitable video found
//   }

//   String _getGenres() {
//     if (movieDetails == null || movieDetails?['genres'] == null) {
//       return '';
//     }
//     List<dynamic> genres = movieDetails!['genres'];
//     return genres.map((genre) => genre['name']).join(', ');
//   }

//   String _getRuntime() {
//     if (movieDetails == null || movieDetails?['runtime'] == null) {
//       return '';
//     }
//     int runtime = movieDetails!['runtime'];
//     int hours = runtime ~/ 60;
//     int minutes = runtime % 60;
//     return '${hours}h ${minutes}m';
//   }

//   void _showDownloadOptions() {
//     Map<String, bool> downloadOptions = {
//       'HD (1080p)': true,
//       'Mid (720p)': true,
//       'Low (480p)': true,
//     };

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               backgroundColor: Color(0xFF1E1C3A),
//               child: Container(
//                 padding: EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Download File',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     ...downloadOptions.entries.map((option) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16.0),
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   downloadOptions[option.key] = !option.value;
//                                 });
//                               },
//                               child: Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: option.value
//                                       ? Colors.red
//                                       : Colors.transparent,
//                                   border: Border.all(
//                                     color:
//                                         option.value ? Colors.red : Colors.grey,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: option.value
//                                     ? Icon(Icons.check,
//                                         color: Colors.white, size: 16)
//                                     : null,
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Text(
//                               option.key,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                     SizedBox(height: 24),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         minimumSize: Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       onPressed: () {
//                         List<String> selectedQualities = downloadOptions.entries
//                             .where((entry) => entry.value)
//                             .map((entry) => entry.key)
//                             .toList();
//                         Navigator.pop(context);
//                         _downloadMovie(selectedQualities);
//                       },
//                       child: Text(
//                         'Download Now',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _downloadMovie(List<String> qualities) async {
//     setState(() {
//       isDownloading = true;
//     });

//     String selectedQuality =
//         qualities.isNotEmpty ? qualities.first : 'HD (1080p)';

//     try {
//       await Future.delayed(Duration(seconds: 3));

//       DownloadedMovie downloadedMovie = DownloadedMovie(
//         id: widget.movie['id'],
//         title: widget.movie['title'] ?? 'Unknown movie',
//         posterPath: widget.movie['poster_path'] ?? '',
//         quality: selectedQuality,
//         downloadDate: DateTime.now(),
//       );

//       await _saveDownload(downloadedMovie);

//       if (mounted) {
//         setState(() {
//           isDownloading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Download complete! Saved to Downloads.',
//               style: TextStyle(color: Colors.white),
//             ),
//             backgroundColor: Colors.green,
//             action: SnackBarAction(
//               label: 'VIEW',
//               textColor: Colors.white,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DownloadsPage(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isDownloading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Download failed: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _saveDownload(DownloadedMovie movie) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> downloadedMoviesJson = prefs.getStringList('downloads') ?? [];
//     List<DownloadedMovie> downloadedMovies = downloadedMoviesJson
//         .map((json) => DownloadedMovie.fromJson(jsonDecode(json)))
//         .toList();

//     bool alreadyDownloaded = downloadedMovies.any((m) => m.id == movie.id);

//     if (!alreadyDownloaded) {
//       downloadedMovies.add(movie);
//       List<String> updatedMoviesJson =
//           downloadedMovies.map((movie) => jsonEncode(movie.toJson())).toList();
//       await prefs.setStringList('downloads', updatedMoviesJson);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF06041F),
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.bookmark_border, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: Icon(Icons.share, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.45,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         '$imageBaseUrl${widget.movie['backdrop_path'] ?? widget.movie['poster_path']}',
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.45,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Color(0xFF06041F).withOpacity(0.5),
//                         Color(0xFF06041F),
//                       ],
//                       stops: [0.4, 0.75, 0.9],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.movie['title'] ?? 'Unknown',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text(
//                             movieDetails != null
//                                 ? '${movieDetails!['release_date']?.substring(0, 4) ?? ""}'
//                                 : '',
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                           Text(
//                             ' • ',
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                           Text(
//                             _getGenres(),
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                           Text(
//                             ' • ',
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                           Text(
//                             _getRuntime(),
//                             style: TextStyle(color: Colors.grey[400]),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               child: Text('Play'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               onPressed: _playMovie,
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: OutlinedButton(
//                               child: isDownloading
//                                   ? SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.white),
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : Text(
//                                       'Download',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                               style: OutlinedButton.styleFrom(
//                                 side: BorderSide(color: Colors.grey),
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                               onPressed:
//                                   isDownloading ? null : _showDownloadOptions,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.movie['overview'] ?? 'No description available',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                     maxLines: 2,
//                     overflow: TextOverflow
//                         .ellipsis, // Correct: Use TextOverflow.ellipsis
//                   ),
//                   SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           backgroundColor: Color(0xFF1E1C3A),
//                           title: Text(
//                             'Overview',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           content: SingleChildScrollView(
//                             child: Text(
//                               widget.movie['overview'] ??
//                                   'No description available',
//                               style: TextStyle(color: Colors.white70),
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               child: Text('Close',
//                                   style: TextStyle(color: Colors.red)),
//                               onPressed: () => Navigator.pop(context),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'Read more',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
//                 ),
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 indicator: UnderlineTabIndicator(
//                   borderSide: BorderSide(color: Colors.red, width: 3.0),
//                   insets: EdgeInsets.symmetric(horizontal: 16.0),
//                 ),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.grey,
//                 tabs: [
//                   Tab(text: 'Episode'),
//                   Tab(text: 'Similar'),
//                   Tab(text: 'About'),
//                 ],
//               ),
//             ),
//             Container(
//               height: 400,
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildEpisodeContent(),
//                   _buildSimilarContent(),
//                   _buildAboutContent(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEpisodeContent() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: movieVideos.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.movie_creation_outlined,
//                       color: Colors.grey, size: 48),
//                   SizedBox(height: 16),
//                   Text(
//                     'No trailers available',
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               itemCount: movieVideos.length,
//               itemBuilder: (context, index) {
//                 final video = movieVideos[index];
//                 return _buildTrailerItem(video, index);
//               },
//             ),
//     );
//   }

//   Widget _buildTrailerItem([dynamic videoData, int index = 0]) {
//     String thumbnailUrl = videoData != null && videoData['key'] != null
//         ? 'https://img.youtube.com/vi/${videoData['key']}/0.jpg'
//         : '$imageBaseUrl${widget.movie['backdrop_path'] ?? widget.movie['poster_path']}';

//     String videoTitle =
//         videoData != null ? videoData['name'] ?? 'Trailer' : 'Trailer';

//     return GestureDetector(
//       onTap: () {
//         if (videoData != null && videoData['key'] != null) {
//           _playTrailer(videoData['key'], index);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('No trailer available to play'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16),
//         child: Row(
//           children: [
//             Container(
//               width: 140,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                   image: NetworkImage(thumbnailUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   _selectedTrailerIndex == index && _isPlayingTrailer
//                       ? Container(
//                           color: Colors.black.withOpacity(0.5),
//                           child: Center(
//                             child: Icon(
//                               Icons.pause_circle_outline,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           ),
//                         )
//                       : Icon(
//                           Icons.play_circle_outline,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                   Positioned(
//                     bottom: 5,
//                     right: 5,
//                     child: Container(
//                       padding: EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.file_download_outlined,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     videoTitle,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     videoData != null
//                         ? videoData['type'] ?? 'Video'
//                         : 'No trailer description available.',
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSimilarContent() {
//     return similarMovies.isEmpty
//         ? Center(child: CircularProgressIndicator())
//         : GridView.builder(
//             padding: EdgeInsets.all(16),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               childAspectRatio: 0.6,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: similarMovies.length,
//             itemBuilder: (context, index) {
//               final movie = similarMovies[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(
//                       '$imageBaseUrl${movie['poster_path'] ?? ''}',
//                     ),
//                     fit: BoxFit.cover,
//                     onError: (exception, stackTrace) {},
//                   ),
//                 ),
//                 child: movie['poster_path'] == null
//                     ? Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[800],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Center(
//                           child: Icon(Icons.broken_image, color: Colors.white),
//                         ),
//                       )
//                     : null,
//               );
//             },
//           );
//   }

//   Widget _buildAboutContent() {
//     if (movieDetails == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView(
//         children: [
//           _buildInfoRow('Genre', _getGenres()),
//           _buildInfoRow(
//               'Language',
//               movieDetails?['original_language'] == 'en'
//                   ? 'English'
//                   : movieDetails?['original_language'] ?? 'Unknown'),
//           _buildInfoRow('Year',
//               movieDetails?['release_date']?.substring(0, 4) ?? 'Unknown'),
//           _buildInfoRow(
//               'Country',
//               movieDetails?['production_countries']?.isNotEmpty == true
//                   ? movieDetails!['production_countries'][0]['name']
//                   : 'Unknown'),
//           SizedBox(height: 20),
//           Text(
//             'Actors',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//           SizedBox(height: 16),
//           movieDetails?['credits']?.isNotEmpty == true
//               ? Container(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: min(movieDetails!['credits']['cast'].length, 5),
//                     itemBuilder: (context, index) {
//                       final cast = movieDetails!['credits']['cast'][index];
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 20.0),
//                         child: Column(
//                           children: [
//                             CircleAvatar(
//                               radius: 30,
//                               backgroundImage: cast['profile_path'] != null
//                                   ? NetworkImage(
//                                       '$imageBaseUrl${cast['profile_path']}')
//                                   : null,
//                               backgroundColor: Colors.grey[800],
//                               child: cast['profile_path'] == null
//                                   ? Text(
//                                       cast['name'][0],
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 24),
//                                     )
//                                   : null,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               cast['name'],
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : Text(
//                   'No cast information available',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.grey[400],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int min(int a, int b) {
//     return a < b ? a : b;
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'download_screen.dart';
import 'app_localizations.dart'; // Added localization import

// ... (Assuming DownloadedMovie class is unchanged and defined elsewhere) ...

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/original/';
  final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115'; // TMDb API key
  final String youtubeApiKey =
      'AIzaSyC-61DxvoQjn-zUWKJ8n2bSjqeusthmMCg'; // Replace with your YouTube API key
  TabController? _tabController;
  Map<String, dynamic>? movieDetails;
  List<dynamic> similarMovies = [];
  List<dynamic> movieVideos = [];
  bool isDownloading = false;
  YoutubePlayerController? _youtubeController;
  YoutubePlayerController? _moviePlayerController;
  bool _isPlayingTrailer = false;
  String? _currentTrailerKey;
  int _selectedTrailerIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMovieDetails();
    fetchSimilarMovies();
    fetchMovieVideos();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _youtubeController?.dispose();
    _moviePlayerController?.dispose();
    super.dispose();
  }

  Future<void> fetchMovieDetails() async {
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movie['id']}?api_key=$apiKey&append_to_response=credits,videos';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = json.decode(response.body);
      });
    }
  }

  Future<void> fetchMovieVideos() async {
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movie['id']}/videos?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['results'] != null) {
        setState(() {
          movieVideos = result['results']
              .where((video) =>
                  video['type'] == 'Trailer' || video['type'] == 'Teaser')
              .toList();
        });
      }
    }
  }

  Future<void> fetchSimilarMovies() async {
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movie['id']}/similar?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        similarMovies = json.decode(response.body)['results'];
      });
    }
  }

  void _playTrailer(String? videoKey, int index) {
    if (videoKey == null) return;

    setState(() {
      _selectedTrailerIndex = index;
      _currentTrailerKey = videoKey;
      _isPlayingTrailer = true;
    });

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoKey,
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
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onReady: () {
                      _youtubeController!.play();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _isPlayingTrailer = false;
                      });
                      _youtubeController?.pause();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {
        _isPlayingTrailer = false;
      });
      _youtubeController?.pause();
    });
  }

  void _playMovie() async {
    // Search YouTube for the movie
    String? movieVideoKey = await _searchYouTubeForMovie();

    if (movieVideoKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)!.translate('no_movie_found') ??
                  'No full movie found on YouTube'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Initialize YouTube player for the movie
    _moviePlayerController = YoutubePlayerController(
      initialVideoId: movieVideoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    // Show movie playback dialog (same style as trailer)
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
      // Clean up when dialog is closed
      _moviePlayerController?.pause();
      _moviePlayerController?.dispose();
    });
  }

  Future<String?> _searchYouTubeForMovie() async {
    try {
      // Construct search query with movie title and "full movie"
      final String query = Uri.encodeComponent(
          '${widget.movie['title']} full movie ${movieDetails?['release_date']?.substring(0, 4) ?? ''}');
      final String url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&videoDuration=long&maxResults=5&key=$youtubeApiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var results = json.decode(response.body);
        if (results['items'].isNotEmpty) {
          // Return the first long-duration video's ID
          return results['items'][0]['id']['videoId'];
        }
      }
    } catch (e) {
      print('Error searching YouTube: $e');
    }
    return null; // No suitable video found
  }

  String _getGenres() {
    if (movieDetails == null || movieDetails?['genres'] == null) {
      return AppLocalizations.of(context)!.translate('unknown') ?? 'Unknown';
    }
    List<dynamic> genres = movieDetails!['genres'];
    return genres.map((genre) => genre['name']).join(', ');
  }

  String _getRuntime() {
    if (movieDetails == null || movieDetails?['runtime'] == null) {
      return '';
    }
    int runtime = movieDetails!['runtime'];
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '$hours${AppLocalizations.of(context)!.translate('hour_abbr') ?? 'h'} $minutes${AppLocalizations.of(context)!.translate('minute_abbr') ?? 'm'}';
  }

  void _showDownloadOptions() {
    Map<String, bool> downloadOptions = {
      AppLocalizations.of(context)!.translate('hd_1080p') ?? 'HD (1080p)': true,
      AppLocalizations.of(context)!.translate('mid_720p') ?? 'Mid (720p)': true,
      AppLocalizations.of(context)!.translate('low_480p') ?? 'Low (480p)': true,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color(0xFF1E1C3A),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                              .translate('download_file') ??
                          'Download File',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    ...downloadOptions.entries.map((option) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  downloadOptions[option.key] = !option.value;
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: option.value
                                      ? Colors.red
                                      : Colors.transparent,
                                  border: Border.all(
                                    color:
                                        option.value ? Colors.red : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: option.value
                                    ? Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              option.key,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        List<String> selectedQualities = downloadOptions.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();
                        Navigator.pop(context);
                        _downloadMovie(selectedQualities);
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                                .translate('download_now') ??
                            'Download Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _downloadMovie(List<String> qualities) async {
    setState(() {
      isDownloading = true;
    });

    String selectedQuality = qualities.isNotEmpty
        ? qualities.first
        : (AppLocalizations.of(context)!.translate('hd_1080p') ?? 'HD (1080p)');

    try {
      await Future.delayed(Duration(seconds: 3));

      DownloadedMovie downloadedMovie = DownloadedMovie(
        id: widget.movie['id'],
        title: widget.movie['title'] ??
            (AppLocalizations.of(context)!.translate('unknown_movie') ??
                'Unknown movie'),
        posterPath: widget.movie['poster_path'] ?? '',
        quality: selectedQuality,
        downloadDate: DateTime.now(),
      );

      await _saveDownload(downloadedMovie);

      if (mounted) {
        setState(() {
          isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translate('download_complete') ??
                  'Download complete! Saved to Downloads.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.translate('view') ?? 'VIEW',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadsPage(),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.translate('download_failed') ??
                    'Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveDownload(DownloadedMovie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> downloadedMoviesJson = prefs.getStringList('downloads') ?? [];
    List<DownloadedMovie> downloadedMovies = downloadedMoviesJson
        .map((json) => DownloadedMovie.fromJson(jsonDecode(json)))
        .toList();

    bool alreadyDownloaded = downloadedMovies.any((m) => m.id == movie.id);

    if (!alreadyDownloaded) {
      downloadedMovies.add(movie);
      List<String> updatedMoviesJson =
          downloadedMovies.map((movie) => jsonEncode(movie.toJson())).toList();
      await prefs.setStringList('downloads', updatedMoviesJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '$imageBaseUrl${widget.movie['backdrop_path'] ?? widget.movie['poster_path']}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0xFF06041F).withOpacity(0.5),
                        Color(0xFF06041F),
                      ],
                      stops: [0.4, 0.75, 0.9],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie['title'] ??
                            (AppLocalizations.of(context)!
                                    .translate('unknown') ??
                                'Unknown'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            movieDetails != null
                                ? '${movieDetails!['release_date']?.substring(0, 4) ?? ""}'
                                : '',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(
                            _getGenres(),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          Text(
                            _getRuntime(),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(AppLocalizations.of(context)!
                                      .translate('play') ??
                                  'Play'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _playMovie,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              child: isDownloading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!
                                              .translate('download') ??
                                          'Download',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed:
                                  isDownloading ? null : _showDownloadOptions,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie['overview'] ??
                        (AppLocalizations.of(context)!
                                .translate('no_description') ??
                            'No description available'),
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Color(0xFF1E1C3A),
                          title: Text(
                            AppLocalizations.of(context)!
                                    .translate('overview') ??
                                'Overview',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                            child: Text(
                              widget.movie['overview'] ??
                                  (AppLocalizations.of(context)!
                                          .translate('no_description') ??
                                      'No description available'),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                  AppLocalizations.of(context)!
                                          .translate('close') ??
                                      'Close',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('read_more') ??
                          'Read more',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.red, width: 3.0),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                      text:
                          AppLocalizations.of(context)!.translate('episode') ??
                              'Episode'),
                  Tab(
                      text:
                          AppLocalizations.of(context)!.translate('similar') ??
                              'Similar'),
                  Tab(
                      text: AppLocalizations.of(context)!.translate('about') ??
                          'About'),
                ],
              ),
            ),
            Container(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEpisodeContent(),
                  _buildSimilarContent(),
                  _buildAboutContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: movieVideos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_creation_outlined,
                      color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.translate('no_trailers') ??
                        'No trailers available',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: movieVideos.length,
              itemBuilder: (context, index) {
                final video = movieVideos[index];
                return _buildTrailerItem(video, index);
              },
            ),
    );
  }

  Widget _buildTrailerItem([dynamic videoData, int index = 0]) {
    String thumbnailUrl = videoData != null && videoData['key'] != null
        ? 'https://img.youtube.com/vi/${videoData['key']}/0.jpg'
        : '$imageBaseUrl${widget.movie['backdrop_path'] ?? widget.movie['poster_path']}';

    String videoTitle = videoData != null
        ? videoData['name'] ??
            (AppLocalizations.of(context)!.translate('trailer') ?? 'Trailer')
        : (AppLocalizations.of(context)!.translate('trailer') ?? 'Trailer');

    return GestureDetector(
      onTap: () {
        if (videoData != null && videoData['key'] != null) {
          _playTrailer(videoData['key'], index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!
                      .translate('no_trailer_available') ??
                  'No trailer available to play'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _selectedTrailerIndex == index && _isPlayingTrailer
                      ? Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Icon(
                              Icons.pause_circle_outline,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    videoData != null
                        ? videoData['type'] ??
                            (AppLocalizations.of(context)!.translate('video') ??
                                'Video')
                        : (AppLocalizations.of(context)!
                                .translate('no_trailer_description') ??
                            'No trailer description available.'),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarContent() {
    return similarMovies.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: similarMovies.length,
            itemBuilder: (context, index) {
              final movie = similarMovies[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      '$imageBaseUrl${movie['poster_path'] ?? ''}',
                    ),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
                child: movie['poster_path'] == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(Icons.broken_image, color: Colors.white),
                        ),
                      )
                    : null,
              );
            },
          );
  }

  Widget _buildAboutContent() {
    if (movieDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildInfoRow(
              AppLocalizations.of(context)!.translate('genre') ?? 'Genre',
              _getGenres()),
          _buildInfoRow(
              AppLocalizations.of(context)!.translate('language') ?? 'Language',
              movieDetails?['original_language'] == 'en'
                  ? (AppLocalizations.of(context)!.translate('english') ??
                      'English')
                  : movieDetails?['original_language'] ??
                      (AppLocalizations.of(context)!.translate('unknown') ??
                          'Unknown')),
          _buildInfoRow(
              AppLocalizations.of(context)!.translate('year') ?? 'Year',
              movieDetails?['release_date']?.substring(0, 4) ??
                  (AppLocalizations.of(context)!.translate('unknown') ??
                      'Unknown')),
          _buildInfoRow(
              AppLocalizations.of(context)!.translate('country') ?? 'Country',
              movieDetails?['production_countries']?.isNotEmpty == true
                  ? movieDetails!['production_countries'][0]['name']
                  : (AppLocalizations.of(context)!.translate('unknown') ??
                      'Unknown')),
          SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.translate('actors') ?? 'Actors',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          movieDetails?['credits']?.isNotEmpty == true
              ? Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(movieDetails!['credits']['cast'].length, 5),
                    itemBuilder: (context, index) {
                      final cast = movieDetails!['credits']['cast'][index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: cast['profile_path'] != null
                                  ? NetworkImage(
                                      '$imageBaseUrl${cast['profile_path']}')
                                  : null,
                              backgroundColor: Colors.grey[800],
                              child: cast['profile_path'] == null
                                  ? Text(
                                      cast['name'][0],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  : null,
                            ),
                            SizedBox(height: 8),
                            Text(
                              cast['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!.translate('no_cast_info') ??
                      'No cast information available',
                  style: TextStyle(color: Colors.grey),
                ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
}
