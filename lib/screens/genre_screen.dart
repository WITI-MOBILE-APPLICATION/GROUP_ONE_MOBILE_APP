// @dart=2.17

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/genre.dart';
import 'genre_movie_screen.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch genres when the screen initializes
    Provider.of<MovieProvider>(context, listen: false).fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres'),
        backgroundColor: Colors.blueAccent,
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movieProvider.genres.length,
              itemBuilder: (context, index) {
                final Genre genre = movieProvider.genres[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: genre.image != null
                        ? NetworkImage(genre.image!)
                        : const AssetImage('assets/placeholder.png')
                            as ImageProvider,
                  ),
                  title: Text(genre.name),
                  subtitle:
                      Text(genre.description ?? "No description available"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenreMoviesScreen(
                            genreId: genre.id, genreName: genre.name),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
