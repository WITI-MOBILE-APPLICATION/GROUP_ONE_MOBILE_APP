import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'movie_detail_screen.dart';
import 'search_screen.dart';
import 'category_screen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  final List<String> categories = [
    'All',
    'Action',
    'Comedy',
    'Romance',
    'Drama',
    'Horror',
    'Science Fiction',
    'Thriller',
    'Adventure',
    'Animation',
    'Fantasy',
    'Crime',
    'Mystery',
    'Family',
    'Documentary',
    'History',
    'Music',
    'War',
    'Western',
    'TV Movie'
  ];
  String selectedCategory = 'All';
  String? errorMessage;

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Optional: Enable full-screen mode (uncomment if desired)
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    // Optional: Restore system UI (uncomment if full-screen enabled)
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      final response =
          await http.get(Uri.parse('$trendingMoviesUrl?api_key=$apiKey'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          trendingMovies = results;
        });
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading trending movies: $e';
      });
    }
  }

  Future<void> fetchPopularMovies() async {
    try {
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
    } catch (e) {
      setState(() {
        errorMessage = errorMessage == null
            ? 'Error loading popular movies: $e'
            : '$errorMessage\nError loading popular movies: $e';
      });
    }
  }

  Future<void> fetchLatestMovies() async {
    try {
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
    } catch (e) {
      setState(() {
        errorMessage = errorMessage == null
            ? 'Error loading latest movies: $e'
            : '$errorMessage\nError loading latest movies: $e';
      });
    }
  }

  void _navigateToCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    if (category != 'All') {
      print('Navigating to CategoryScreen for: $category'); // Debug print
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category),
        ),
      );
    } else {
      print('Staying on HomeScreen for category: All'); // Debug print
    }
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
      backgroundColor: const Color(0xFF06041F),
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
      body: trendingMovies == null ||
              popularMovies == null ||
              latestMovies == null
          ? Center(
              child: errorMessage != null
                  ? Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    )
                  : const CircularProgressIndicator(),
            )
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllCategoriesScreen(
                                      categories: categories, apiKey: apiKey)),
                            );
                          },
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
                      itemCount: categories.length > 8
                          ? 8
                          : categories.length, // Limit to 8 for UI
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () => _navigateToCategory(category),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PopularMoviesScreen(
                                      apiKey: apiKey,
                                      popularMoviesUrl: popularMoviesUrl)),
                            );
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LatestMoviesScreen(
                                      apiKey: apiKey,
                                      latestMoviesUrl: latestMoviesUrl)),
                            );
                          },
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

// Screen for displaying all categories with thumbnails
class AllCategoriesScreen extends StatefulWidget {
  final List<String> categories;
  final String apiKey;

  const AllCategoriesScreen(
      {super.key, required this.categories, required this.apiKey});

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  Map<String, String?> categoryThumbnails = {};
  bool isLoading = true;
  String? errorMessage;

  // Map category to TMDB genre ID (same as CategoryScreen)
  int? getGenreId(String category) {
    switch (category) {
      case 'All':
        return null;
      case 'Action':
        return 28;
      case 'Comedy':
        return 35;
      case 'Romance':
        return 10749;
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
      case 'Fantasy':
        return 14;
      case 'Crime':
        return 80;
      case 'Mystery':
        return 9648;
      case 'Family':
        return 10751;
      case 'Documentary':
        return 99;
      case 'History':
        return 36;
      case 'Music':
        return 10402;
      case 'War':
        return 10752;
      case 'Western':
        return 37;
      case 'TV Movie':
        return 10770;
      default:
        return -1;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchThumbnails();
  }

  Future<void> fetchThumbnails() async {
    try {
      for (String category in widget.categories) {
        final genreId = getGenreId(category);
        if (genreId == -1) {
          categoryThumbnails[category] = null;
          continue;
        }

        String url;
        if (genreId == null) {
          // For "All", fetch a popular movie
          url =
              'https://api.themoviedb.org/3/discover/movie?api_key=${widget.apiKey}&sort_by=popularity.desc';
        } else {
          url =
              'https://api.themoviedb.org/3/discover/movie?api_key=${widget.apiKey}&with_genres=$genreId&sort_by=popularity.desc';
        }

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final results = json.decode(response.body)['results'];
          if (results.isNotEmpty) {
            categoryThumbnails[category] = results[0]['poster_path'];
          } else {
            categoryThumbnails[category] = null;
          }
        } else {
          categoryThumbnails[category] = null;
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading thumbnails: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06041F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'All Categories',
          style: TextStyle(
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7, // Adjusted for thumbnail focus
                    ),
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) {
                      final category = widget.categories[index];
                      final thumbnailPath = categoryThumbnails[category];
                      return GestureDetector(
                        onTap: () {
                          if (category != 'All') {
                            print(
                                'Navigating to CategoryScreen for: $category'); // Debug
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryScreen(category: category),
                              ),
                            );
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              thumbnailPath != null
                                  ? Image.network(
                                      '$imageBaseUrl$thumbnailPath',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[900],
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[900],
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                    ),
                              Container(
                                decoration: BoxDecoration(
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
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

// Screen for displaying all popular movies
class PopularMoviesScreen extends StatefulWidget {
  final String apiKey;
  final String popularMoviesUrl;

  const PopularMoviesScreen(
      {super.key, required this.apiKey, required this.popularMoviesUrl});

  @override
  _PopularMoviesScreenState createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  List<dynamic>? movies;
  bool isLoading = true;
  String? errorMessage;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.popularMoviesUrl}?api_key=${widget.apiKey}'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          movies = results;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading popular movies: $e';
      });
    }
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
        title: const Text(
          'Popular Movies',
          style: TextStyle(
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
                        'No movies found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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

// Screen for displaying all latest movies
class LatestMoviesScreen extends StatefulWidget {
  final String apiKey;
  final String latestMoviesUrl;

  const LatestMoviesScreen(
      {super.key, required this.apiKey, required this.latestMoviesUrl});

  @override
  _LatestMoviesScreenState createState() => _LatestMoviesScreenState();
}

class _LatestMoviesScreenState extends State<LatestMoviesScreen> {
  List<dynamic>? movies;
  bool isLoading = true;
  String? errorMessage;
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http
          .get(Uri.parse('${widget.latestMoviesUrl}?api_key=${widget.apiKey}'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          movies = results;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load latest movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading latest movies: $e';
      });
    }
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
        title: const Text(
          'Latest Movies',
          style: TextStyle(
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
                        'No movies found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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