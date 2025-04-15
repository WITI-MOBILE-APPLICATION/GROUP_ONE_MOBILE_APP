// lib/screens/download_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/download_services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late Future<List<Map<String, dynamic>>> _downloadedMoviesFuture;

  @override
  void initState() {
    super.initState();
    final downloadServices = Provider.of<DownloadServices>(context, listen: false);
    _downloadedMoviesFuture = downloadServices.getDownloadedMovies();
  }

  void _refreshDownloads() {
    setState(() {
      final downloadServices = Provider.of<DownloadServices>(context, listen: false);
      _downloadedMoviesFuture = downloadServices.getDownloadedMovies();
    });
  }

  void _deleteMovie(String movieId) async {
    final downloadServices = Provider.of<DownloadServices>(context, listen: false);
    final success = await downloadServices.deleteDownloadedMovie(movieId);
    if (success) {
      _refreshDownloads();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDownloads,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _downloadedMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading downloads: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          final downloadedMovies = snapshot.data ?? [];
          if (downloadedMovies.isEmpty) {
            return const Center(
              child: Text(
                'No downloads yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: downloadedMovies.length,
            itemBuilder: (context, index) {
              final movie = downloadedMovies[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(
                          movie['path'], // On web, 'path' is the URL
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 75,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.white),
                            );
                          },
                        )
                      : Image.file(
                          File(movie['path']), // On non-web, 'path' is the file path
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 75,
                              color: Colors.grey[800],
                              child: const Icon(Icons.broken_image, color: Colors.white),
                            );
                          },
                        ),
                ),
                title: Text(
                  movie['title'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Downloaded on ${movie['downloadDate']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteMovie(movie['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}