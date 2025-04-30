// @dart=2.17

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'movie_detail_screen.dart';
import 'search_screen.dart';
import 'category_screen.dart';
import 'download_screen.dart';
import 'profile_screen.dart';
import 'saved.dart';
import 'payment_screen.dart';
import 'app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class SubscribePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFF2A2E43),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!
                          .translate('subscribe_premium') ??
                      'Be a Premium User and Get More Features',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildFeatureItem(
                    AppLocalizations.of(context)!.translate('ad_free') ??
                        'Ad Free'),
                _buildFeatureItem(AppLocalizations.of(context)!
                        .translate('access_all_videos') ??
                    'Get Access to All Videos'),
                _buildFeatureItem(
                    AppLocalizations.of(context)!.translate('cancel_anytime') ??
                        'Cancel Anytime and Anywhere'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoucherScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Subscribe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            feature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class VoucherScreen extends StatefulWidget {
  @override
  VoucherScreenState createState() => VoucherScreenState();
}

class VoucherScreenState extends State<VoucherScreen> {
  String? selectedVoucher;

  final Map<String, Map<String, dynamic>> voucherDetails = {
    'Voucher 1': {'packageName': 'Premium Daily', 'price': 5.0},
    'Voucher 2': {'packageName': 'Premium Weekly', 'price': 50.0},
    'Voucher 3': {'packageName': 'Premium Monthly', 'price': 100.0},
    'Voucher 4': {'packageName': 'Premium Yearly', 'price': 900.0},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06041F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.translate('choose_package') ??
                      'Choose Your Favorite Package',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 30),
                _buildVoucherOption('Voucher 1'),
                _buildVoucherOption('Voucher 2'),
                _buildVoucherOption('Voucher 3'),
                _buildVoucherOption('Voucher 4'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherOption(String voucherName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2E43),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: voucherName,
                      groupValue: selectedVoucher,
                      onChanged: (value) {
                        setState(() {
                          selectedVoucher = value;
                        });
                      },
                      activeColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate(
                                  voucherDetails[voucherName]!['packageName']
                                      .toLowerCase()
                                      .replaceAll(' ', '_')) ??
                              voucherDetails[voucherName]!['packageName'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '\$${voucherDetails[voucherName]!['price'].toStringAsFixed(0)}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!
                                  .translate('voucher_code_coming_soon') ??
                              'Voucher Code Input Coming Soon',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!
                            .translate('have_voucher_code') ??
                        'Have a Voucher Code',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: selectedVoucher == voucherName
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          voucher: voucherName,
                          packageName:
                              voucherDetails[voucherName]!['packageName'],
                          price: voucherDetails[voucherName]!['price'],
                        ),
                      ),
                    );
                  }
                : null,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: selectedVoucher == voucherName
                    ? Colors.red
                    : Colors.grey.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('apply') ?? 'Apply',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
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
    'TV Movie',
  ];
  String selectedCategory = 'All';
  String? errorMessage;

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 0;
  bool _hasShownPopup = false;

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
    fetchPopularMovies();
    fetchLatestMovies();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleSubscriptionPopup();
    });
  }

  void _scheduleSubscriptionPopup() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!_hasShownPopup && mounted) {
        setState(() {
          _hasShownPopup = true;
        });
        _showSubscriptionPopup();
      }
    });
  }

  void _showSubscriptionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SubscribePopup(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
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
        throw Exception(
            AppLocalizations.of(context)!.translate('failed_load_trending') ??
                'Failed to Load Trending Movies');
      }
    } catch (e) {
      setState(() {
        errorMessage =
            AppLocalizations.of(context)!.translate('error_trending') ??
                'Error Loading Trending Movies: $e';
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
        throw Exception(
            AppLocalizations.of(context)!.translate('failed_load_popular') ??
                'Failed to Load Popular Movies');
      }
    } catch (e) {
      setState(() {
        errorMessage = errorMessage == null
            ? AppLocalizations.of(context)!.translate('error_popular') ??
                'Error Loading Popular Movies: $e'
            : '$errorMessage\n${AppLocalizations.of(context)!.translate('error_popular') ?? 'Error Loading Popular Movies: $e'}';
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
        throw Exception(
            AppLocalizations.of(context)!.translate('failed_load_latest') ??
                'Failed to Load Latest Movies');
      }
    } catch (e) {
      setState(() {
        errorMessage = errorMessage == null
            ? AppLocalizations.of(context)!.translate('error_latest') ??
                'Error Loading Latest Movies: $e'
            : '$errorMessage\n${AppLocalizations.of(context)!.translate('error_latest') ?? 'Error Loading Latest Movies: $e'}';
      });
    }
  }

  void _navigateToCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    if (category != 'All') {
      print('Navigating to CategoryScreen for: $category');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category),
        ),
      );
    } else {
      print('Staying on HomeScreen for category: All');
    }
  }

  void _navigateToMovieDetails(BuildContext context, dynamic movie) {
    if (movie['vote_average'] != null && movie['vote_average'] > 7.5) {
      _showSubscriptionPopup();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
    );
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (trendingMovies != null && trendingMovies!.isNotEmpty) {
        if (_currentPage <
            (trendingMovies!.length > 5 ? 5 : trendingMovies!.length) - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(apiKey: apiKey),
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
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SavedMoviesScreen()),
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
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.translate('home') ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label:
                  AppLocalizations.of(context)!.translate('search') ?? 'Search',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark),
              label:
                  AppLocalizations.of(context)!.translate('saved') ?? 'Saved',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.download),
              label: AppLocalizations.of(context)!.translate('downloads') ??
                  'Downloads',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.translate('profile') ??
                  'Profile',
            ),
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
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black12,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  right: 20,
                                  child: Text(
                                    movie['title'] ??
                                        AppLocalizations.of(context)!
                                            .translate('unknown') ??
                                        'Unknown',
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('categories') ??
                            'Categories',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllCategoriesScreen(
                                    categories: categories, apiKey: apiKey)),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate('see_all') ??
                              'See All',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length > 8 ? 8 : categories.length,
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
                              AppLocalizations.of(context)!.translate(category
                                      .toLowerCase()
                                      .replaceAll(' ', '_')) ??
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                                .translate('most_popular') ??
                            'Most Popular',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
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
                        child: Text(
                          AppLocalizations.of(context)!.translate('see_all') ??
                              'See All',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                                .translate('latest_movies') ??
                            'Latest Movies',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
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
                        child: Text(
                          AppLocalizations.of(context)!.translate('see_all') ??
                              'See All',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
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

class AllCategoriesScreen extends StatefulWidget {
  final List<String> categories;
  final String apiKey;

  const AllCategoriesScreen(
      {super.key, required this.categories, required this.apiKey});

  @override
  AllCategoriesScreenState createState() => AllCategoriesScreenState();
}

class AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w500/';
  Map<String, String?> categoryThumbnails = {};
  bool isLoading = true;
  String? errorMessage;

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
        errorMessage =
            AppLocalizations.of(context)!.translate('error_thumbnails') ??
                'Error Loading Thumbnails: $e';
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
        title: Text(
          AppLocalizations.of(context)!.translate('all_categories') ??
              'All Categories',
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
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) {
                      final category = widget.categories[index];
                      final thumbnailPath = categoryThumbnails[category];
                      return GestureDetector(
                        onTap: () {
                          if (category != 'All') {
                            print(
                                'Navigating to CategoryScreen for: $category');
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
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black12,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                          category
                                              .toLowerCase()
                                              .replaceAll(' ', '_')) ??
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

class PopularMoviesScreen extends StatefulWidget {
  final String apiKey;
  final String popularMoviesUrl;

  const PopularMoviesScreen(
      {super.key, required this.apiKey, required this.popularMoviesUrl});

  @override
  PopularMoviesScreenState createState() => PopularMoviesScreenState();
}

class PopularMoviesScreenState extends State<PopularMoviesScreen> {
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
      final response = await http.get(
          Uri.parse('${widget.popularMoviesUrl}?api_key=${widget.apiKey}'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        setState(() {
          movies = results;
          isLoading = false;
        });
      } else {
        throw Exception(
            AppLocalizations.of(context)!.translate('failed_load_popular') ??
                'Failed to Load Popular Movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            AppLocalizations.of(context)!.translate('error_popular') ??
                'Error Loading Popular Movies: $e';
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
        title: Text(
          AppLocalizations.of(context)!.translate('popular_movies') ??
              'Popular Movies',
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
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!
                                .translate('no_movies_found') ??
                            'No Movies Found',
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

class LatestMoviesScreen extends StatefulWidget {
  final String apiKey;
  final String latestMoviesUrl;

  const LatestMoviesScreen(
      {super.key, required this.apiKey, required this.latestMoviesUrl});

  @override
  LatestMoviesScreenState createState() => LatestMoviesScreenState();
}

class LatestMoviesScreenState extends State<LatestMoviesScreen> {
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
        throw Exception(
            AppLocalizations.of(context)!.translate('failed_load_latest') ??
                'Failed to Load Latest Movies');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage =
            AppLocalizations.of(context)!.translate('error_latest') ??
                'Error Loading Latest Movies: $e';
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
        title: Text(
          AppLocalizations.of(context)!.translate('latest_movies') ??
              'Latest Movies',
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
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!
                                .translate('no_movies_found') ??
                            'No Movies Found',
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
