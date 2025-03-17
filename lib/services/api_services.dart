import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    final Uri url = Uri.parse('$_baseUrl$endpoint').replace(
      queryParameters: {'api_key': _apiKey, ...?queryParams},
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('API Error: $error');
      throw Exception('Failed to fetch data');
    }
  }
}
