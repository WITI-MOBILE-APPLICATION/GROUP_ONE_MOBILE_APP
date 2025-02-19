import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class GenreMoviesScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  GenreMoviesScreen(
      {super.key, required this.genreId, required this.genreName});

  @override
  // ignore: library_private_types_in_public_api
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MovieProvider>(context, listen: false)
        .fetchMoviesByGenre(widget.genreId);
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        backgroundColor: Colors.blueAccent,
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: movieProvider.genreMovies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: movieProvider.genreMovies[index]);
              },
            ),
    );
  }
}
