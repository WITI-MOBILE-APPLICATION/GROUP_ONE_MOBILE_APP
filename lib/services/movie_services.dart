// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import '../models/movie.dart';

// class ApiService {
//   static const String baseUrl = 'https://api.themoviedb.org/3';
//   static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

//   Future<List<Movie>> fetchMovies() async {
//     const String imageBaseUrl =
//         'https://image.tmdb.org/t/p/w500'; // ✅ Fix: Image base URL
//     final response =
//         await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final List<dynamic> moviesJson =
//           data['results']; // ✅ Extract JSON list properly
//       return moviesJson
//           .map<Movie>((json) => Movie.fromJson(json, imageBaseUrl))
//           .toList(); // ✅ Explicitly map to `Movie`
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   }
// }
