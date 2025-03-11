import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? ''; // 🔒 Secure API Key
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500'; // ✅ Image URL

  List<Movie> _trendingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> genreMovies = [];

  bool isLoading = false;

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;

  /// 🚀 Fetch all movie categories asynchronously
  Future<void> fetchMovies() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _fetchTrendingMovies(),
        _fetchTopRatedMovies(),
        _fetchUpcomingMovies(),
      ]);
    } catch (error) {
      debugPrint('❌ Error fetching movies: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔥 Fetch Trending Movies
  Future<void> _fetchTrendingMovies() async {
    final url = '$_baseUrl/movie/popular?api_key=$_apiKey';
    await _fetchMovies(url, (movies) => _trendingMovies = movies);
  }

  /// 🌟 Fetch Top Rated Movies
  Future<void> _fetchTopRatedMovies() async {
    final url = '$_baseUrl/movie/top_rated?api_key=$_apiKey';
    await _fetchMovies(url, (movies) => _topRatedMovies = movies);
  }

  /// 🎬 Fetch Upcoming Movies
  Future<void> _fetchUpcomingMovies() async {
    final url = '$_baseUrl/movie/upcoming?api_key=$_apiKey';
    await _fetchMovies(url, (movies) => _upcomingMovies = movies);
  }

  /// 🎭 Fetch Movies by Genre
  Future<void> fetchMoviesByGenre(int genreId) async {
    isLoading = true;
    notifyListeners();

    final url = '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data');

        genreMovies = (data['results'] as List)
            .map((movieData) => Movie.fromJson(movieData, _imageBaseUrl))
            .toList();
      } else {
        throw Exception('Failed to load movies by genre');
      }
    } catch (error) {
      genreMovies = []; // Clear on error
      debugPrint('❌ Error fetching movies by genre: $error');
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔄 Generic function to fetch movies
  Future<void> _fetchMovies(
      String url, Function(List<Movie>) updateList) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Movie> movies = (data['results'] as List)
            .map((json) => Movie.fromJson(json, _imageBaseUrl))
            .toList();
        updateList(movies);
      } else {
        debugPrint('⚠️ API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      debugPrint('❌ Network Error: $error');
    }
  }

  void fetchGenres() {}
}
