// lib/screens/movie_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/download_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

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
    _tabController = TabController(length: 2, vsync: this);
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
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          movieDetails = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movie details: $e')),
      );
    }
  }

  Future<void> fetchSimilarMovies() async {
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movie['id']}/similar?api_key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          similarMovies = json.decode(response.body)['results'];
        });
      } else {
        throw Exception('Failed to load similar movies');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading similar movies: $e')),
      );
    }
  }

  String _getGenres() {
    if (movieDetails == null || movieDetails?['genres'] == null) {
      return 'N/A';
    }
    List<dynamic> genres = movieDetails!['genres'];
    return genres.map((genre) => genre['name']).join(', ');
  }

  String _getRuntime() {
    if (movieDetails == null || movieDetails?['runtime'] == null) {
      return 'N/A';
    }
    int runtime = movieDetails!['runtime'];
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }

  void _downloadThumbnail() async {
    final downloadServices = Provider.of<DownloadServices>(context, listen: false);
    setState(() {
      isDownloading = true;
    });
    try {
      String thumbnailUrl = '$imageBaseUrl${widget.movie['poster_path']}';
      await downloadServices.downloadMovie(
        widget.movie['id'].toString(),
        widget.movie['title'],
        thumbnailUrl,
        thumbnailUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kIsWeb
                ? '${widget.movie['title']} thumbnail downloaded to your browser'
                : '${widget.movie['title']} thumbnail downloaded',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie backdrop with gradient overlay
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF06041F).withOpacity(0.5),
                        const Color(0xFF06041F),
                      ],
                      stops: const [0.4, 0.75, 0.9],
                    ),
                  ),
                ),
              ],
            ),

            // Movie details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie['title'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieDetails != null
                        ? '${movieDetails!['release_date']?.substring(0, 4) ?? "N/A"} • ${_getGenres()} • ${_getRuntime()}'
                        : 'N/A',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Play functionality not implemented')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            isDownloading ? Icons.downloading : Icons.download,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Download',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isDownloading ? null : _downloadThumbnail,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.movie['overview'] ?? 'No description available',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
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
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Episode'),
                  Tab(text: 'Similar'),
                ],
              ),
            ),

            // Tab Bar View
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTrailerContent(),
                  _buildSimilarContent(),
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
          const Text(
            'TRAILER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, color: Colors.white),
                      );
                    },
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
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 50,
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 15,
                    child: IconButton(
                      icon: const Icon(Icons.download, color: Colors.white, size: 18),
                      onPressed: _downloadThumbnail,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${widget.movie['title']} - Official Trailer',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.movie['overview'] != null
                ? widget.movie['overview'].length > 100
                    ? '${widget.movie['overview'].substring(0, 100)}...'
                    : widget.movie['overview']
                : 'No description available',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarContent() {
    return similarMovies.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
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
                            child: const Icon(Icons.broken_image, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            movie['overview'] != null
                                ? movie['overview'].length > 100
                                    ? '${movie['overview'].substring(0, 100)}...'
                                    : movie['overview']
                                : 'No description available',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
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
}