// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'movie_detail_screen.dart';
import '../services/download_services.dart';
import '../screens/download_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = 'ab0608ff77e9b69c9583e1e673f95115';
  final String trendingMoviesUrl =
      'https://api.themoviedb.org/3/trending/movie/week';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  List<dynamic>? trendingMovies;
  List<dynamic> filteredMovies = [];
  final List<String> categories = ['All', 'Action', 'Comedy', 'Romance'];
  String selectedCategory = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response =
          await http.get(Uri.parse('$trendingMoviesUrl?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          trendingMovies = results;
          filteredMovies = results;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movies: $e')),
      );
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
    Navigator.pushNamed(
      context,
      '/movie_detail',
      arguments: movie,
    );
  }

  void _downloadThumbnail(BuildContext context, dynamic movie) async {
    final downloadServices = Provider.of<DownloadServices>(context, listen: false);
    try {
      await downloadServices.downloadThumbnail(
        movie['id'].toString(),
        movie['title'],
        '$imageBaseUrl${movie['poster_path']}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie['title']} thumbnail downloaded')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF06041F),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              break;
            case 1: // Search (implement as needed)
              break;
            case 2: // Saved (implement as needed)
              break;
            case 3: // Downloads
              Navigator.pushNamed(context, '/downloads');
              break;
            case 4: // Profile
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Downloads'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Movies (PageView)
                  Container(
                    height: 250,
                    child: PageView.builder(
                      itemCount: trendingMovies!.length > 5 ? 5 : trendingMovies!.length,
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
                                        Colors.black.withOpacity(0.7),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                    icon: const Icon(Icons.download, color: Colors.white),
                                    onPressed: () => _downloadThumbnail(context, movie),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      trendingMovies!.length > 5 ? 5 : trendingMovies!.length,
                                      (dotIndex) => Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
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
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Categories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: selectedCategory == category ? Colors.red : Colors.grey[900],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: selectedCategory == category ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Most Popular
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Most Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredMovies.length > 5 ? 5 : filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _navigateToMovieDetails(context, movie),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        '$imageBaseUrl${movie['poster_path']}',
                                        height: 160,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 160,
                                            width: 120,
                                            color: Colors.grey[800],
                                            child: const Icon(Icons.broken_image, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: const Icon(Icons.download, color: Colors.white, size: 20),
                                      onPressed: () => _downloadThumbnail(context, movie),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                movie['title'] ?? 'Unknown',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Latest Movies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Latest Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredMovies.length > 5 ? 5 : filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _navigateToMovieDetails(context, movie),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        '$imageBaseUrl${movie['poster_path']}',
                                        height: 160,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 160,
                                            width: 120,
                                            color: Colors.grey[800],
                                            child: const Icon(Icons.broken_image, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: const Icon(Icons.download, color: Colors.white, size: 20),
                                      onPressed: () => _downloadThumbnail(context, movie),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                movie['title'] ?? 'Unknown',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
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