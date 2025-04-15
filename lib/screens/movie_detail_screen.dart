// import 'package:flutter/material.dart';
// import '../models/movie.dart';

// class MovieDetailScreen extends StatelessWidget {
//   final Movie movie;

//   const MovieDetailScreen({super.key, required this.movie});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(movie.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(movie.poster,
//                 width: double.infinity, height: 400, fit: BoxFit.cover),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(movie.title,
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Text('⭐ ${movie.rating} / 10',
//                       style:
//                           const TextStyle(fontSize: 18, color: Colors.amber)),
//                   const SizedBox(height: 8),
//                   Text('Released on: ${movie.releaseDate}',
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 16),
//                   Text(movie.description, style: const TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/original/';
  final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
  TabController? _tabController;
  Map<String, dynamic>? movieDetails;
  List<dynamic> similarMovies = [];
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMovieDetails();
    fetchSimilarMovies();
  }

  @override
  void dispose() {
    _tabController?.dispose();
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

  String _getGenres() {
    if (movieDetails == null || movieDetails?['genres'] == null) {
      return '';
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

    return '${hours}h ${minutes}m';
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
            // Movie poster with gradient overlay
            Stack(
              children: [
                // Movie poster
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
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
                // Gradient overlay
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
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
                // Movie info at bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie['title'] ?? 'Unknown',
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
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.play_arrow),
                              label: Text('Play'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: Icon(
                                isDownloading
                                    ? Icons.downloading
                                    : Icons.download,
                                color: Colors.white,
                              ),
                              label: Text(
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
                              onPressed: () {
                                setState(() {
                                  isDownloading = !isDownloading;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Synopsis
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.movie['overview'] ?? 'No description available',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Read Less',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.red,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Episodes'),
                  Tab(text: 'Similar'),
                  Tab(text: 'About'),
                ],
              ),
            ),

            // Tab Bar View
            Container(
              height: 500, // Fixed height for tab content
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Episodes Tab
                  _buildTrailerContent(),

                  // Similar Tab
                  _buildSimilarContent(),

                  // About Tab
                  _buildAboutContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailerContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '$imageBaseUrl${widget.movie['backdrop_path']}',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 25,
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 30),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 15,
                    child: Icon(Icons.download, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Trailer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            widget.movie['overview'] != null
                ? widget.movie['overview'].length > 100
                    ? '${widget.movie['overview'].substring(0, 100)}...'
                    : widget.movie['overview']
                : 'No description available',
            style: TextStyle(color: Colors.grey, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarContent() {
    return similarMovies.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: similarMovies.length > 5 ? 5 : similarMovies.length,
            itemBuilder: (context, index) {
              final movie = similarMovies[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '$imageBaseUrl${movie['poster_path']}',
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[800],
                            child:
                                Icon(Icons.broken_image, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'] ?? 'Unknown',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie['overview'] != null
                                ? movie['overview'].length > 100
                                    ? '${movie['overview'].substring(0, 100)}...'
                                    : movie['overview']
                                : 'No description available',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synopsis',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.movie['overview'] ?? 'No description available',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          Text(
            'Cast',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          movieDetails?['credits'] != null
              ? Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieDetails!['credits']['cast'].length > 10
                        ? 10
                        : movieDetails!['credits']['cast'].length,
                    itemBuilder: (context, index) {
                      final cast = movieDetails!['credits']['cast'][index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
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
                            SizedBox(height: 4),
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
                  'No cast information available',
                  style: TextStyle(color: Colors.grey),
                ),
        ],
      ),
    );
  }
}
