import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movie_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  List<dynamic>? movies;
  bool isLoading = true;
  String? errorMessage;

  // Map category to TMDB genre ID
  int? getGenreId(String category) {
    switch (category) {
      case 'All':
        return null; // No genre filter for "All"
      case 'Action':
        return 28;
      case 'Comedy':
        return 35;
      case 'Romance':
        return 10749;
      // Additional TMDB genres for future scalability
      case 'Drama':
        return 18;
      case 'Horror':
        return 27;
      case 'Science Fiction':
        return 878;
      case 'Thriller':
        return 53;
      case 'Adventure':
        return 12;
      case 'Animation':
        return 16;
      default:
        return -1; // Indicate unsupported category
    }
  }

  Future<void> fetchMoviesByCategory() async {
    final genreId = getGenreId(widget.category);
    if (genreId == -1) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unsupported category: ${widget.category}';
      });
      return;
    }

    String url;
    if (genreId == null) {
      // For "All", fetch without genre filter
      url = 'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey';
    } else {
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          movies = results;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load movies for ${widget.category}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading movies: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMoviesByCategory();
  }

  void _navigateToMovieDetails(BuildContext context, dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06041F),
        elevation: 0,
        centerTitle: true,
        title: Text(
         
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            
            
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              : movies!.isEmpty
                  ? const Center(
                      child: Text(
                        'No movies found for this category.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: movies!.length,
                        itemBuilder: (context, index) {
                          final movie = movies![index];
                          return GestureDetector(
                            onTap: () =>
                                _navigateToMovieDetails(context, movie),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                '$imageBaseUrl${movie['poster_path']}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[900],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}