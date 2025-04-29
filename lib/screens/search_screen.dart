import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie_detail_screen.dart'; // Import MovieDetailScreen
import 'episode_screen.dart'; // Import EpisodeScreen

class SearchScreen extends StatefulWidget {
  final String apiKey;

  const SearchScreen({Key? key, required this.apiKey}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  List<dynamic> searchResults = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> searchMoviesAndTV(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        errorMessage = '';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final url = 'https://api.themoviedb.org/3/search/multi?api_key=${widget.apiKey}&query=${Uri.encodeComponent(query)}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body)['results'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading search results: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            searchMoviesAndTV(value); // Search as the user types
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search Movies & TV Shows',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () async {
                              // Check the media type and navigate accordingly
                              if (result['media_type'] == 'tv') {
                                // Fetch additional TV show details
                                final tvDetailsResponse = await http.get(
                                  Uri.parse(
                                      'https://api.themoviedb.org/3/tv/${result['id']}?api_key=${widget.apiKey}'),
                                );
                                if (tvDetailsResponse.statusCode == 200) {
                                  final tvDetails =
                                      json.decode(tvDetailsResponse.body);
                                  String year = result['first_air_date'] != null
                                      ? result['first_air_date'].substring(0, 4)
                                      : 'Unknown';
                                  String genres = tvDetails['genres'] != null
                                      ? tvDetails['genres']
                                          .map((g) => g['name'])
                                          .join(', ')
                                      : 'Unknown';
                                  String runtime = tvDetails['episode_run_time'] !=
                                              null &&
                                          tvDetails['episode_run_time'].isNotEmpty
                                      ? '${tvDetails['episode_run_time'][0]}m'
                                      : 'Unknown';
                                  String metadata = '$year • $genres • $runtime';
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EpisodeScreen(
                                        tvId: result['id'].toString(),
                                        apiKey: widget.apiKey,
                                        title: result['name'] ?? 'Unknown',
                                        overview: result['overview'] != null
                                            ? result['overview']
                                            : 'No description available',
                                        metadata: metadata,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Handle error fetching TV details
                                  setState(() {
                                    errorMessage =
                                        'Failed to load TV show details';
                                  });
                                }
                              } else {
                                // Navigate to MovieDetailScreen for movies
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      movie: result,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '$imageBaseUrl${result['poster_path'] ?? result['backdrop_path']}',
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 150,
                                        color: Colors.grey[800],
                                        child: const Icon(Icons.broken_image,
                                            color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result['title'] ??
                                            result['name'] ??
                                            'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        result['overview'] != null
                                            ? result['overview'].length > 100
                                                ? '${result['overview'].substring(0, 100)}...'
                                                : result['overview']
                                            : 'No description available',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}