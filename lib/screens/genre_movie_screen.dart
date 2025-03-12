import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class GenreMoviesScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreMoviesScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<MovieProvider>(context, listen: false)
          .fetchMoviesByGenre(widget.genreId)
          .then((_) {
        setState(() {}); // Force UI update
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieProvider.genreMovies.isEmpty
              ? Center(
                  child: Text(
                    'No movies found for "${widget.genreName}".',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.55, // Taller cards
                    ),
                    itemCount: movieProvider.genreMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: movieProvider.genreMovies[index],
                      );
                    },
                  ),
                ),
    );
  }
}
